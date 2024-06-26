/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>JUNE 14, 2023</date>
/////////////////////////////////////////////////////////

import 'package:crossplat_objectid/crossplat_objectid.dart';

import '../api_calls.dart';

class DeviceToken
{
  DeviceToken();
  
  String? id = ObjectId().toHexString();
  String? creationDate = DateTime.now().toString();
  String? deviceTokenString;
  int mobilePlatform = 0;
  String? deviceUniqueIdentifier;
  String? deviceModel;
  String? installedAppVersion;
  String? operatingSystemVersion;
  bool notificationsEnabled = false;
  String therapistId = '';

  DeviceToken.fromJson(Map<String, dynamic> json)
      : id = json['Id'] ?? ObjectId().toHexString(),
        creationDate = json['CreationDate'],
        deviceTokenString = json['DeviceTokenString'],
        mobilePlatform = json['MobilePlatform'],
        deviceUniqueIdentifier = json['DeviceUniqueIdentifier'],
        deviceModel = json['DeviceModel'],
        installedAppVersion = json['InstalledAppVersion'],
        operatingSystemVersion = json['OperatingSystemVersion'],
        notificationsEnabled = json['NotificationsEnabled'],
        therapistId = json['TherapistId'] ?? ApiCalls.userId ?? '';

  Map<String, dynamic> toJson() => {
        'Id': id,
        'CreationDate': creationDate,
        'DeviceTokenString': deviceTokenString,
        'MobilePlatform': mobilePlatform,
        'DeviceUniqueIdentifier': deviceUniqueIdentifier,
        'DeviceModel': deviceModel,
        'InstalledAppVersion': installedAppVersion,
        'OperatingSystemVersion': operatingSystemVersion,
        'NotificationsEnabled': notificationsEnabled,
        'TherapistId': therapistId,
      };
}
