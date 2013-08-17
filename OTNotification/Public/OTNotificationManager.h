//
//  OTNotificationManager.h
//  OTNotificationDemo
//
//  Created by openthread on 8/15/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTNotificationMessage.h"

@interface OTNotificationManager : NSObject

#pragma mark - Get notificatio manager instance

+ (OTNotificationManager *)defaultManager;

#pragma mark - Notification Methods

//Post notification message
- (void)postNotificationMessage:(OTNotificationMessage *)message;

//Remove notification message
- (void)removeNotificationMessage:(OTNotificationMessage *)message;

//Post notification view
- (void)postNotificationView:(UIView/*<OTNotificationViewProtocol>*/ *)view;

//Remove unappeared notification view. will take no effect on showing view and showed view.
- (void)removeNotificationView:(UIView *)view;

//Remove all notification messages and notification views.
- (void)removeAllNotifications;

#pragma mark - Check if notification window is hidden.

//Check if notification window is hidden. Default is YES.
@property(nonatomic, readonly) BOOL isNotificationWindowHidden;

#pragma mark - Display duration

//The display duration per each notification message. Default is 2 seconds.
@property (nonatomic, assign) NSTimeInterval notificationDisplayDuration;

//The interval before dismiss notification window after notification messages display ends.
//Default is 3 seconds.
@property (nonatomic, assign) NSTimeInterval dismissInterval;

#pragma mark - Rotating Methods

//You needn't call rotate methods or access rotate property in most situations.

//Auto rotate, default is `YES`.
@property (nonatomic, assign) BOOL shouldNotificationAutoRotateToInterfaceOrientation;

//Manual rotate
- (void)setWindowOrientation:(UIInterfaceOrientation)o;
- (void)setWindowOrientation:(UIInterfaceOrientation)o
                    animated:(BOOL)animated;
- (void)setWindowOrientation:(UIInterfaceOrientation)o
                    animated:(BOOL)animated
           animationDuration:(NSTimeInterval)animationDuration;

@end
