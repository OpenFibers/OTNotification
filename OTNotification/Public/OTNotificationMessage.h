//
//  OTNotificationMessage.h
//  OTNotificationWindowDemo
//
//  Created by openthread on 8/15/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTNotificationMessage : NSObject

//Title string.
@property (nonatomic, retain) NSString *title;

//Message string.
@property (nonatomic, retain) NSString *message;

//Set whether show icon. if NO, texts will be left shifted.
@property (nonatomic, assign) BOOL showIcon;

//18x18 in none-retina screen, 36x36 in retina screen is encouraged.
@property (nonatomic, retain) UIImage *iconImage;

//touch block
@property (nonatomic, copy) void (^otNotificationTouchBlock) (void);

//touch target and selector
@property (nonatomic, assign) id otNotificationTouchTarget;
@property (nonatomic, assign) SEL otNotificationTouchSelector;

//Should hide on touch.
@property (nonatomic, assign) BOOL otNotificationShouldHideOnTouch;

@end
