//
//  DataMethods.h
//  MS_iOSChallenge_POC
//
//  Created by Singh, Vikaskumar on 9/10/17.
//  Copyright © 2017 Singh, Vikaskumar. All rights reserved.
//

#import "DataMethods.h"

@implementation DataMethods

+ (id) checkForNull:(id)dataObject withAlternative:(id)alternative
{
    if ( [dataObject class] ==  nil || [dataObject class] == [NSNull class] )
        return alternative;
    
    return dataObject;
}

+ (NSString *) formmatedPhoneNumber:(NSNumber *)phoneNumber
{
    //phoneNumber = [
    return @"";
}

@end
