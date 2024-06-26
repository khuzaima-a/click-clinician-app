/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>JUNE 14, 2023</date>
/////////////////////////////////////////////////////////

import 'dart:async';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'api_calls.dart';
import 'firebase.dart';
import 'models/device.dart';

class ClickDeviceInfo {
  ClickDeviceInfo();

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  static final DeviceToken deviceToken = DeviceToken();
  late Map<String, dynamic> deviceData;

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print('getAppVersion: ${packageInfo}');
    return packageInfo.version;
  }

  String generateDeviceKey() {
    const length = 8; // Length of each segment
    final buffer = StringBuffer();
    final random = Random();

    // Function to generate a random string of given length
    String generateRandomString(int length) {
      const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
      return List.generate(
          length, (index) => chars[random.nextInt(chars.length)]).join();
    }

    // Generating and appending 4 segments
    for (int i = 0; i < 4; i++) {
      buffer.write(generateRandomString(length));
    }

    return buffer.toString();
  }

  Future<void> initPlatformState(context) async {
    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        deviceData = switch (defaultTargetPlatform) {
          TargetPlatform.android =>
            _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
          TargetPlatform.iOS =>
            _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
          TargetPlatform.linux =>
            _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo),
          TargetPlatform.windows =>
            _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo),
          TargetPlatform.macOS =>
            _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo),
          TargetPlatform.fuchsia => <String, dynamic>{
              'Error:': 'Fuchsia platform isn\'t supported'
            },
        };

        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            deviceToken.mobilePlatform = 0;
            break;
          case TargetPlatform.iOS:
            deviceToken.mobilePlatform = 1;
            break;
          default:
            deviceToken.mobilePlatform = 100;
            break;
        }

        if (deviceToken.mobilePlatform < 3) {
          debugPrint('device dt info: $deviceData <====');
          ApiCalls.deviceToken =
              await FirebaseMessenger.registerDeviceForNotifications() ?? '';
          deviceToken.deviceTokenString = ApiCalls.deviceToken;
          deviceToken.deviceUniqueIdentifier =
              deviceData['identifierForVendor'] ?? deviceData['serialNumber'];
          deviceToken.deviceModel = deviceData['model'];
          deviceToken.installedAppVersion = await getAppVersion();
          deviceToken.operatingSystemVersion = deviceData['version.release'];
          deviceToken.notificationsEnabled =
              await FirebaseMessenger.getNotificationSettings();
          deviceToken.therapistId = ApiCalls.userId ?? '';

          if (deviceToken.therapistId != '' &&
              deviceToken.deviceUniqueIdentifier!.isNotEmpty) {
            debugPrint(
                'inside device info->initPlatformState: ${deviceToken.therapistId}');
            ApiCalls.registerDevice(deviceToken, context);
          }
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    final generatedDeviceKey = generateDeviceKey();
    debugPrint('generatedDeviceKey in andorid: $generatedDeviceKey');
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'displaySizeInches':
          ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      'displayWidthPixels': build.displayMetrics.widthPx,
      'displayWidthInches': build.displayMetrics.widthInches,
      'displayHeightPixels': build.displayMetrics.heightPx,
      'displayHeightInches': build.displayMetrics.heightInches,
      'displayXDpi': build.displayMetrics.xDpi,
      'displayYDpi': build.displayMetrics.yDpi,
      'serialNumber': generatedDeviceKey,
      // 'serialNumber': build.serialNumber,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    print(
        '_readIosDeviceInfo:====================================================== $data <====');
    
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      // 'model': data.name,
      'model': data.utsname.machine,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
      'version.release': data.systemVersion,

    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': describeEnum(data.browserName),
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'patchVersion': data.patchVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      'userName': data.userName,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'buildNumber': data.buildNumber,
      'platformId': data.platformId,
      'csdVersion': data.csdVersion,
      'servicePackMajor': data.servicePackMajor,
      'servicePackMinor': data.servicePackMinor,
      'suitMask': data.suitMask,
      'productType': data.productType,
      'reserved': data.reserved,
      'buildLab': data.buildLab,
      'buildLabEx': data.buildLabEx,
      'digitalProductId': data.digitalProductId,
      'displayVersion': data.displayVersion,
      'editionId': data.editionId,
      'installDate': data.installDate,
      'productId': data.productId,
      'productName': data.productName,
      'registeredOwner': data.registeredOwner,
      'releaseId': data.releaseId,
      'deviceId': data.deviceId,
    };
  }
}
