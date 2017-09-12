//
//  EventViewController.h
//  MS_iOSChallenge_POC
//
//  Created by Singh, Vikaskumar on 9/9/17.
//  Copyright © 2017 Singh, Vikaskumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface EventViewController : UIViewController <UITextFieldDelegate>

@property (strong , nonatomic) EKEvent *event;
@property BOOL isShowToDetailEvent;

@end
