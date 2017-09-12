//
//  WeatherObject.m
//  MS_iOSChallenge_POC
//
//  Created by Singh, Vikaskumar on 9/10/17.
//  Copyright © 2017 Singh, Vikaskumar. All rights reserved.
//

#import "WeatherObject.h"
#import "Utility.h"
#import "DailyWeatherObject.h"
#import "HourlyWeatherObject.h"

@implementation WeatherObject


- (id) initWithDictionary:(NSDictionary *)dictionaryResponse
{
    if ( self = [super init] )
    {
        
        NSDictionary * currentlyDataDict = [DataMethods checkForNull:[dictionaryResponse valueForKey:@"currently"] withAlternative:@[]];
        
        self.temperature = [Utility convertFahrenheitToCelsius:[[DataMethods checkForNull:[currentlyDataDict valueForKey:@"temperature"] withAlternative:@"0.0"] doubleValue]];
        
        self.icon = [DataMethods checkForNull:[currentlyDataDict valueForKey:@"icon"] withAlternative:@""];
        
        self.summary = [DataMethods checkForNull:[currentlyDataDict valueForKey:@"summary"] withAlternative:@""];
        
        self.currentDayDate =[Utility dateFromUnixTimestamp: [[DataMethods checkForNull:[currentlyDataDict valueForKey:@"time"] withAlternative:@"0.0"] doubleValue]];
        
        
        NSMutableArray * tmpDailyWeatherArray = [[NSMutableArray alloc] init];
        NSDictionary * dailyDataDict = [DataMethods checkForNull:[dictionaryResponse valueForKey:@"daily"] withAlternative:@[]];
        
        self.summary = [DataMethods checkForNull:[dailyDataDict valueForKey:@"summary"] withAlternative:@""];
        
        NSArray *dailyDataArray =  [DataMethods checkForNull:[dailyDataDict valueForKey:@"data"] withAlternative:@[]];
        
        
        for ( int i = 0; i < [dailyDataArray count]; i++ )
        {
            DailyWeatherObject *dailyWeatherObject = [[DailyWeatherObject alloc]initWithDict:[dailyDataArray objectAtIndex:i]];
            [tmpDailyWeatherArray addObject:dailyWeatherObject];
        }
        self.dailyDataArray = tmpDailyWeatherArray;
        
        NSMutableArray * tmpHourlyWeatherArray = [[NSMutableArray alloc] init];
        NSDictionary * hourlyDataDict = [DataMethods checkForNull:[dictionaryResponse valueForKey:@"hourly"] withAlternative:@[]];
        NSArray *hourlyDataArray =  [DataMethods checkForNull:[hourlyDataDict valueForKey:@"data"] withAlternative:@[]];
        
        for ( int i = 0; i < [hourlyDataArray count]; i++ )
        {
            HourlyWeatherObject *dailyWeatherObject = [[HourlyWeatherObject alloc]initWithDict:[hourlyDataArray objectAtIndex:i]];
            [tmpHourlyWeatherArray addObject:dailyWeatherObject];
        }
        self.hourlyDataArray = tmpHourlyWeatherArray;
        
    }
    return self;
}

@end


/*
 apparentTemperature = "91.66";
 cloudCover = "0.41";
 dewPoint = "78.23";
 humidity = "0.88";
 icon = rain;
 ozone = "266.14";
 precipIntensity = "0.0557";
 precipProbability = "0.14";
 precipType = rain;
 pressure = "1006.07";
 summary = Drizzle;
 temperature = "82.15000000000001";
 time = 1505004365;
 uvIndex = 0;
 visibility = "1.55";
 windBearing = 330;
 windGust = "4.09";
 windSpeed = "1.39";
*/
