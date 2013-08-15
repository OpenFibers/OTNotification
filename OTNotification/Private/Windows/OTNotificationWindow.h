//
//  OTNotificationWindow.h
//  OTNotificationViewDemo
//
//  Created by openthread on 8/12/13.
//
//  A window simulate push notifications in iOS6.
//  TODO:
//      touch in cube, delegate
//      shadow of notificaton window
//      Add notification manager

#import "ComOpenthreadOTNotificationRotateWindow.h"
#import "OTNotificationViewProtocol.h"
#import "OTNotificationMessage.h"

@interface OTNotificationWindow : ComOpenthreadOTNotificationRotateWindow

//default is YES. don't set value to `hidden` property, nothing will happen
@property(nonatomic,getter=isHidden) BOOL hidden;

//Auto rotate
@property (nonatomic, assign) BOOL shouldAutoRotateToInterfaceOrientation;

//Manual rotate
- (void)setWindowOrientation:(UIInterfaceOrientation)o;
- (void)setWindowOrientation:(UIInterfaceOrientation)o
                    animated:(BOOL)animated;
- (void)setWindowOrientation:(UIInterfaceOrientation)o
                    animated:(BOOL)animated
           animationDuration:(NSTimeInterval)animationDuration;

//Post notification message
- (void)postNotificationMessage:(OTNotificationMessage *)message;

//Remove notification message
- (void)removeNotificationMessage:(OTNotificationMessage *)message;


//Post notification view
- (void)postNotificationView:(UIView/*<OTNotificationViewProtocol>*/ *)view;

//Remove unappeared notification view. will take no effect on showing view and showed view.
- (void)removeNotificationView:(UIView *)view;

+ (OTNotificationWindow *)sharedInstance;

@end
