// /////////////////////////////////////////////////////////
// // <copyright company="Click Clinician">
// // Copyright (c) 2023 All Rights Reserved
// // </copyright>
// // <author>Jeremy Snyder</author>
// // <date>JUNE 1, 2023</date>
// /////////////////////////////////////////////////////////

// import 'package:clickclinician/shared/models/accepted_service_req.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import '../shared/api_calls.dart';
// import '../shared/models/service_request.dart';

// void showServiceRequestPopup(BuildContext context, AcceptedServiceRequest request) {
//   var latLng = LatLng(request.approxLatitude, request.approxLongitude);
//   var cameraPosition = CameraPosition(target: latLng, zoom: 14);

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text(request.id, style: const TextStyle(fontSize: 13),),
//         content:
//           Container(
//             color: Colors.amberAccent,
//             height: 400,
//             child:
//               SizedBox(
//                 width: double.infinity,
//                 height: 200,
//                 child:
//                   GoogleMap(
//                     mapToolbarEnabled: false,
//                     mapType: MapType.normal,
//                     myLocationButtonEnabled: false,
//                     initialCameraPosition: cameraPosition,
//                     onMapCreated: (controller) {
//                     },
//                     circles: {
//                       Circle(
//                       circleId:
//                         CircleId(request.id),
//                           center: latLng,
//                           radius: 800, // Radius in meters ( 0.5 miles * 1.6 km per mile * 1000)
//                           fillColor: Colors.blue.withOpacity(0.2),
//                           strokeColor: Colors.blue,
//                           strokeWidth: 2,
//                         )
//                       }
//                   ),
//               )
//           ),
//         actions: [
//           Container(
//             color: Colors.grey,
//             width: double.infinity,
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//                   child:
//                     Row(
//                       children: [
//                         Text(request.requestType ?? '',
//                           textAlign: TextAlign.left,
//                           textWidthBasis: TextWidthBasis.parent,
//                           style: const TextStyle(fontSize: 11, color: Colors.white),
//                         ),
//                         const Spacer(),
//                         Text(request.createdOn?.toString() ?? '',
//                           textAlign: TextAlign.right,
//                           textWidthBasis: TextWidthBasis.parent,
//                           style: const TextStyle(fontSize: 11, color: Colors.white),
//                         ),
//                       ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//                   child:
//                     Text('${request.patientFirstName ?? '??'} ${(request.patientSex ?? 2) == -1 ? 'U' : (request.patientSex ?? -1) == 0 ? 'F' : 'M'}${(request.patientAge ?? 0).toString()}',
//                       textAlign: TextAlign.left,
//                       textWidthBasis: TextWidthBasis.parent,
//                       style: const TextStyle(fontSize: 14, color: Colors.white),
//                     ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//                   child:
//                     Text(
//                       request.priority,
//                       textAlign: TextAlign.left,
//                       textWidthBasis: TextWidthBasis.parent,
//                       style: const TextStyle(fontSize: 11, color: Colors.white),
//                     ),
//                 ),
//               ],
//             )
//           ),
//           ButtonBar(
//             layoutBehavior: ButtonBarLayoutBehavior.padded,
//             buttonAlignedDropdown: false,
//             children: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
//                 onPressed: () {
//                   ApiCalls.acceptRequest(request.id, context)
//                   .then((value) => Navigator.of(context).pop());
//                 },
//                 child: const Text('Accept')
//               ),
//               Visibility(
//                 visible: (ApiCalls.clickUser?.userType?.canPass ?? false) &&  request.canBePassed,
//                 child:
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow, foregroundColor: Colors.black),
//                     onPressed: () {
//                       ApiCalls.acceptAndPassRequest(request.id, context)
//                       .then((value) => Navigator.of(context).pop());
//                     },
//                     child: const Text('Accept&Pass'),
//                   ),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
//                 onPressed: () {
//                   ApiCalls.declineRequest(request.id, context)
//                   .then((value) => Navigator.of(context).pop());
//                 },
//                 child: const Text('Decline')
//               ),
//             ],
//           ),
//         ],
//       );
//     },
//   );
// }
