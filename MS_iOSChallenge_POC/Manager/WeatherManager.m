//
//  WeatherManager.m
//  MS_iOSChallenge_POC
//
//  Created by Singh, Vikaskumar on 9/10/17.
//  Copyright © 2017 Singh, Vikaskumar. All rights reserved.
//

#import "WeatherManager.h"



#define BaseUrl @"https://api.darksky.net/forecast/c92cea8cbaf62063cd0827b29212269d/"

@implementation WeatherManager

static WeatherManager * sharedWeatherManager = nil;

+ (WeatherManager *) sharedManager {
    
    if ( sharedWeatherManager == nil )
    {
        sharedWeatherManager = [[WeatherManager alloc] init];
        NSURLSessionConfiguration * tmpSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        [tmpSessionConfig setTimeoutIntervalForRequest:300];
        sharedWeatherManager.myNSURLSession = [NSURLSession sessionWithConfiguration:tmpSessionConfig delegate:sharedWeatherManager delegateQueue:nil];
        sharedWeatherManager.responsesData = [[NSMutableDictionary alloc] init];
    }
    return sharedWeatherManager;
}

- (void) fetchAllWeatherDataForLocation:(CLLocationCoordinate2D)coordinates completion:(void (^)(WeatherObject *, BOOL))callBack
{
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLRequest * request = [self createRequestWithBaseUrl:BaseUrl withlatitude:[NSString stringWithFormat:@"%f", coordinates.latitude] andlongitude:[NSString stringWithFormat:@"%f", coordinates.longitude] isPostRequest:NO];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (error)
          {
              callBack(nil,NO);
          }
          else{
              dispatch_async(dispatch_get_main_queue(), ^(void){
                  NSDictionary *dictionaryResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                  NSLog(@"%@",dictionaryResponse);
                  WeatherObject * tempWeatherObject = [[WeatherObject alloc] initWithDictionary:dictionaryResponse];
                  callBack(tempWeatherObject,YES);
                  NSLog(@"%@",tempWeatherObject);
              
              });
          }
      }]resume];
    
    
}
- (NSURLRequest *) createRequestWithBaseUrl:(NSString *)baseUrl withlatitude:(NSString *)latitude andlongitude:(NSString *)longitude isPostRequest:(BOOL)isPost{
    
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseUrl]];
    if ( isPost )
    {
        [request setHTTPMethod:@"POST"];
        NSMutableData *body = [NSMutableData data];
        [body appendData:[latitude dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[longitude dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSLog(@"POST Method Parameter String are : %@", [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@,%@", baseUrl, latitude,longitude]]);
        
        return request;
    }
    
    request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@,%@", baseUrl, latitude,longitude]];
    NSLog(@"GET Request API is: %@", baseUrl);
    NSLog(@"GET Request paramters are: %@", [request URL]);
    
    return request;
}

@end
