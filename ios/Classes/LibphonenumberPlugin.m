#import "LibphonenumberPlugin.h"

#import "NBPhoneNumberUtil.h"
#import "NBAsYouTypeFormatter.h"

@interface LibphonenumberPlugin ()
@property(nonatomic, retain) NBPhoneNumberUtil *phoneUtil;
@end

@implementation LibphonenumberPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"codeheadlabs.com/libphonenumber"
                                                                binaryMessenger:[registrar messenger]];
    
    LibphonenumberPlugin* instance = [[LibphonenumberPlugin alloc] init];
    instance.phoneUtil = [[NBPhoneNumberUtil alloc] init];
    
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSError *err = nil;
    
    NSString *phoneNumber = call.arguments[@"phone_number"];
    NSString *isoCode = call.arguments[@"iso_code"];
    NSString *formatEnumString = call.arguments[@"format"];
    NBPhoneNumber *number = nil;

    // Call formatAsYouType before parse below because a partial number will not be parsable.
    if ([@"formatAsYouType" isEqualToString:call.method]) {
        NBAsYouTypeFormatter *f = [[NBAsYouTypeFormatter alloc] initWithRegionCode:isoCode];
        result([f inputString:phoneNumber]);
        return;
    }
    
    if (phoneNumber != nil) {
        number = [self.phoneUtil parse:phoneNumber defaultRegion:isoCode error:&err];
        if (err != nil) {
            result([FlutterError errorWithCode:@"invalid_phone_number" message:@"Invalid Phone Number" details:nil]);
            return;
        }
    }

    if ([@"isValidPhoneNumber" isEqualToString:call.method]) {
        NSNumber *validNumber = [NSNumber numberWithBool:[self.phoneUtil isValidNumber:number]];
        result(validNumber);
    } else if ([@"normalizePhoneNumber" isEqualToString:call.method]) {
        NSString *normalizedNumber = [self.phoneUtil format:number
                                               numberFormat:NBEPhoneNumberFormatE164
                                                      error:&err];
        if (err != nil) {
            result([FlutterError errorWithCode:@"invalid_national_number"
                                       message:@"Invalid phone number for the country specified"
                                       details:nil]);
            return;
        }
          
        result(normalizedNumber);
    } else if ([@"getRegionInfo" isEqualToString:call.method]) {
        NSString *regionCode = [self.phoneUtil getRegionCodeForNumber:number];
        NSNumber *countryCode = [self.phoneUtil getCountryCodeForRegion:regionCode];
        NSString *formattedNumber = [self.phoneUtil format:number
                                              numberFormat:NBEPhoneNumberFormatNATIONAL
                                                     error:&err];
        if (err != nil ) {
            result([FlutterError errorWithCode:@"invalid_national_number"
                                       message:@"Invalid phone number for the country specified"
                                       details:nil]);
            return;
        }
        
        result(@{
                 @"isoCode": regionCode == nil ? @"" : regionCode,
                 @"regionCode": countryCode == nil ? @"" : [countryCode stringValue],
                 @"formattedPhoneNumber": formattedNumber == nil ? @"" : formattedNumber,
                 });
    } else if([@"getExampleNumber" isEqualToString:call.method]) {
         NBPhoneNumber *exampleNumber = [self.phoneUtil getExampleNumber:isoCode error:&err];
         NSString *regionCode = [self.phoneUtil getRegionCodeForNumber:exampleNumber];
         NSString *formattedNumber = [self.phoneUtil format:exampleNumber
                                                       numberFormat:NBEPhoneNumberFormatNATIONAL
                                                              error:&err];
         if (err != nil ) {
             result([FlutterError errorWithCode:@"invalid_national_number"
                                        message:@"Invalid phone number for the country specified"
                                        details:nil]);
             return;
         }

         result(@{
                  @"isoCode": regionCode == nil ? @"" : regionCode,
                  @"formattedPhoneNumber": formattedNumber == nil ? @"" : formattedNumber,
                  });
    } else if ([@"getNumberType" isEqualToString:call.method]) {
        NSNumber *numberType = [NSNumber numberWithInteger:[self.phoneUtil getNumberType:number]];
        result(numberType);
    } else if ([@"getNameForNumber" isEqualToString:call.method]) {
        NSString *name = @"";
        result(name);
    } else if ([@"format" isEqualToString:call.method]) {
        NSString *formattedNumber;
        if ([@"NATIONAL" isEqualToString:formatEnumString]) {
            formattedNumber = [self.phoneUtil format:number numberFormat:NBEPhoneNumberFormatNATIONAL error:&err];
        } else if([@"INTERNATIONAL" isEqualToString:formatEnumString]) {
            formattedNumber = [self.phoneUtil format:number numberFormat:NBEPhoneNumberFormatINTERNATIONAL error:&err];
        } else if([@"E164" isEqualToString:formatEnumString]) {
            formattedNumber = [self.phoneUtil format:number numberFormat:NBEPhoneNumberFormatE164 error:&err];
        } else if([@"RFC3966" isEqualToString:formatEnumString]) {
            formattedNumber = [self.phoneUtil format:number numberFormat:NBEPhoneNumberFormatRFC3966 error:&err];
        }

        if (err != nil ) {
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"Error %ld", err.code]
                                       message:err.domain
                                       details:err.localizedDescription]);
            return;
        }
        result(formattedNumber);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
