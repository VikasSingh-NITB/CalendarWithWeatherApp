//
//  HourlyWeatherObject.m
//  MS_iOSChallenge_POC
//
//  Created by Singh, Vikaskumar on 9/10/17.
//  Copyright © 2017 Singh, Vikaskumar. All rights reserved.
//

#import "HourlyWeatherObject.h"
#import "Utility.h"
#import "DataMethods.h"

@implementation HourlyWeatherObject


- (id) initWithDict:(NSDictionary *)dictionary{

    if (self = [super init]) {
        
        self.apparentTemperature = [Utility convertFahrenheitToCelsius:[[DataMethods checkForNull:[dictionary valueForKey:@"apparentTemperature"] withAlternative:@"0.0"]doubleValue]];
        
        self.icon = [DataMethods checkForNull:[dictionary valueForKey:@"icon"] withAlternative:@""];
        
        self.summary = [DataMethods checkForNull:[dictionary valueForKey:@"summary"] withAlternative:@""];
        
        self.humidity = [NSString stringWithFormat:@"%d%@",(int)([[DataMethods checkForNull:[dictionary valueForKey:@"humidity"] withAlternative:@""] floatValue]*100),@"%"];
        
        self.currentDayDate =[Utility dateFromUnixTimestamp: [[DataMethods checkForNull:[dictionary valueForKey:@"time"] withAlternative:@"0.0"] doubleValue]];
    
    }

    return self;
}
/*
 apparentTemperature = "92.05";
 cloudCover = "0.37";
 dewPoint = "78.38";
 humidity = "0.88";
 icon = rain;
 ozone = "265.98";
 precipIntensity = "0.0619";
 precipProbability = "0.15";
 precipType = rain;
 pressure = "1005.9";
 summary = Rain;
 temperature = "82.27";
 time = 1505003400;
 uvIndex = 0;
 visibility = "1.55";
 windBearing = 320;
 windGust = "4.19";
 windSpeed = "1.62";
 
*/

@end
