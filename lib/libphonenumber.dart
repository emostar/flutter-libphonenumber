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

enum PhoneNumberType {
  fixedLine,
  mobile,
  fixedLineOrMobile,
  tollFree,
  premiumRate,
  sharedCost,
  voip,
  personalNumber,
  pager,
  uan,
  voicemail,
  unknown
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

  static Future<PhoneNumberType> getNumberType({
    @required String phoneNumber,
    @required String isoCode,
  }) async {
    int result = await _channel.invokeMethod('getNumberType', {
      'phone_number': phoneNumber,
      'iso_code': isoCode,
    });

    switch (result) {
      case 0:
        return PhoneNumberType.fixedLine;
      case 1:
        return PhoneNumberType.mobile;
      case 2:
        return PhoneNumberType.fixedLineOrMobile;
      case 3:
        return PhoneNumberType.tollFree;
      case 4:
        return PhoneNumberType.premiumRate;
      case 5:
        return PhoneNumberType.sharedCost;
      case 6:
        return PhoneNumberType.voip;
      case 7:
        return PhoneNumberType.personalNumber;
      case 8:
        return PhoneNumberType.pager;
      case 9:
        return PhoneNumberType.uan;
      case 10:
        return PhoneNumberType.voicemail;
      default:
        // unknown is -1 and default
        return PhoneNumberType.unknown;
    }
  }
}
