// /////////////////////////////////////////////////////////
// // <copyright company="Click Clinician">
// // Copyright (c) 2023 All Rights Reserved
// // </copyright>
// // <author>Jeremy Snyder</author>
// // <date>MAY 29, 2023</date>
// /////////////////////////////////////////////////////////

// import 'package:clickclinician/shared/api_calls.dart';
// import 'package:clickclinician/widgets/nav_drawer.dart';
// import 'package:clickclinician/widgets/popup_menus.dart';
// import 'package:clickclinician/widgets/shared.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // import '../shared/api_calls.dart';
// // import '../widgets/nav_drawer.dart';
// // import '../widgets/popup_menus.dart';
// // import '../widgets/shared.dart';

// class ServiceRequestsScreen extends StatefulWidget {
//   const ServiceRequestsScreen({super.key});

//   static const String routeName = '/ServiceRequests';

//   @override
//   State<StatefulWidget> createState() => ServiceRequestScreenState();
// }

// class ServiceRequestScreenState extends State<ServiceRequestsScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ApiCalls.getAllServiceRequests('', context).then(
//       (value) => {print('service req in sr page: ${value}')},
//     );

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: getAppBar(),
//       drawer: const NavDrawer(),
//       body: ListView.builder(
//         // Need to use FutureBuilder<>
//         padding: const EdgeInsets.all(8),
//         itemCount: ApiCalls.serviceRequests?.length ?? 0,
//         itemBuilder: (BuildContext context, int index) {
//           print('service req length: ${ApiCalls.serviceRequests?.length}');
//           print(
//               'service req length: ${ApiCalls.serviceRequests?[index].patientFirstName}');
//           return Container(
//               width: double.infinity,
//               color: index % 2 == 0 ? Colors.white : Colors.lightBlueAccent,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//                     child: Row(
//                       children: [
//                         Text(
//                           ApiCalls.serviceRequests?[index].requestType ?? '',
//                           textAlign: TextAlign.left,
//                           textWidthBasis: TextWidthBasis.parent,
//                           style: TextStyle(
//                               fontSize: 11,
//                               color:
//                                   index % 2 == 0 ? Colors.black : Colors.white),
//                         ),
//                         const Spacer(),
//                         Text(
//                           ApiCalls.serviceRequests?[index].createdOn
//                                   ?.toString() ??
//                               '',
//                           textAlign: TextAlign.right,
//                           textWidthBasis: TextWidthBasis.parent,
//                           style: TextStyle(
//                               fontSize: 11,
//                               color:
//                                   index % 2 == 0 ? Colors.black : Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//                     child: Text(
//                       '${ApiCalls.serviceRequests?[index].patientFirstName ?? '??'} ${(ApiCalls.serviceRequests?[index].patientSex ?? 2) == -1 ? 'U' : (ApiCalls.serviceRequests?[index].patientSex ?? -1) == 0 ? 'F' : 'M'}${(ApiCalls.serviceRequests?[index].patientAge ?? 0).toString()}',
//                       textAlign: TextAlign.left,
//                       textWidthBasis: TextWidthBasis.parent,
//                       style: TextStyle(
//                           fontSize: 14,
//                           color: index % 2 == 0 ? Colors.black : Colors.white),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//                     child: Text(
//                       ApiCalls.serviceRequests?[index].priority ?? '',
//                       textAlign: TextAlign.left,
//                       textWidthBasis: TextWidthBasis.parent,
//                       style: TextStyle(
//                           fontSize: 11,
//                           color: index % 2 == 0 ? Colors.black : Colors.white),
//                     ),
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.lightBlue,
//                         foregroundColor: Colors.white),
//                     onPressed: () {
//                       var request = ApiCalls.serviceRequests?[index];
//                       if (request != null) {
//                         showServiceRequestPopup(context, request);
//                         setState(() {});
//                       }
//                     },
//                     child: const Text('VIEW DETAILS'),
//                   )
//                 ],
//               ));
//         },
//       ),
//     );
//   }
// }
