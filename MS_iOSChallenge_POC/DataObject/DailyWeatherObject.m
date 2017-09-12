//
//  DailyWeatherObject.m
//  MS_iOSChallenge_POC
//
//  Created by Singh, Vikaskumar on 9/10/17.
//  Copyright © 2017 Singh, Vikaskumar. All rights reserved.
//

#import "DailyWeatherObject.h"
#import "Utility.h"
#import "DataMethods.h"

@implementation DailyWeatherObject

- (id) initWithDict:(NSDictionary *)dictionary
{
    if ( self = [super init] )
    {
        self.apparentTemperature = [Utility convertFahrenheitToCelsius:[[DataMethods checkForNull:[dictionary valueForKey:@"apparentTemperature"] withAlternative:@"0.0"]doubleValue]];
        
        self.maxTemperature = [Utility convertFahrenheitToCelsius:[[DataMethods checkForNull:[dictionary valueForKey:@"temperatureHigh"] withAlternative:@"0.0"]doubleValue]];
        
        self.minTemperature = [Utility convertFahrenheitToCelsius:[[DataMethods checkForNull:[dictionary valueForKey:@"temperatureLow"] withAlternative:@"0.0"]doubleValue]];
        
        self.icon = [DataMethods checkForNull:[dictionary valueForKey:@"icon"] withAlternative:@""];
        
        self.summary = [DataMethods checkForNull:[dictionary valueForKey:@"summary"] withAlternative:@""];
        
        self.humidity = [NSString stringWithFormat:@"%d%@",(int)([[DataMethods checkForNull:[dictionary valueForKey:@"humidity"] withAlternative:@""] floatValue]*100),@"%"];
        
        self.dailyTime =[Utility dateFromUnixTimestamp: [[DataMethods checkForNull:[dictionary valueForKey:@"time"] withAlternative:@"0.0"] doubleValue]];
        
        self.sunriseTime =[Utility dateFromUnixTimestamp: [[DataMethods checkForNull:[dictionary valueForKey:@"sunriseTime"] withAlternative:@"0.0"] doubleValue]];
        
        self.sunsetTime =[Utility dateFromUnixTimestamp: [[DataMethods checkForNull:[dictionary valueForKey:@"sunsetTime"] withAlternative:@"0.0"] doubleValue]];
        
    }
    return self;
}

@end


/*
 apparentTemperatureHigh = "93.79000000000001";
 apparentTemperatureHighTime = 1505644200;
 apparentTemperatureLow = "78.73999999999999";
 apparentTemperatureLowTime = 1505698200;
 apparentTemperatureMax = "93.79000000000001";
 apparentTemperatureMaxTime = 1505644200;
 apparentTemperatureMin = "79.06";
 apparentTemperatureMinTime = 1505611800;
 cloudCover = "0.86";
 dewPoint = "74.81";
 humidity = "0.8100000000000001";
 icon = rain;
 moonPhase = "0.9";
 ozone = 256;
 precipIntensity = "0.0255";
 precipIntensityMax = "0.0618";
 precipIntensityMaxTime = 1505615400;
 precipProbability = "0.58";
 precipType = rain;
 pressure = "1009.03";
 summary = "Rain throughout the day.";
 sunriseTime = 1505609872;
 sunsetTime = 1505653871;
 temperatureHigh = "84.63";
 temperatureHighTime = 1505644200;
 temperatureLow = "77.2";
 temperatureLowTime = 1505698200;
 temperatureMax = "84.63";
 temperatureMaxTime = 1505644200;
 temperatureMin = "77.45999999999999";
 temperatureMinTime = 1505611800;
 time = 1505586600;
 uvIndex = 8;
 uvIndexTime = 1505629800;
 windBearing = 217;
 windGust = "11.34";
 windGustTime = 1505647800;
 windSpeed = "5.13";
*/
