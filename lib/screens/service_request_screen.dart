/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>MAY 29, 2023</date>
/////////////////////////////////////////////////////////

import 'package:clickclinician/screens/accepted_requests_screen.dart';
import 'package:clickclinician/screens/service_req_tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/api_calls.dart';
import '../widgets/nav_drawer.dart';
import '../widgets/popup_menus.dart';
import '../widgets/shared.dart';

class ServiceRequestsScreen extends StatefulWidget {
  final bool? fromTab;
  final Function(int)? serReqCount;
  const ServiceRequestsScreen({Key? key, this.fromTab, this.serReqCount})
      : super(key: key);

  static const String routeName = '/ServiceRequests';

  @override
  State<StatefulWidget> createState() => ServiceRequestScreenState();
}

class ServiceRequestScreenState extends State<ServiceRequestsScreen> {
  bool _isLoading = false;
  Future? _futureServiceRequests;

  @override
  void initState() {
    super.initState();
    ApiCalls.getAcceptedServiceRequests(context, (loading) {
      setState(() {
        _isLoading = loading;
      });
    }).then(
      (value) => {},
    );
  }

  Future<void> _refreshServiceRequests(context) async {
    setState(() {
      _futureServiceRequests = ApiCalls.getAcceptedServiceRequests('', context);
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('inside service req page');

    return _isLoading
        ? const Scaffold(
                    backgroundColor: Colors.white,
                    body: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: widget.fromTab == null
                ? getAppBar(tabName: 'My Service Requests')
                : null,
            drawer: widget.fromTab == null ? const NavDrawer() : null,
            body: ApiCalls.acceptedServiceRequests!.isEmpty
                ? RefreshIndicator(
                    onRefresh: () => _refreshServiceRequests(context),
                    child: const Center(
                      child: Wrap(
                        children: [
                          Text(
                            'No Data! Please accept the requests!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              // backgroundColor: Colors.white,
                              decoration: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshServiceRequests(context),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.circle_rounded,
                                    size: 12,
                                    color: Colors.greenAccent,
                                  ),
                                  Text(
                                    ' Passed Service Reqests',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 12.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.circle_rounded,
                                    size: 12,
                                    color: Colors.blueAccent,
                                  ),
                                  Text(
                                    ' Accepted Service Reqests',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Expanded(
                          child: ListView.builder(
                            // Need to use FutureBuilder<>
                            padding: const EdgeInsets.all(8),
                            itemCount:
                                ApiCalls.acceptedServiceRequests?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              // widget.serReqCount!(
                              //     ApiCalls.acceptedServiceRequests!.length);
                              Color color =
                                  index % 2 == 0 ? Colors.black : Colors.white;
                              double headerFontSize = 18.0;
                              double textFontSize = 16.0;
                              return Card(
                                color: index % 2 == 0
                                    ? Colors.white
                                    : Colors.lightBlueAccent,
                                child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    print(
                                        'Card tapped. ${ApiCalls.acceptedServiceRequests?[index].patientAge}');
                                    var request = ApiCalls
                                        .acceptedServiceRequests?[index];
                                    if (request != null) {
                                      // showServiceRequestPopup(context, request);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AcceptedRequestsScreen(
                                            requestId: request
                                                .id, // Assuming AcceptedRequestsScreen accepts a requestId parameter
                                          ),
                                        ),
                                      );
                                      //65c1d5562747c56fd806ed21, 65c1d5852747c56fd806ed63, 65c1d5ba2747c56fd806eda5
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.circle_rounded,
                                                color: ApiCalls
                                                            .acceptedServiceRequests?[
                                                                index]
                                                            .wasPassed ==
                                                        true
                                                    ? Colors.greenAccent
                                                    : Colors.blueAccent,
                                                size: 10,
                                              ),
                                              const Spacer(),
                                              Text(
                                                ApiCalls
                                                        .acceptedServiceRequests?[
                                                            index]
                                                        .createdOn
                                                        ?.toString() ??
                                                    '',
                                                textAlign: TextAlign.right,
                                                textWidthBasis:
                                                    TextWidthBasis.parent,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: index % 2 == 0
                                                      ? Colors.black
                                                      : Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        // Padding(
                                        //     padding: const EdgeInsets.only(
                                        //         left: 16.0, right: 16.0),
                                        //     child:
                                        //         // Column(
                                        //         //   crossAxisAlignment:
                                        //         //       CrossAxisAlignment.stretch,
                                        //         //   children: [
                                        //         //     Row(
                                        //         //       mainAxisAlignment:
                                        //         //           MainAxisAlignment.spaceBetween,
                                        //         //       crossAxisAlignment:
                                        //         //           CrossAxisAlignment.center,
                                        //         //       children: [
                                        //         //         Flexible(
                                        //         //           child: _buildField(
                                        //         //             'Name',
                                        //         //             ApiCalls
                                        //         //                         .acceptedServiceRequests?[
                                        //         //                             index]
                                        //         //                         .patientFirstName ==
                                        //         //                     ''
                                        //         //                 ? 'N/A'
                                        //         //                 : ApiCalls
                                        //         //                     .acceptedServiceRequests?[
                                        //         //                         index]
                                        //         //                     .patientFirstName,
                                        //         //             index % 2 == 0
                                        //         //                 ? Colors.black
                                        //         //                 : Colors.white,
                                        //         //           ),
                                        //         //         ),
                                        //         //         const SizedBox(width: 8.0),
                                        //         //         Flexible(
                                        //         //           child: _buildField(
                                        //         //             'Priority',
                                        //         //             ApiCalls
                                        //         //                     .acceptedServiceRequests?[
                                        //         //                         index]
                                        //         //                     .priority ??
                                        //         //                 '',
                                        //         //             index % 2 == 0
                                        //         //                 ? Colors.black
                                        //         //                 : Colors.white,
                                        //         //           ),
                                        //         //         ),
                                        //         //       ],
                                        //         //     ),
                                        //         //     const SizedBox(height: 8.0),
                                        //         //     Row(
                                        //         //       mainAxisAlignment:
                                        //         //           MainAxisAlignment.spaceBetween,
                                        //         //       crossAxisAlignment:
                                        //         //           CrossAxisAlignment.center,
                                        //         //       children: [
                                        //         //         Flexible(
                                        //         //           child: _buildField(
                                        //         //             'Gender',
                                        //         //             ApiCalls
                                        //         //                         .acceptedServiceRequests?[
                                        //         //                             index]
                                        //         //                         .patientSex !=
                                        //         //                     null
                                        //         //                 ? (ApiCalls
                                        //         //                             .acceptedServiceRequests?[
                                        //         //                                 index]
                                        //         //                             .patientSex) ==
                                        //         //                         2
                                        //         //                     ? 'O'
                                        //         //                     : (ApiCalls
                                        //         //                                 .acceptedServiceRequests?[
                                        //         //                                     index]
                                        //         //                                 .patientSex) ==
                                        //         //                             1
                                        //         //                         ? 'M'
                                        //         //                         : 'F'
                                        //         //                 : 'N/A',
                                        //         //             index % 2 == 0
                                        //         //                 ? Colors.black
                                        //         //                 : Colors.white,
                                        //         //           ),
                                        //         //         ),
                                        //         //         const SizedBox(width: 8.0),
                                        //         //         Flexible(
                                        //         //           child: _buildField(
                                        //         //             'Age',
                                        //         //             (ApiCalls
                                        //         //                         .acceptedServiceRequests?[
                                        //         //                             index]
                                        //         //                         .patientAge ??
                                        //         //                     'N/A')
                                        //         //                 .toString(),
                                        //         //             index % 2 == 0
                                        //         //                 ? Colors.black
                                        //         //                 : Colors.white,
                                        //         //           ),
                                        //         //         ),
                                        //         //       ],
                                        //         //     ),
                                        //         //   ],
                                        //         // ),
                                        //         Row(
                                        //       // mainAxisAlignment:
                                        //       //     MainAxisAlignment.spaceBetween,
                                        //       crossAxisAlignment:
                                        //           CrossAxisAlignment.center,
                                        //       children: [
                                        //         Column(
                                        //           crossAxisAlignment:
                                        //               CrossAxisAlignment.start,
                                        //           children: [
                                        //             Text(
                                        //               'Name: ',
                                        //               style: TextStyle(
                                        //                   fontSize: headerFontSize,
                                        //                   color: color),
                                        //             ),
                                        //             Text(
                                        //               'Priority: ',
                                        //               style: TextStyle(
                                        //                   fontSize: headerFontSize,
                                        //                   color: color),
                                        //             ),
                                        //             Text(
                                        //               'Gender: ',
                                        //               style: TextStyle(
                                        //                   fontSize: headerFontSize,
                                        //                   color: color),
                                        //             ),
                                        //             Text(
                                        //               'Age: ',
                                        //               style: TextStyle(
                                        //                   fontSize: headerFontSize,
                                        //                   color: color),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //         const SizedBox(
                                        //           width: 16.0,
                                        //         ),
                                        //         Column(
                                        //           crossAxisAlignment:
                                        //               CrossAxisAlignment.start,
                                        //           children: [
                                        //             Text(
                                        //               ApiCalls
                                        //                           .acceptedServiceRequests?[
                                        //                               index]
                                        //                           .patientFirstName ==
                                        //                       ''
                                        //                   ? 'N/A'
                                        //                   : ApiCalls
                                        //                       .acceptedServiceRequests![
                                        //                           index]
                                        //                       .patientFirstName!,
                                        //               style: TextStyle(
                                        //                   fontSize: textFontSize,
                                        //                   color: color),
                                        //             ),
                                        //             Text(
                                        //               ApiCalls
                                        //                       .acceptedServiceRequests?[
                                        //                           index]
                                        //                       .priority ??
                                        //                   '',
                                        //               style: TextStyle(
                                        //                   fontSize: textFontSize,
                                        //                   color: color),
                                        //             ),
                                        //             Text(
                                        //               ApiCalls
                                        //                           .acceptedServiceRequests?[
                                        //                               index]
                                        //                           .patientSex !=
                                        //                       null
                                        //                   ? (ApiCalls
                                        //                               .acceptedServiceRequests?[
                                        //                                   index]
                                        //                               .patientSex) ==
                                        //                           2
                                        //                       ? 'O'
                                        //                       : (ApiCalls
                                        //                                   .acceptedServiceRequests?[
                                        //                                       index]
                                        //                                   .patientSex) ==
                                        //                               1
                                        //                           ? 'M'
                                        //                           : 'F'
                                        //                   : 'N/A',
                                        //               style: TextStyle(
                                        //                   fontSize: textFontSize,
                                        //                   color: color),
                                        //             ),
                                        //             Text(
                                        //               (ApiCalls
                                        //                           .acceptedServiceRequests?[
                                        //                               index]
                                        //                           .patientAge ??
                                        //                       'N/A')
                                        //                   .toString(),
                                        //               style: TextStyle(
                                        //                   fontSize: textFontSize,
                                        //                   color: color),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       ],
                                        //     )),
                                        _buildText(
                                            'Name',
                                            ApiCalls
                                                        .acceptedServiceRequests?[
                                                            index]
                                                        .patientFirstName ==
                                                    ''
                                                ? 'N/A'
                                                : ApiCalls
                                                    .acceptedServiceRequests![
                                                        index]
                                                    .patientFirstName!,
                                            index,
                                            context),
                                        const Divider(),
                                        _buildText(
                                            'Priority',
                                            ApiCalls
                                                    .acceptedServiceRequests?[
                                                        index]
                                                    .priority ??
                                                '',
                                            index,
                                            context),
                                        const Divider(),
                                        _buildText(
                                            'Gender',
                                            ApiCalls
                                                        .acceptedServiceRequests?[
                                                            index]
                                                        .patientSex !=
                                                    null
                                                ? (ApiCalls
                                                            .acceptedServiceRequests?[
                                                                index]
                                                            .patientSex) ==
                                                        2
                                                    ? 'O'
                                                    : (ApiCalls
                                                                .acceptedServiceRequests?[
                                                                    index]
                                                                .patientSex) ==
                                                            1
                                                        ? 'M'
                                                        : 'F'
                                                : 'N/A',
                                            index,
                                            context),
                                        const Divider(),
                                        _buildText(
                                            'Age',
                                            (ApiCalls
                                                        .acceptedServiceRequests?[
                                                            index]
                                                        .patientAge ??
                                                    'N/A')
                                                .toString(),
                                            index,
                                            context),
                                        const SizedBox(height: 8.0),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          );
  }

  Widget _buildField(String label, String? data, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 60, // Adjust the width as needed
            child: Text(
              '$label: ',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              data ?? 'N/A',
              style: TextStyle(color: color, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText(String header, String message, int index, context) {
    var w = MediaQuery.of(context).size.width;
    Color color = index % 2 == 0 ? Colors.black : Colors.white;
    double headerFontSize = 18.0;
    double textFontSize = 16.0;
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '$header: ',
                style: TextStyle(fontSize: headerFontSize, color: color),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: w / 1.6,
                // padding: const EdgeInsets.only(left: 8.0),
                child: Wrap(
                  children: [
                    Text(
                      // 'ApiCalls.acceptedServiceRequests?[index].patientFirstName'
                      message ?? 'N/A',
                      style: TextStyle(
                        fontSize: textFontSize,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
