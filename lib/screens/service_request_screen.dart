/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>MAY 29, 2023</date>
/////////////////////////////////////////////////////////

import 'package:clickclinician/screens/accepted_requests_screen.dart';
import 'package:clickclinician/screens/service_req_tabs_screen.dart';
import 'package:clickclinician/utility/color_file.dart';
import 'package:clickclinician/utility/style_file.dart';
import 'package:clickclinician/utility/utils.dart';
import 'package:clickclinician/utility/widget_file.dart';
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

  @override
  State<StatefulWidget> createState() => ServiceRequestScreenState();
}

class ServiceRequestScreenState extends State<ServiceRequestsScreen> {
  bool _isLoading = false;
  Future? _futureServiceRequests;
  int tab = 1;

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
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: !ApiCalls.acceptedServiceRequests!.isEmpty
                  ? RefreshIndicator(
                      onRefresh: () => _refreshServiceRequests(context),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DesignWidgets.getAppBar(
                                context, "My Service Requests"),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  'No Data! Please accept the requests!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsUI.headingColor,
                                    // backgroundColor: Colors.white,
                                    decoration: null,
                                  ),
                                ),
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
                          DesignWidgets.getAppBar(
                              context, "My Service Requests"),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            child: Container(
                              height: 48,
                              width: displayWidth(context) - 96,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ColorsUI.primaryColor,
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (tab == 2) {
                                        setState(() {
                                          tab = 1;
                                        });
                                      }
                                    },
                                    child: Container(
                                      width:
                                          (displayWidth(context) - 108) * 0.5,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: tab == 1
                                            ? ColorsUI.primaryColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "Accepted",
                                        style: tab == 1
                                            ? CustomStyles.paragraphWhite
                                            : CustomStyles.paragraphPrimary,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (tab == 1) {
                                        setState(
                                          () {
                                            tab = 2;
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      width:
                                          (displayWidth(context) - 108) * 0.5,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: tab == 2
                                            ? ColorsUI.primaryColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Passed",
                                              style: tab == 2
                                                  ? CustomStyles.paragraphWhite
                                                  : CustomStyles
                                                      .paragraphPrimary),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              itemCount: 2,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: InkWell(
                                    splashColor: Colors.blue.withOpacity(0.3),
                                    onTap: () {
                                      // var request = ApiCalls
                                      //     .acceptedServiceRequests?[index];
                                      // if (request != null) {
                                      // showServiceRequestPopup(context, request);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AcceptedRequestsScreen(
                                                  requestId:
                                                      "0039a9e5-e7cc-4058-8562-f47457d5db28"
                                                  // Assuming AcceptedRequestsScreen accepts a requestId parameter
                                                  ),
                                        ),
                                      );
                                      //65c1d5562747c56fd806ed21, 65c1d5852747c56fd806ed63, 65c1d5ba2747c56fd806eda5
                                      // }
                                    },
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          bottom: -75,
                                          right: -120,
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            decoration: BoxDecoration(
                                              color: Colors.lightBlue
                                                  .withOpacity(0.1),
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
                                                color: Colors.blue
                                                    .withOpacity(0.4)),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Column(
                                            children: [
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //       left: 10.0, right: 10.0),
                                              //   child: Row(
                                              //     children: [
                                              //       Icon(
                                              //         Icons.circle_rounded,
                                              //         color: index == 0
                                              //             ? Colors.greenAccent
                                              //             : Colors.blueAccent,
                                              //         size: 10,
                                              //       ),
                                              //       const Spacer(),
                                              //       const Text(
                                              //         "July 12, 2024" ?? '',
                                              //         textAlign: TextAlign.right,
                                              //         textWidthBasis:
                                              //             TextWidthBasis.parent,
                                              //         style: TextStyle(
                                              //           fontSize: 11,
                                              //           color: Colors.black,
                                              //         ),
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),

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
                                              // _buildText('Name', "Khuzaima Ahmed",
                                              //     index, context),
                                              // _buildText('Priority',
                                              //     "Priority Here", index, context),
                                              // _buildText(
                                              //     'Gender', 'M', index, context),
                                              // _buildText(
                                              //     'Age', "23", index, context),

                                              Row(
                                                children: [
                                                  const Center(
                                                      child: Icon(
                                                    Icons
                                                        .account_circle_rounded,
                                                    color:
                                                        ColorsUI.primaryColor,
                                                    size: 72,
                                                  )),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "Khuzaima Ahmed",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                            color: ColorsUI
                                                                .headingColor,
                                                          ),
                                                        ),
                                                        DesignWidgets
                                                            .addVerticalSpace(
                                                                4.0),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Priority: ",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: ColorsUI
                                                                    .headingColor
                                                                    .withOpacity(
                                                                        0.8),
                                                              ),
                                                            ),
                                                            DesignWidgets
                                                                .addHorizontalSpace(
                                                                    4.0),
                                                            Text(
                                                              "5 - 5 Days",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: ColorsUI
                                                                    .headingColor
                                                                    .withOpacity(
                                                                        0.6),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        DesignWidgets
                                                            .addVerticalSpace(
                                                                8.0),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          12.0,
                                                                      vertical:
                                                                          6.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.25),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              child: const Text(
                                                                  "Male",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black)),
                                                            ),
                                                            DesignWidgets
                                                                .addHorizontalSpace(
                                                                    8.0),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          12.0,
                                                                      vertical:
                                                                          6.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.25),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              child: const Text(
                                                                  "23 Y/O",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black)),
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
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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
    Color color = Colors.black;
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
