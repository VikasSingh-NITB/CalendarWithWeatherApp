//
//  Utility.m
//  MS_iOSChallenge_POC
//
//  Created by Singh, Vikaskumar on 9/10/17.
//  Copyright © 2017 Singh, Vikaskumar. All rights reserved.
//

#import "Utility.h"

@implementation Utility


+ (NSString *) dateFromUnixTimestamp :(NSTimeInterval ) timeInterval{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"dd MMM yyyy, HH:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
    
}

+ (NSDate *) dateFromString:(NSString *)dateString {
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM yyyy, HH:mm"];
    NSDate *date = [dateFormat dateFromString:dateString];
    return date;
}

+ (NSString *) convertFahrenheitToCelsius:(float) fahrenheit{
    int celsius = ((fahrenheit - 32)*5)/9;
    return [NSString stringWithFormat:@"%d%@",celsius,@"\u00B0"];
}

+ (NSString *) convertStringOnlyTimeFormateFromDate:(NSDate *) date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    return [formatter stringFromDate:date];
}

+ (NSString *) convertDateIntoDayFormat:(NSDate *)date {

    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:date];
    switch ( [comp weekday]) {
        case 1:
            return @"Sunday";
            break;
        case 2:
            return @"Monday";
            break;
        case 3:
            return @"Tuesday";
            break;
        case 4:
            return @"Wednesday";
            break;
        case 5:
            return @"Thursday";
            break;
        case 6:
            return @"Friday";
            break;
        case 7:
            return @"Saturday";
            break;
            
        default:
            break;
    };
    return nil;
}


@end
