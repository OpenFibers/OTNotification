//
//  OTNotificationSuperView.h
//  OTNotificationViewDemo
//
//  Created by openthread on 8/11/13.
//
//  The window to cover status bar and show notifications.

#import <UIKit/UIKit.h>
#import "ComOpenthreadOTNotificationNoneRenderInContextWindow.h"

@protocol ComOpenthreadOTNotificationRotateWindowDelegate <NSObject>

- (void)contentViewFrameChangedTo:(CGRect)frame;

@end

@interface ComOpenthreadOTNotificationRotateWindow : ComOpenthreadOTNotificationNoneRenderInContextWindow

//Auto rotate, default is `YES`.
@property (nonatomic, assign) BOOL shouldAutoRotateToInterfaceOrientation;

//Manual rotate
- (void)setWindowOrientation:(UIInterfaceOrientation)o;
- (void)setWindowOrientation:(UIInterfaceOrientation)o
                    animated:(BOOL)animated;
- (void)setWindowOrientation:(UIInterfaceOrientation)o
                    animated:(BOOL)animated
           animationDuration:(NSTimeInterval)animationDuration;

@property(nonatomic,getter=isHidden) BOOL hidden;// default is YES. doesn't check superviews
- (void)show;//Set hidden to NO
- (void)hide;//Set hidden to YES

//Get content view instance.
//You shouldn't change content view's frame, its frame is managed by this window.
@property (nonatomic, readonly) UIView *contentView;

//Delegate
@property (nonatomic, assign) id<ComOpenthreadOTNotificationRotateWindowDelegate> contentViewFrameDelegate;

//Get instance
+ (ComOpenthreadOTNotificationRotateWindow *)sharedInstance;

@end
