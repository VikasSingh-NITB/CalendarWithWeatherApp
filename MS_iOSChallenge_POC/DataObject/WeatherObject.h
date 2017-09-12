//
//  WeatherObject.h
//  MS_iOSChallenge_POC
//
//  Created by Singh, Vikaskumar on 9/10/17.
//  Copyright © 2017 Singh, Vikaskumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataMethods.h"

@interface WeatherObject : NSObject

@property (nonatomic , strong) NSString *temperature;
@property (nonatomic , strong) NSArray *hourlyDataArray;
@property (nonatomic , strong) NSArray *dailyDataArray;
@property (nonatomic , strong) NSString *summary;
@property (nonatomic , strong) NSString *icon;
@property (nonatomic , strong) NSString *currentDayDate;

- (id) initWithDictionary:(NSDictionary *)dictionaryResponse;

@end


