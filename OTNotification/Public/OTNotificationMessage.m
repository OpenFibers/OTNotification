//
//  OTNotificationMessage.m
//  OTNotificationWindowDemo
//
//  Created by openthread on 8/15/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import "OTNotificationMessage.h"

@implementation OTNotificationMessage

- (id)init
{
    self =  [super init];
    if (self)
    {
        self.showIcon = YES;
        self.otNotificationShouldHideOnTouch = YES;
    }
    return self;
}

@end
