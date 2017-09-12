//
//  HourlyWeatherObject.h
//  MS_iOSChallenge_POC
//
//  Created by Singh, Vikaskumar on 9/10/17.
//  Copyright © 2017 Singh, Vikaskumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HourlyWeatherObject : NSObject

@property (nonatomic , strong) NSString *apparentTemperature;
@property (nonatomic , strong) NSString *humidity;
@property (nonatomic , strong) NSString *icon;
@property (nonatomic , strong) NSString *summary;
@property (nonatomic , strong) NSString *currentDayDate;

- (id) initWithDict:(NSDictionary *)dictionary;

@end
