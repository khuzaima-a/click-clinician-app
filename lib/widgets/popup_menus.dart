/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>JUNE 1, 2023</date>
/////////////////////////////////////////////////////////

import 'package:clickclinician/screens/accepted_requests_screen.dart';
import 'package:clickclinician/screens/map_screen.dart';
import 'package:clickclinician/screens/service_req_tabs_screen.dart';
import 'package:clickclinician/screens/service_request_screen.dart';
import 'package:clickclinician/utility/color_file.dart';
import 'package:clickclinician/utility/style_file.dart';
import 'package:clickclinician/utility/widget_file.dart';
import 'package:clickclinician/widgets/const/custom_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:clickclinician/shared/api_calls.dart';
import 'package:clickclinician/shared/models/service_request.dart';

class ServiceRequestPopup extends StatefulWidget {
  final ServiceRequest request;
  final bool? mapScreen;

  const ServiceRequestPopup({Key? key, required this.request, this.mapScreen})
      : super(key: key);

  @override
  _ServiceRequestPopupState createState() => _ServiceRequestPopupState();
}

class _ServiceRequestPopupState extends State<ServiceRequestPopup> {
  late LatLng latLng;
  late CameraPosition cameraPosition;
  late bool _isLoading = false;
  late bool _isAccepting = false;
  late bool _isDeclining = false;
  late bool _isAcceptingAndPassing = false;
  String? specialNotes;

  @override
  void initState() {
    super.initState();
    latLng =
        LatLng(widget.request.approxLatitude, widget.request.approxLongitude);
    cameraPosition = CameraPosition(target: latLng, zoom: 16);
    _fetchData(context).then((_) => {
          setState(() {
            _isLoading = false;
          })
        });
  }

