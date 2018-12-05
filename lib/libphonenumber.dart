import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class RegionInfo {
  String regionPrefix;
  String isoCode;
  String formattedPhoneNumber;

  RegionInfo({this.regionPrefix, this.isoCode, this.formattedPhoneNumber});

  @override
  String toString() {
    return '[RegionInfo prefix=$regionPrefix, iso=$isoCode, formatted=$formattedPhoneNumber]';
  }
}

class PhoneNumberUtil {
  static const MethodChannel _channel = const MethodChannel('codeheadlabs.com/libphonenumber');

  static Future<bool> isValidPhoneNumber({
    @required String phoneNumber,
    @required String isoCode,
  }) async {
    return await _channel.invokeMethod('isValidPhoneNumber', {
      'phone_number': phoneNumber,
      'iso_code': isoCode,
    });
  }

  static Future<String> normalizePhoneNumber({
    @required String phoneNumber,
    @required String isoCode,
  }) async {
    return await _channel.invokeMethod('normalizePhoneNumber', {
      'phone_number': phoneNumber,
      'iso_code': isoCode,
    });
  }

  static Future<RegionInfo> getRegionInfo({
    @required String phoneNumber,
    @required String isoCode,
  }) async {
    Map<dynamic, dynamic> result = await _channel.invokeMethod('getRegionInfo', {
      'phone_number': phoneNumber,
      'iso_code': isoCode,
    });

    return RegionInfo(
      regionPrefix: result['regionCode'],
      isoCode: result['isoCode'],
      formattedPhoneNumber: result['formattedPhoneNumber'],
    );
  }
}
