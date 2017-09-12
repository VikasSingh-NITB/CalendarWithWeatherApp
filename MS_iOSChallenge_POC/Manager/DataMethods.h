//
//  DataMethods.h
//  MS_iOSChallenge_POC
//
//  Created by Singh, Vikaskumar on 9/10/17.
//  Copyright © 2017 Singh, Vikaskumar. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface DataMethods : NSObject

+ (id) checkForNull:(id)dataObject withAlternative:(id)alternative;

+ (NSString *) formmatedPhoneNumber:(NSNumber *)phoneNumber;

@end
