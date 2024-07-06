/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>MAY 24, 2023</date>
/////////////////////////////////////////////////////////

import 'dart:async';
import 'dart:ui';
import 'package:clickclinician/screens/service_req_tabs_screen.dart';
import 'package:clickclinician/shared/firebase.dart';
import 'package:clickclinician/shared/notifications_services.dart';
import 'package:clickclinician/utility/utils.dart';
import 'package:clickclinician/utility/widget_file.dart';
import 'package:clickclinician/widgets/popup_menus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../shared/api_calls.dart';
import '../shared/device_info.dart';
import '../shared/models/service_request.dart';
import '../widgets/nav_drawer.dart';
import '../widgets/shared.dart';
import 'service_request_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  final String title = "Click Clinician";
  static const String routeName = "/mapScreen";

  @override
  State<MapScreen> createState() => MapScreenState();
}

/////////////////////////////
/// Google Maps Zoom level
///--------------------------
///    1:  World.
///    5:  Landmass/continent.
///    10: City.
///    15: Streets.
///    20: Buildings.
/////////////////////////////

class MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  late String _mapStyleString;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final NotificationServices notificationServices = NotificationServices();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static final List<Marker> _markers = <Marker>[];
  static final List<Circle> _circles = <Circle>[];
  int markerIndex = -1;

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await FirebaseMessenger.initializeFirebase();
    debugPrint(
        'in main page the value of token: ${message.notification!.title.toString()}');
  }

  static const CameraPosition _cameraAustin = CameraPosition(
    // Autin, Texas = 30.2672° N, 97.7431° W
    target: LatLng(30.2672, -97.7431),
    zoom: 10,
  );

  static const CameraPosition _cameraSanAntonio = CameraPosition(
    // San Antonio, Texas = 29.4252° N, 98.4946° W
    target: LatLng(29.4252, -98.4946),
    zoom: 10,
  );

  static const CameraPosition _cameraVictoria = CameraPosition(
    // // San Antonio, Texas = 48.4284° N, 123.3656° W
    // Victoria, Texas = 28.8053° N, -97.0036° W
    // target: LatLng(48.4284, -123.3656),
    target: LatLng(28.8053, -97.0036),
    zoom: 10,
  );

  static const CameraPosition _cameraDefault = _cameraSanAntonio;
  static CameraPosition _cameraPosition = _cameraDefault;
  static const _navigationBar = NavDrawer();

  Future<Position> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return Position(
          longitude: _cameraDefault.target.longitude,
          latitude: _cameraDefault.target.latitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0);
    }

    return await _geolocatorPlatform.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.medium));
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<CameraPosition> loadMarkers(context) async {
    List<ServiceRequest> list =
        await ApiCalls.getAllServiceRequests('', context);

    _markers.clear();
    _circles.clear();

    for (int i = 0; i < list.length; i++) {
      var request = list[i];
      LatLng latLng = LatLng(request.approxLatitude, request.approxLongitude);

      Marker marker = Marker(
        markerId: MarkerId(request.id),
        position: latLng,
        icon: request.serviceRequestType != null
            ? request.serviceRequestType == 'accepted'
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue,
                  )
                : request.serviceRequestType == 'open'
                    ? BitmapDescriptor.defaultMarker
                    : BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen,
                      )
            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        infoWindow: InfoWindow(
          title: request.priority,
          snippet: request.patientFirstName,
        ),
        visible: true,
        // consumeTapEvents: true,
        onTap: () {
          showServiceRequestPopup(context, request, true);
          print('clicked on marker in map screen');
        },
      );

      _markers.add(marker);

      Circle circle = Circle(
        circleId: CircleId(request.id),
        center: latLng,
        radius: 800, // Radius in meters ( 0.5 miles * 1.6 km per mile * 1000)
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      );

      _circles.add(circle);

      // TODO Make this a user setting
      if (i > 30) {
        break;
      }
    }

    return _cameraPosition;
  }

  void _setCamera(CameraPosition cameraPosition) async {
    _mapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    ClickDeviceInfo deviceInfo = ClickDeviceInfo();
    deviceInfo.initPlatformState(context);
    ApiCalls.init();
    notificationServices.firebaseInit(context);
    // notificationServices.setupInteractMessage(context);
    // notificationServices.requestNotificationPermisson();
    // notificationServices.isTokenRefresh();
    // notificationServices.getDeviceToken().then((value) {
    //   debugPrint('device token');
    //   debugPrint('in main page the value of token: $value');
    // });
    // FirebaseMessenger.initializeFirebase();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessenger.setupInteractMessage(context);

    _getCurrentPosition().then(
      (value) => _cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: _cameraDefault.zoom),
    );

    rootBundle.loadString('assets/map_styles.json').then((string) {
      _mapStyleString = string;
    });

    super.initState();
    // ApiCalls.whoami(context);
  }

  Future<CameraPosition> fetchData(context) {
    return loadMarkers(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraPosition>(
        future: fetchData(context),
        builder:
            (BuildContext context, AsyncSnapshot<CameraPosition> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            ); // Display a loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Display an error message
          } else {
            CameraPosition? cameraPosition = snapshot.data;

            return SafeArea(
              child: Scaffold(
                key: _scaffoldKey,
                // floatingActionButton: ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.lightBlue,
                //       foregroundColor: Colors.white),
                //   onPressed: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => ServiceRequestsScreen()));
                //   },
                //   child: const Text('Service Requests'),
                // ),
                // floatingActionButtonLocation:
                //     FloatingActionButtonLocation.centerFloat,
                backgroundColor: Colors.white,
                drawer: _navigationBar,
                body: SingleChildScrollView(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top,
                        child: GoogleMap(
                          mapType: MapType.terrain,
                          initialCameraPosition:
                              cameraPosition ?? _cameraDefault,
                          myLocationButtonEnabled: true,
                          gestureRecognizers: <Factory<
                              OneSequenceGestureRecognizer>>{
                            Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                            ),
                          },
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                            _mapController.setMapStyle(_mapStyleString);
                          },
                          markers: Set<Marker>.of(_markers),
                          circles: Set<Circle>.of(_circles),
                          compassEnabled: true,
                          onTap: (val) {
                            print('value in map screen press: $val');
                          },
                          myLocationEnabled: true,
                        ),
                      ),
                      Positioned(
                        top: 24,
                        left: 24,
                        child: GestureDetector(
                          onTap: () {
                            _scaffoldKey.currentState!.openDrawer();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.25),
                              shape: BoxShape.circle,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.menu_open_sharp,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 32,
                        left: 16,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _setCamera(_cameraAustin);
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Au",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            DesignWidgets.addVerticalSpace(12.0),
                            GestureDetector(
                              onTap: () {
                                _setCamera(_cameraSanAntonio);
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    "SA",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            DesignWidgets.addVerticalSpace(12.0),
                            GestureDetector(
                              onTap: () {
                                _setCamera(_cameraVictoria);
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Vic",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
