//
//  WeatherManager.h
//  MS_iOSChallenge_POC
//
//  Created by Singh, Vikaskumar on 9/10/17.
//  Copyright © 2017 Singh, Vikaskumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherObject.h"
#import "Utility.h"
#import <CoreLocation/CoreLocation.h>

@interface WeatherManager : NSObject <NSURLConnectionDataDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@property NSURLSession * myNSURLSession;
@property NSMutableDictionary * responsesData;

+ (WeatherManager *) sharedManager;

- (NSURLRequest *) createRequestWithBaseUrl:(NSString *)baseUrl withlatitude:(NSString *)latitude andlongitude:(NSString *)longitude isPostRequest:(BOOL)isPost;

- (void) fetchAllWeatherDataForLocation:(CLLocationCoordinate2D)coordinates completion:(void (^)(WeatherObject *, BOOL isSuccess))callBack;
@end
