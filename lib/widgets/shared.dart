/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>MAY 28, 2023</date>
/////////////////////////////////////////////////////////

import 'package:flutter/material.dart';

AppBar getAppBar({bool? isBack, String? tabName}) {
  debugPrint('tabName: $tabName');
  return AppBar(
    title: tabName != null ? Text(tabName) : const Text("Click Clinician"),
    // isBack != null && isBack
    //     ? Builder(builder: (BuildContext context) {
    //         return Row(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             IconButton(
    //               icon: const Icon(Icons.arrow_back),
    //               onPressed: () {
    //                 Navigator.of(context).pop(); // Navigate back
    //               },
    //             ),
    //             const SizedBox(
    //               width: 8.0,
    //             ),
    //             const Text("Click Clinician"),
    //           ],
    //         );
    //       })
    //     : const Text("Click Clinician"),
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    automaticallyImplyLeading: true,
    primary: true,
    leading: isBack != null && isBack
        ? Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.of(context).pop(); // Navigate back
              },
            );
            // Row(
            //   children: [
            //     IconButton(
            //       icon: const Icon(Icons.arrow_back),
            //       onPressed: () {
            //         Navigator.of(context).pop(); // Navigate back
            //       },
            //     ),
            //     IconButton(
            //       icon: const Icon(Icons.menu),
            //       onPressed: () {
            //         debugPrint('click on drawer button');
            //         Scaffold.of(context).openDrawer(); // Open drawer
            //       },
            //       tooltip:
            //           MaterialLocalizations.of(context).openAppDrawerTooltip,
            //     ),
            //   ],
            // );
          })
        : Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
  );
}
