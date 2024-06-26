import 'dart:math';

import 'package:clickclinician/screens/open_service_requests_screen.dart';
import 'package:clickclinician/screens/service_request_screen.dart';
import 'package:clickclinician/widgets/nav_drawer.dart';
import 'package:clickclinician/widgets/shared.dart';
import 'package:flutter/material.dart';

class ServiceRequestTabsScreen extends StatefulWidget {
  final String? serviceReqId; // Make the parameter nullable
  const ServiceRequestTabsScreen({Key? key, this.serviceReqId})
      : super(key: key);
  static const String routeName = "/serviceReqTabs";
  @override
  State<ServiceRequestTabsScreen> createState() =>
      _ServiceRequestTabsScreenState();
}

class _ServiceRequestTabsScreenState extends State<ServiceRequestTabsScreen>
    with SingleTickerProviderStateMixin {
  // Add the SingleTickerProviderStateMixin
  late TabController _tabController;
  int serviceReqCount = 0;
  int assecptedServiceReqCount = 0;

  @override
  void initState() {
    super.initState();
    // Specify the initial index you want
    setState(() {
      serviceReqCount = 0;
      assecptedServiceReqCount = 0;
    });
    int initialTabIndex = 0;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialTabIndex,
      animationDuration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('Building ServiceRequestTabsScreen: $assecptedServiceReqCount');
    return Scaffold(
      appBar: getAppBar(tabName: 'Service Requests'),
      drawer: const NavDrawer(),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            // indicator: ShapeDecoration(
            //   shape: Border.all(
            //     color: const Color.fromARGB(255, 226, 226, 226),
            //     width: 2,
            //     strokeAlign: BorderSide.strokeAlignCenter,
            //   ),
            // ),
            indicator: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.blueAccent, width: 2.0),
              ),
            ),
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey[600],
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              height: 3,
              overflow: TextOverflow.ellipsis,
            ),
            tabs: const [
              Text(
                'Service Requests',
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              Text(
                'My Service Requests',
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(
                  child: OpenServiceRequestsScreen(
                      // serviceReCount: (val) async {
                      //   var length = await val;
                      //   if (length.toString().isNotEmpty &&
                      //       length != serviceReqCount) {
                      //     setState(() {
                      //       serviceReqCount = length;
                      //     });
                      //   }
                      // },
                      ),
                ),
                Center(
                  child: ServiceRequestsScreen(
                    fromTab: true,
                    // serReqCount: (val) async {
                    //   var length = await val;
                    //   setState(() {
                    //     assecptedServiceReqCount = length;
                    //   });
                    // },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
