//
//  OTMessageNotificationView.h
//  OTNotificationWindowDemo
//
//  Created by openthread on 8/14/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import "ComOpenthreadOTNotificationBasicNotificationView.h"
@class OTNotificationMessage;

@interface ComOpenthreadOTNotificationMessageNotificationView : ComOpenthreadOTNotificationBasicNotificationView

//Title string.
@property (nonatomic, retain) NSString *title;

//Message string.
@property (nonatomic, retain) NSString *message;

//Set whether show icon. if NO, texts will be left shifted.
@property (nonatomic, assign) BOOL showIcon;

//18x18 in none-retina screen, 36x36 in retina screen is encouraged.
@property (nonatomic, retain) UIImage *iconImage;

//Set a notification message instead of set the 4 properties above.
@property (nonatomic, retain) OTNotificationMessage *notificationMessage;

@end
