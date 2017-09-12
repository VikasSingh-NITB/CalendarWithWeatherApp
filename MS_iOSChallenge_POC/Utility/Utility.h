//
//  Utility.h
//  MS_iOSChallenge_POC
//
//  Created by Singh, Vikaskumar on 9/10/17.
//  Copyright © 2017 Singh, Vikaskumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject




+ (NSString *) dateFromUnixTimestamp :(NSTimeInterval ) timeInterval;

+ (NSString *) convertFahrenheitToCelsius:(float) fahrenheit;

+ (NSString *) convertStringOnlyTimeFormateFromDate:(NSDate *)date;

+ (NSString *) convertDateIntoDayFormat:(NSDate *)date;

+ (NSDate *) dateFromString:(NSString *)dateString;

@end
