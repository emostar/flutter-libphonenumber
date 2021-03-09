import 'dart:async';

import 'package:flutter/services.dart';

class RegionInfo {
  String? regionPrefix;
  String? isoCode;
  String? formattedPhoneNumber;

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

  static Future<bool?> isValidPhoneNumber({
    required String phoneNumber,
    required String isoCode,
  }) async {
    try {
      return await _channel.invokeMethod('isValidPhoneNumber', {
        'phone_number': phoneNumber,
        'iso_code': isoCode,
      });
    } catch (e) {
      // Sometimes invalid phone numbers can cause exceptions, e.g. "+1"
      return false;
    }
  }

  static Future<String?> getNameForNumber({
    required String phoneNumber,
    required String isoCode,
  }) async {
    return await _channel.invokeMethod('getNameForNumber', {
      'phone_number': phoneNumber,
      'iso_code': isoCode,
    });
  }

  static Future<String?> normalizePhoneNumber({
      required String phoneNumber,
      required String isoCode,
    }) async {
      return await _channel.invokeMethod('normalizePhoneNumber', {
        'phone_number': phoneNumber,
        'iso_code': isoCode,
      });
    }

  static Future<RegionInfo> getRegionInfo({
    required String phoneNumber,
    required String isoCode,
  }) async {
    Map<dynamic, dynamic> result = await (_channel.invokeMethod('getRegionInfo', {
      'phone_number': phoneNumber,
      'iso_code': isoCode,
    }) as FutureOr<Map<dynamic, dynamic>>);

    return RegionInfo(
      regionPrefix: result['regionCode'],
      isoCode: result['isoCode'],
      formattedPhoneNumber: result['formattedPhoneNumber'],
    );
  }

  static Future<PhoneNumberType> getNumberType({
    required String phoneNumber,
    required String isoCode,
  }) async {
    int? result = await _channel.invokeMethod('getNumberType', {
      'phone_number': phoneNumber,
      'iso_code': isoCode,
    });
    if (result == -1) {
      return PhoneNumberType.unknown;
    }
    return PhoneNumberType.values[result!];    
  }
  
  static Future<String?> formatAsYouType({
    required String phoneNumber,
    required String isoCode,
  }) async {
    return await _channel.invokeMethod('formatAsYouType', {
      'phone_number': phoneNumber,
      'iso_code': isoCode,
    });
  }
}
