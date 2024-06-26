import 'package:clickclinician/shared/api_calls.dart';
import 'package:clickclinician/shared/models/service_request.dart';
import 'package:clickclinician/widgets/popup_menus.dart';
import 'package:flutter/material.dart';

class OpenServiceRequestsScreen extends StatefulWidget {
  final Function(int)? serviceReCount;
  const OpenServiceRequestsScreen({Key? key, this.serviceReCount})
      : super(key: key);

  @override
  State<OpenServiceRequestsScreen> createState() =>
      _OpenServiceRequestsScreenState();
}

class _OpenServiceRequestsScreenState extends State<OpenServiceRequestsScreen> {
  Future<List<ServiceRequest>>? _futureServiceRequests;

  @override
  void initState() {
    super.initState();
    _futureServiceRequests = ApiCalls.getAllServiceRequests('', context);
  }

  Future<void> _refreshServiceRequests(context) async {
    setState(() {
      _futureServiceRequests = ApiCalls.getAllServiceRequests('', context);
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _refreshServiceRequests(context),
        child: FutureBuilder<List<ServiceRequest>>(
          future: ApiCalls.getAllServiceRequests('', context, isFilter: true),
          builder: (context, snapshot) {
            // widget.serviceReCount(snapshot.data!.length);
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the data is loading
              return const Scaffold(
                    backgroundColor: Colors.white,
                    body: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
            } else if (snapshot.hasError) {
              // If an error occurs
              return Center(
                child: Wrap(
                  children: [
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            } else if (snapshot.data == null) {
              // Handle the case where snapshot.data is null
              return const Center(
                child: Wrap(
                  children: [
                    Text(
                      'No data available',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            } else {
              // Once data is loaded successfully
              List<ServiceRequest>? serviceRequests = snapshot.data;
              if (serviceRequests != null && serviceRequests.isNotEmpty) {
                // Display the list of service requests
                // widget.serviceReCount!(serviceRequests.length);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: serviceRequests.length,
                    itemBuilder: (context, index) {
                      ServiceRequest serviceRequest = serviceRequests[index];
                      Color color =
                          index % 2 == 0 ? Colors.black : Colors.white;
                      double headerFontSize = 18.0;
                      double textFontSize = 16.0;
                      var w = MediaQuery.of(context).size.width;
                      return Card(
                        color: index % 2 == 0
                            ? Colors.white
                            : Colors.lightBlueAccent,
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            debugPrint('clicked on card');
                            showServiceRequestPopup(context, serviceRequest);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${serviceRequest.createdOn}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: index % 2 == 0
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                // _buildText(
                                //     'Name',
                                //     serviceRequest.patientFirstName
                                //         // 'ApiCalls.acceptedServiceRequests?[index].patientFirstName'
                                //         ??
                                //         'N/A',
                                //     index),
                                // const SizedBox(height: 8.0),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Expanded(
                                //       child: _buildText(
                                //           'Priority',
                                //           serviceRequest.priority ?? 'N/A',
                                //           index),
                                //     ),
                                //     Expanded(
                                //       child: _buildText(
                                //           'Age',
                                //           '${serviceRequest.patientAge ?? 'N/A'}',
                                //           index),
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     Column(
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.start,
                                //       children: [
                                //         Text(
                                //           'Name: ',
                                //           style: TextStyle(
                                //               fontSize: headerFontSize,
                                //               color: color),
                                //         ),
                                //         Text(
                                //           'Priority: ',
                                //           style: TextStyle(
                                //               fontSize: headerFontSize,
                                //               color: color),
                                //         ),
                                //         Text(
                                //           'Age: ',
                                //           style: TextStyle(
                                //               fontSize: headerFontSize,
                                //               color: color),
                                //         ),
                                //       ],
                                //     ),
                                //     const SizedBox(
                                //       width: 16.0,
                                //     ),
                                //     Column(
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.start,
                                //       children: [
                                //         Container(
                                //           width: w / 1.6,
                                //           // padding: const EdgeInsets.only(left: 8.0),
                                //           child: Wrap(
                                //             children: [
                                //               Text(
                                //                 // serviceRequest.patientFirstName
                                //                 'ApiCalls.acceptedServiceRequests?[index].patientFirstName' ??
                                //                     'N/A',
                                //                 style: TextStyle(
                                //                   fontSize: textFontSize,
                                //                   color: color,
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //         Text(
                                //           serviceRequest.priority ?? 'N/A',
                                //           style: TextStyle(
                                //               fontSize: textFontSize,
                                //               color: color),
                                //         ),
                                //         Text(
                                //           '${serviceRequest.patientAge ?? 'N/A'}',
                                //           style: TextStyle(
                                //               fontSize: textFontSize,
                                //               color: color),
                                //         ),
                                //       ],
                                //     ),
                                //   ],
                                // ),
                                _buildTest(
                                  'Name',
                                  (serviceRequest.patientFirstName == '')
                                      ? 'N/A'
                                      : serviceRequest.patientFirstName ??
                                          'N/A',
                                  index,
                                  context,
                                ),
                                const Divider(),
                                _buildTest(
                                  'Priority',
                                  serviceRequest.priority ?? 'N/A',
                                  index,
                                  context,
                                ),
                                const Divider(),
                                _buildTest(
                                  'Age',
                                  '${serviceRequest.patientAge ?? 'N/A'}',
                                  index,
                                  context,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                // If no service requests are available
                return const Center(
                  child: Wrap(
                    children: [
                      Text(
                        'No Open Service Requests',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildText(String header, String? message, int index) {
    final Color color = index % 2 == 0 ? Colors.black : Colors.white;
    return Row(
      children: [
        Text(
          '$header: ',
          style: TextStyle(
            fontSize: 18,
            color: color,
          ),
        ),
        // const SizedBox(
        //   width: 8.0,
        // ),
        Expanded(
          child: Text(
            message ?? 'N/A',
            softWrap: true,
            style: TextStyle(fontSize: 16, color: color),
          ),
        ),
      ],
    );
  }

  Widget _buildTest(String he, String mess, int index, context) {
    var w = MediaQuery.of(context).size.width;
    Color color = index % 2 == 0 ? Colors.black : Colors.white;
    double headerFontSize = 18.0;
    double textFontSize = 16.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '$he: ',
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
                    mess ?? 'N/A',
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
    );
  }
}
