//
//  WeatherForecastViewController.m
//  MS_iOSChallenge_POC
//
//  Created by Singh, Vikaskumar on 9/9/17.
//  Copyright © 2017 Singh, Vikaskumar. All rights reserved.
//

#import "WeatherForecastViewController.h"
#import "WeatherManager.h"
#import "DailyWeatherObject.h"
#import "HourlyWeatherObject.h"
#import "Utility.h"

@interface WeatherForecastViewController (){

    CLLocation *currentLocation;
    WeatherObject *weatherObject;
}

@property (nonatomic , weak) IBOutlet UITableView *dailyBasisTableView;
@property (nonatomic , weak) IBOutlet UITableView *hourlyBasisTableView;
@property (nonatomic , strong) CLLocationManager *locationManager;

@end

@implementation WeatherForecastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    self.indicatorContainerView.hidden = FALSE;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    NSLog(@"error%@",error);
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please check your network connection or that you are not in airplane mode." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
            break;
        case kCLErrorDenied:{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"User has denied to use current Location." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        default:
        {
            #if TARGET_IPHONE_SIMULATOR
                        
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Unknown network error. Please select the location from Debug bar of Xcode." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            
            #else // TARGET_IPHONE_SIMULATOR
                        
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Unknown network error." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            
            #endif // TARGET_IPHONE_SIMULATOR
        }
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [manager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [self.indicatorView startAnimating];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             self.cityNameLabel.text = [NSString stringWithFormat:@"%@, %@", placemark.locality,placemark.administrativeArea];
             
             __weak typeof(self) weakSelf = self;
             [[WeatherManager sharedManager] fetchAllWeatherDataForLocation:placemark.location.coordinate completion:^(WeatherObject *weather , BOOL isSuccess){
                 [self.indicatorView stopAnimating];
                 if (isSuccess) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          self.indicatorContainerView.hidden = TRUE;
                         weatherObject = weather;
                         weakSelf.cityTempratureLabel.text = weatherObject.temperature;
                         weakSelf.citySummaryLabel.text = weatherObject.currentDayDate;
                         weakSelf.currentWeatherIcon.image = [UIImage imageNamed:weatherObject.icon];
                          weakSelf.cityHumidityLabel.text = [NSString stringWithFormat:@"Humidity: %@", ((DailyWeatherObject *)[weatherObject.dailyDataArray objectAtIndex:0]).humidity];
                         [weakSelf.hourlyBasisTableView reloadData];
                         [weakSelf.dailyBasisTableView reloadData];
                      });
                 }
             }];
             
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"%@",CountryArea);
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
         }
     }];
}


#pragma mark - TableView Data Source / Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (weatherObject.dailyDataArray.count > 0) {
        if (tableView == self.dailyBasisTableView) {
            return 1;
        }
        else if(tableView == self.hourlyBasisTableView){
            if (section==0) {
                return 25;
            }
        }
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, tableView.bounds.size.width, 30)];
    //headerView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    headerView.backgroundColor = [UIColor whiteColor];
    
    if (tableView == self.hourlyBasisTableView) {
        
        if (section == 0) {
            
            UILabel *label = [[UILabel alloc] init ];
            label.frame =CGRectMake(5, 0, tableView.bounds.size.width-10, 30);
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont fontWithName:@"Helvetica" size:13];
            label.text = @"Weather for the next 24 hours";
            [headerView addSubview:label];
        }
    }
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.hourlyBasisTableView) {
        if (indexPath.section == 0) {
            return 60;
        }
    }
    else if(tableView == self.dailyBasisTableView){
        return 180;
    }
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (tableView == self.dailyBasisTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellDaily"];
    }
    else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellHourly"];
        
        HourlyWeatherObject *tempObj = (HourlyWeatherObject *)[weatherObject.hourlyDataArray objectAtIndex:indexPath.row];
        
        UILabel *dayLabel =(UILabel *)[cell viewWithTag:20];
        dayLabel.text = [Utility convertStringOnlyTimeFormateFromDate:[Utility dateFromString:tempObj.currentDayDate]];
        
        UIImageView *imageView =(UIImageView *)[cell viewWithTag:21];
        if ([UIImage imageNamed:tempObj.icon]) {
            imageView.image = [UIImage imageNamed:tempObj.icon];
        }
        else{
            imageView.image = [UIImage imageNamed:@"rain"];
        }
        
        UILabel *temperature =(UILabel *)[cell viewWithTag:22];
        temperature.text = tempObj.apparentTemperature;
        
        UILabel *humidityLabel =(UILabel *)[cell viewWithTag:23];
        humidityLabel.text = tempObj.humidity;
    }
    
        //other configuration block
    return cell;
}


#pragma mark - TableView Data Source / Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //top, left, bottom, right
    return UIEdgeInsetsMake(0, 5, 0, 5);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cvCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CVCell" forIndexPath:indexPath];
    
    UILabel *dayLabel =(UILabel *)[cvCell viewWithTag:10];
    DailyWeatherObject *tempObj = (DailyWeatherObject *)[weatherObject.dailyDataArray objectAtIndex:indexPath.row+1];
    dayLabel.text = [Utility convertDateIntoDayFormat:[Utility dateFromString:tempObj.dailyTime]];

    UIImageView *imageView =(UIImageView *)[cvCell viewWithTag:11];
    if ([UIImage imageNamed:tempObj.icon]) {
        imageView.image = [UIImage imageNamed:tempObj.icon];
    }
    else{
        imageView.image = [UIImage imageNamed:@"rain"];
    }
    
    UILabel *minTempLabel =(UILabel *)[cvCell viewWithTag:12];
    minTempLabel.text = tempObj.minTemperature;
    
    UILabel *maxTempLabel =(UILabel *)[cvCell viewWithTag:13];
    maxTempLabel.text = tempObj.maxTemperature;
    
    UILabel *humidityLabel =(UILabel *)[cvCell viewWithTag:14];
    humidityLabel.text = tempObj.humidity;
    
    return cvCell;
}


@end
