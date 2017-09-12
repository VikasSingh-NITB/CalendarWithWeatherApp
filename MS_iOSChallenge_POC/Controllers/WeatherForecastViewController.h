//
//  WeatherForecastViewController.h
//  MS_iOSChallenge_POC
//
//  Created by Singh, Vikaskumar on 9/9/17.
//  Copyright © 2017 Singh, Vikaskumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface WeatherForecastViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic , weak) IBOutlet UILabel *cityNameLabel;
@property (nonatomic , weak) IBOutlet UILabel *citySummaryLabel;
@property (nonatomic , weak) IBOutlet UILabel *cityTempratureLabel;
@property (nonatomic , weak) IBOutlet UILabel *cityHumidityLabel;
@property (nonatomic , weak) IBOutlet UIView *indicatorContainerView;
@property (nonatomic , weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic , weak)IBOutlet UIImageView *currentWeatherIcon;
@end
