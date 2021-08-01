import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

class DeviceInfoRepo {
  Future<String> deviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      // build.model;
      // build.version.toString();
      //UUID for Android
      return build.androidId;
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
//             data.name;
//  data.systemVersion;
      return data.identifierForVendor;
    } else {
      return '';
    }
  }
}