  Future<void> _fetchData(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    var json = await ApiCalls.getServiceRequest(widget.request.id, context);
    if (json.toString().isNotEmpty) {
      print('the fetched data: $json');
      setState(() {
        // specialNotes = json['SpecialNotes'].toString().isNotEmpty
        //     ? json['SpecialNotes'].toString() == ''
        //         ? 'N/A'
        //         : json['SpecialNotes']
        //     : 'N/A';
        if (json['SpecialNotes'].toString().isNotEmpty) {
          specialNotes = json['SpecialNotes'] ?? 'N/A';
        }
        if (json['SpecialNotes'].toString() == '') {
          specialNotes = 'N/A';
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 16.0, bottom: 16.0, left: 0.0, right: 0.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Service Request",
                        style: CustomStyles.headingText,
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.cancel,
                            color: ColorsUI.primaryColor,
                            size: 26.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                DesignWidgets.addVerticalSpace(16.0),
                Container(
                  color: Colors.amberAccent,
                  height: 300,
                  width: w,
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: GoogleMap(
                      mapToolbarEnabled: false,
                      mapType: MapType.normal,
                      myLocationButtonEnabled: false,
                      initialCameraPosition: cameraPosition,
                      onMapCreated: (controller) {},
                      circles: {
                        Circle(
                          circleId: CircleId(widget.request.id),
                          center: latLng,
                          radius: 150,
                          fillColor: Colors.blue.withOpacity(0.2),
                          strokeColor: Colors.blue,
                          strokeWidth: 2,
                          visible: true,
                        )
                      },
                      markers: {
                        Marker(
                          markerId: MarkerId(widget.request.id),
                          position: latLng,
                          icon: widget.request.serviceRequestType != null
                              ? widget.request.serviceRequestType == 'accepted'
                                  ? BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueBlue,
                                    )
                                  : widget.request.serviceRequestType == 'open'
                                      ? BitmapDescriptor.defaultMarker
                                      : BitmapDescriptor.defaultMarkerWithHue(
                                          BitmapDescriptor.hueGreen,
                                        )
                              : BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueYellow),
                        )
                      },
                    ),
                  ),
                ),
                DesignWidgets.addVerticalSpace(8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      buildDetailItem(
                          'Special Notes', _isLoading ? "..." : specialNotes!),
                      DesignWidgets.addVerticalSpace(4.0),
                      Stack(
                        children: [
                          Positioned(
                            bottom: -75,
                            right: -120,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.lightBlue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: ColorsUI.primaryColor.withOpacity(0.05),
                              border: Border.all(
                                  width: 1,
                                  color: Colors.blue.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Row(
                                  children: [
                                    const Center(
                                        child: Icon(
                                      Icons.account_circle_rounded,
                                      color: ColorsUI.primaryColor,
                                      size: 72,
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.request.patientFirstName ==
                                                    ''
                                                ? 'Name: N/A'
                                                : widget
                                                    .request.patientFirstName!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: ColorsUI.headingColor,
                                            ),
                                          ),
                                          DesignWidgets.addVerticalSpace(4.0),
                                          Row(
                                            children: [
                                              Text(
                                                "Priority: ",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: ColorsUI.headingColor
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                              DesignWidgets.addHorizontalSpace(
                                                  4.0),
                                              Text(
                                                widget.request.priority,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: ColorsUI.headingColor
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                            ],
                                          ),
                                          DesignWidgets.addVerticalSpace(8.0),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 6.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.25),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Text(
                                                    widget.request.patientSex !=
                                                            null
                                                        ? (widget.request
                                                                    .patientSex) ==
                                                                2
                                                            ? 'Other'
                                                            : (widget.request
                                                                        .patientSex) ==
                                                                    1
                                                                ? 'Male'
                                                                : 'Female'
                                                        : 'Gender: N/A',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black)),
                                              ),
                                              DesignWidgets.addHorizontalSpace(
                                                  8.0),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 6.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.25),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Text(
                                                    (widget.request
                                                                .patientAge ??
                                                            'Age: N/A')
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                      DesignWidgets.addVerticalSpace(8.0),
                      if (ApiCalls.clickUser?.userType?.canPass != null &&
                          ApiCalls.clickUser!.userType!.canPass == true &&
                          widget.request.canBePassed == true &&
                          (widget.request.serviceRequestType != 'evaluated' &&
                              widget.request.serviceRequestType != 'accepted'))
                        DesignWidgets.getButton(
                          text: "Accept & Pass",
                          onTap: () {
                            ApiCalls.acceptAndPassRequest(
                                widget.request.id, context, (val) {
                              setState(() {
                                _isAcceptingAndPassing = val;
                              });
                            }).then(
                              (value) => Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MapScreen();
                              })),
                            );
                          },
                          margin: 4,
                        ),
                      Visibility(
                        visible: widget.request.serviceRequestType !=
                                'accepted' &&
                            widget.request.serviceRequestType != 'evaluated',
                        child: Row(
                          children: [
                            Expanded(
                              child: DesignWidgets.getButton(
                                text: "Accept",
                                onTap: () {
                                  ApiCalls.acceptRequest(
                                      widget.request.id, context, (val) {
                                    setState(() {
                                      _isAccepting = val;
                                    });
                                  });
                                },
                                backgroundColor: Colors.white,
                                foregroundColor: ColorsUI.primaryColor,
                                borderColor: ColorsUI.primaryColor,
                                elevate: false,
                                margin: 4,
                              ),
                            ),
                            Expanded(
                              child: DesignWidgets.getButton(
                                text: "Decline",
                                onTap: () {
                                  ApiCalls.declineRequest(
                                      widget.request.id, context, (val) {
                                    setState(() {
                                      _isDeclining = val;
                                    });
                                  }).then(
                                    (value) => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return MapScreen();
                                      }),
                                    ),
                                  );
                                },
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.red,
                                borderColor: Colors.red,
                                elevate: false,
                                margin: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // return Dialog(
    //   backgroundColor: Colors.white,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(24.0),
    //       ),
    //   // icon: IconButton(
    //   //   icon: const Icon(Icons.close_rounded),
    //   //   onPressed: () {
    //   //     debugPrint('clicked on close icon');
    //   //     Navigator.of(context).pop(); // Close the popup
    //   //   },
    //   // ),
    //   elevation: 5.0,
    //   // title: Center(
    //   //   child: Text(
    //   //     widget.request.patientFirstName == null
    //   //         ? 'N/A'
    //   //         : widget.request.patientFirstName == ''
    //   //             ? 'Service Request'
    //   //             : widget.request.patientFirstName!,
    //   //     style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
    //   //   ),
    //   // ),
    //   child: Container(
    //     color: Colors.amberAccent,
    //     height: 300,
    //     width: w,
    //     child: SizedBox(
    //       width: double.infinity,
    //       height: 200,
    //       child: GoogleMap(
    //         mapToolbarEnabled: false,
    //         mapType: MapType.normal,
    //         myLocationButtonEnabled: false,
    //         initialCameraPosition: cameraPosition,
    //         onMapCreated: (controller) {},
    //         circles: {
    //           Circle(
    //             circleId: CircleId(widget.request.id),
    //             center: latLng,
    //             radius: 150,
    //             fillColor: Colors.blue.withOpacity(0.2),
    //             strokeColor: Colors.blue,
    //             strokeWidth: 2,
    //             visible: true,
    //           )
    //         },
    //         markers: {
    //           Marker(
    //             markerId: MarkerId(widget.request.id),
    //             position: latLng,
    //             icon: widget.request.serviceRequestType != null
    //                 ? widget.request.serviceRequestType == 'accepted'
    //                     ? BitmapDescriptor.defaultMarkerWithHue(
    //                         BitmapDescriptor.hueBlue,
    //                       )
    //                     : widget.request.serviceRequestType == 'open'
    //                         ? BitmapDescriptor.defaultMarker
    //                         : BitmapDescriptor.defaultMarkerWithHue(
    //                             BitmapDescriptor.hueGreen,
    //                           )
    //                 : BitmapDescriptor.defaultMarkerWithHue(
    //                     BitmapDescriptor.hueYellow),
    //           )
    //         },
    //       ),
    //     ),
    //   ),
    //   // actions: [
    //   //   Container(
    //   //     color: const Color.fromARGB(255, 192, 192, 192),
    //   //     width: double.infinity,
    //   //     height: 80,
    //   //     // height: 100,
    //   //     child: SingleChildScrollView(
    //   //       padding: const EdgeInsets.all(0),
    //   //       child: ListTile(
    //   //         title: const Text(
    //   //           'Special Notes',
    //   //           textAlign: TextAlign.center,
    //   //           style: TextStyle(
    //   //             fontWeight: FontWeight.bold,
    //   //           ),
    //   //         ),
    //   //         subtitle: _isLoading
    //   //             ? const SizedBox(
    //   //                 // height: 5,
    //   //                 width: 3,
    //   //                 child: Center(
    //   //                   child: CircularProgressIndicator(
    //   //                     color: Colors.blueAccent,
    //   //                   ),
    //   //                 ),
    //   //               )
    //   //             : Text(
    //   //                 // 'forceNextWindowRelayout=false displayId=0 dragResizing=false compatScale=1.0 frameChanged=false attachedFrameChanged=false configChanged=false displayChanged=false compatScaleChanged=false',
    //   //                 specialNotes!,
    //   //                 textAlign: TextAlign.center,
    //   //               ),
    //   //       ),
    //   //     ),
    //   //   ),
    //   //   const SizedBox(
    //   //     height: 16.0,
    //   //   ),
    //   //   Container(
    //   //       color: Colors.grey,
    //   //       width: double.infinity,
    //   //       child: Padding(
    //   //         padding: const EdgeInsets.all(8.0),
    //   //         child: Column(
    //   //           children: [
    //   //             Padding(
    //   //               padding: const EdgeInsets.only(left: 10.0, right: 10.0),
    //   //               child: Row(
    //   //                 children: [
    //   //                   Text(
    //   //                     widget.request.requestType ?? '',
    //   //                     textAlign: TextAlign.left,
    //   //                     textWidthBasis: TextWidthBasis.parent,
    //   //                     style: const TextStyle(
    //   //                         fontSize: 11, color: Colors.white),
    //   //                   ),
    //   //                   const Spacer(),
    //   //                   Text(
    //   //                     widget.request.createdOn?.toString() ?? '',
    //   //                     textAlign: TextAlign.right,
    //   //                     textWidthBasis: TextWidthBasis.parent,
    //   //                     style: const TextStyle(
    //   //                         fontSize: 11, color: Colors.white),
    //   //                   ),
    //   //                 ],
    //   //               ),
    //   //             ),
    //   //             _buildField(
    //   //                 'Name',
    //   //                 widget.request.patientFirstName == ''
    //   //                     ? 'N/A'
    //   //                     : widget.request.patientFirstName,
    //   //                 Colors.white),
    //   //             _buildField(
    //   //                 'Gender',
    //   //                 widget.request.patientSex != null
    //   //                     ? (widget.request.patientSex) == 2
    //   //                         ? 'Other'
    //   //                         : (widget.request.patientSex) == 1
    //   //                             ? 'Male'
    //   //                             : 'Female'
    //   //                     : 'N/A',
    //   //                 Colors.white),
    //   //             _buildField(
    //   //                 'Priority', widget.request.priority, Colors.white),
    //   //             _buildField(
    //   //                 'Age',
    //   //                 (widget.request.patientAge ?? 'N/A').toString(),
    //   //                 Colors.white),
    //   //           ],
    //   //         ),
    //   //       )),
    //   //   ButtonBar(
    //   //     layoutBehavior: ButtonBarLayoutBehavior.padded,
    //   //     buttonAlignedDropdown: false,
    //   //     alignment: MainAxisAlignment.center,
    //   //     children: [
    //   //       //Accept & Evaluate Button
    //   //       if (ApiCalls.clickUser?.userType?.canPass != null &&
    //   //           ApiCalls.clickUser!.userType!.canPass == true &&
    //   //           widget.request.canBePassed == true &&
    //   //           (widget.request.serviceRequestType != 'evaluated' &&
    //   //               widget.request.serviceRequestType != 'accepted'))
    //   //         ElevatedButton(
    //   //           style: ElevatedButton.styleFrom(
    //   //             backgroundColor: Colors.greenAccent,
    //   //             foregroundColor: Colors.black,
    //   //           ),
    //   //           onPressed: () {
    //   //             ApiCalls.acceptAndPassRequest(widget.request.id, context,
    //   //                 (val) {
    //   //               setState(() {
    //   //                 _isAcceptingAndPassing = val;
    //   //               });
    //   //             }).then(
    //   //               (value) => Navigator.push(context,
    //   //                   MaterialPageRoute(builder: (context) {
    //   //                 return MapScreen();
    //   //               })),
    //   //             );
    //   //           },
    //   //           child: _isAcceptingAndPassing
    //   //               ? const SizedBox(
    //   //                   height: 15,
    //   //                   width: 15,
    //   //                   child: CircularProgressIndicator(
    //   //                     color: Colors.white,
    //   //                   ),
    //   //                 ) // Show loader
    //   //               : const Text('Accept & Pass'),
    //   //         ),

    //   //       // Details Button
    //   //       if (widget.request.serviceRequestType == 'accepted' ||
    //   //           widget.request.serviceRequestType == 'evaluated')
    //   //         ElevatedButton(
    //   //           style: ElevatedButton.styleFrom(
    //   //               backgroundColor: Colors.blueAccent,
    //   //               foregroundColor: Colors.black),
    //   //           onPressed: () {
    //   //             Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   //               return AcceptedRequestsScreen(
    //   //                 requestId: widget.request.id,
    //   //               );
    //   //             }));
    //   //           },
    //   //           child: const Text('Details'),
    //   //         ),
    //   //       const SizedBox(
    //   //         height: 16.0,
    //   //       ),

    //   //       // Accept & Decline Buttons
    //   //       Visibility(
    //   //         visible: widget.request.serviceRequestType != 'accepted' &&
    //   //             widget.request.serviceRequestType != 'evaluated',
    //   //         child: Row(
    //   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   //           children: [
    //   //             ElevatedButton(
    //   //                 style: ElevatedButton.styleFrom(
    //   //                     backgroundColor: Colors.blue,
    //   //                     foregroundColor: Colors.white),
    //   //                 onPressed: () {
    //   //                   // Action when "Accept" button is pressed
    //   //                   ApiCalls.acceptRequest(widget.request.id, context,
    //   //                       (val) {
    //   //                     setState(() {
    //   //                       _isAccepting = val;
    //   //                     });
    //   //                   });
    //   //                   // .then(
    //   //                   //   (value) =>
    //   //                   //       Navigator.of(context).pushNamedAndRemoveUntil(
    //   //                   //     MapScreen.routeName,
    //   //                   //     ModalRoute.withName(MapScreen.routeName),
    //   //                   //   ),
    //   //                   // );
    //   //                 },
    //   //                 child: _isAccepting
    //   //                     ? const SizedBox(
    //   //                         height: 15,
    //   //                         width: 15,
    //   //                         child: CircularProgressIndicator(
    //   //                           color: Colors.white,
    //   //                         ),
    //   //                       ) // Show loader
    //   //                     : const Text('Accept')),
    //   //             const SizedBox(
    //   //               width: 8.0,
    //   //             ),
    //   //             ElevatedButton(
    //   //                 style: ElevatedButton.styleFrom(
    //   //                     backgroundColor: Colors.red,
    //   //                     foregroundColor: Colors.white),
    //   //                 onPressed: () {
    //   //                   // Action when "Decline" button is pressed
    //   //                   ApiCalls.declineRequest(widget.request.id, context,
    //   //                       (val) {
    //   //                     setState(() {
    //   //                       _isDeclining = val;
    //   //                     });
    //   //                   }).then(
    //   //                     (value) => Navigator.push(
    //   //                       context,
    //   //                       MaterialPageRoute(builder: (context) {
    //   //                         return MapScreen();
    //   //                       }),
    //   //                     ),
    //   //                   );
    //   //                 },
    //   //                 child: _isDeclining
    //   //                     ? const SizedBox(
    //   //                         height: 15,
    //   //                         width: 15,
    //   //                         child: CircularProgressIndicator(
    //   //                           color: Colors.white,
    //   //                         ),
    //   //                       ) // Show loader
    //   //                     : const Text('Decline')),
    //   //           ],
    //   //         ),
    //   //       ),
    //   //     ],
    //   //   ),
    //   // ],

    // );
  }

  Widget _buildField(String label, String? data, Color color) {
    return Column(
      children: [
        // const SizedBox(
        //   height: 8.0,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: Text(
                '$label:',
                style: TextStyle(fontSize: 16, color: color),
                textAlign: TextAlign.left,
              ),
            ),
            // const SizedBox(width: 10),
            Text(
              data ?? 'N/A',
              style: TextStyle(fontSize: 14, color: color),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ],
    );
  }
}

void showServiceRequestPopup(BuildContext context, ServiceRequest request,
    [mapScreen]) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ServiceRequestPopup(request: request);
    },
  );
}
