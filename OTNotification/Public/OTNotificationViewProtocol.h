//
//  OTNotificationView.h
//  OTNotificationWindowDemo
//
//  Created by openthread on 8/14/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OTNotificationViewProtocol <NSObject>

@optional

//view state callback.
- (void)viewWillRotateIn;
- (void)viewDidRotateIn;
- (void)viewWillRotateOut;
- (void)viewDidRotateOut;

//touch block
@property (nonatomic, copy) void (^otNotificationTouchBlock) (void);

//touch target and selector
@property (nonatomic, assign) id otNotificationTouchTarget;
@property (nonatomic, assign) SEL otNotificationTouchSelector;

//Should hide on touch.
@property (nonatomic, assign) BOOL otNotificationShouldHideOnTouch;

@end
