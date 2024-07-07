/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>MAY 28, 2023</date>
/////////////////////////////////////////////////////////

import 'package:clickclinician/data/shared_preferences.dart';
import 'package:flutter/material.dart';

import "../utility/utils.dart";
import '../screens/legal_screen.dart';
import '../screens/map_screen.dart';
import "../utility/widget_file.dart";

import '../screens/profile_screen.dart';
import '../screens/service_request_screen.dart';
import '../screens/settings_screen.dart';
import '../shared/api_calls.dart';
//import 'package:click_mobile/screens/chat_screen.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});
  static final SPSettings _settings = SPSettings();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: displayWidth(context) * 0.80,
      child: Container(
        width: double.infinity,
        height: displayHeight(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DesignWidgets.getProfileIcon(
                  context, _settings.getUserName() ?? "Clinician", () {}),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    DesignWidgets.divider(),
                    
                    DesignWidgets.profileItem(
                      "My Service Requests",
                      "assets/images/services.svg",
                      null,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ServiceRequestsScreen()));
                      },
                    ),
                    DesignWidgets.divider(),
                    DesignWidgets.profileItem(
                      "Profile",
                      "",
                      Icons.account_circle_outlined,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen()));
                      },
                    ),
                    DesignWidgets.divider(),
                    DesignWidgets.profileItem(
                      "Settings",
                      "assets/images/setting_icon.svg",
                      null,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsScreen()));
                      },
                    ),
                    DesignWidgets.divider(),
                    DesignWidgets.profileItem(
                      "Legal",
                      "",
                      Icons.privacy_tip_outlined,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LegalScreen()));
                      },
                    ),
                    DesignWidgets.divider(),
                  ],
                ),
              ),
              DesignWidgets.signOutItem(
                () {
                  ApiCalls.logout(context, 'Inside NAvbar');
                },
              ),
            ],
          ),
        ),
      ),

      //   ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       const DrawerHeader(
      //         decoration: BoxDecoration(
      //             color: Colors.white,
      //             shape: BoxShape.rectangle,
      //             image: DecorationImage(
      //                 fit: BoxFit.none,
      //                 image: AssetImage('assets/images/click_logo.png'))),
      //         child: Text(
      //           '',
      //           style: TextStyle(color: Colors.blue, fontSize: 25),
      //         ),
      //       ),
      //       ListTile(
      //         //leading: Icon(Icons.input),
      //         textColor: Colors.white,
      //         title: const Text('Map Screen'),
      //         onTap: () => {
      //           Navigator.of(context)
      //               .popUntil(ModalRoute.withName(MapScreen.routeName)),
      //           Navigator.pushNamed(context, MapScreen.routeName)
      //         },
      //       ),
      //       ListTile(
      //         //leading: Icon(Icons.verified_user),
      //         textColor: Colors.white,
      //         title: const Text('My Service Requests'),
      //         onTap: () => {
      //           Navigator.of(context).pushNamed(ServiceRequestsScreen.routeName)
      //         },
      //       ),
      //       // ListTile(
      //       //   //leading: Icon(Icons.border_color),
      //       //   textColor: Colors.white,
      //       //   title: const Text('Chat'),
      //       //   onTap: () => {
      //       //     Navigator.of(context).pushNamedAndRemoveUntil(ChatScreen.routeName, ModalRoute.withName(MapScreen.routeName))
      //       //   },
      //       // ),
      //       ListTile(
      //         //leading: Icon(Icons.verified_user),
      //         textColor: Colors.white,
      //         title: const Text('Profile'),
      //         onTap: () => {
      //           Navigator.of(context).pushNamed(ProfileScreen.routeName),
      //         },
      //       ),
      //       ListTile(
      //         //leading: Icon(Icons.settings),
      //         textColor: Colors.white,
      //         title: const Text('Settings'),
      //         onTap: () =>
      //             {Navigator.of(context).pushNamed(SettingsScreen.routeName)},
      //       ),
      //       ListTile(
      //         //leading: Icon(Icons.border_color),
      //         textColor: Colors.white,
      //         title: const Text('Legal'),
      //         onTap: () =>
      //             {Navigator.of(context).pushNamed(LegalScreen.routeName)},
      //       ),
      //       ListTile(
      //         //leading: Icon(Icons.exit_to_app),
      //         textColor: Colors.white,
      //         title: const Text('Logout'),
      //         onTap: () => {
      //           ApiCalls.logout(context, 'Inside NAvbar'),
      //           // Navigator.of(context).pushNamedAndRemoveUntil(
      //           //     StartupScreen.routeName,
      //           //     ModalRoute.withName(StartupScreen.routeName))
      //         },
      //       ),
      //     ],
      //   ),
      // );
    );
  }
}
