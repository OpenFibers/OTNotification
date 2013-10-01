//
//  OTNotificationWindow.m
//  OTNotificationViewDemo
//
//  Created by openthread on 8/12/13.
//
//

#import "ComOpenthreadOTNotificationMessageWindow.h"
#import "ComOpenthreadOTCubeRotateView.h"
#import "ComOpenthreadOTScreenshotHelper.h"
#import "ComOpenthreadOTNotificationContentView.h"
#import "ComOpenthreadOTNotificationMessageNotificationView.h"
#import "ComOpenthreadOTNotificationUpdatingScreenshotView.h"
#import <objc/message.h>

typedef enum {
    OTNotificationWindowStateHidden,//Hidding
    OTNotificationWindowStateCubeRotatingIn,//Rotating in
    OTNotificationWindowStateShowing,//Showing
    OTNotificationWindowStateWaitingCubeRotatingOut,
    OTNotificationWindowStateCubeRotatingOut//Rotating out
} OTNotificationWindowState;

@interface ComOpenthreadOTNotificationMessageWindow()
<
    ComOpenthreadOTNotificationRotateWindowDelegate,
    ComOpenthreadOTNotificationUpdatingScreenshotViewDelegate
>

@property (nonatomic, assign) OTNotificationWindowState state;

@end

@implementation ComOpenthreadOTNotificationMessageWindow
{
    ComOpenthreadOTCubeRotateView *_cubeRotateView;
    UIButton *_cubeTouchButton;
    UIImageView *_cubeShadowView;
    ComOpenthreadOTNotificationUpdatingScreenshotView *_screenshotView;
    NSMutableArray *_notificationQueue;
}

@dynamic shouldAutoRotateToInterfaceOrientation;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.notificationDisplayDuration = 2.0f;
        self.dismissInterval = 3.0f;
        
        self.contentViewFrameDelegate = self;
        
        _cubeRotateView = [[ComOpenthreadOTCubeRotateView alloc] initWithFrame:self.contentView.bounds];
        _cubeRotateView.clipsToBounds = YES;
        _cubeRotateView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_cubeRotateView];
        
        //Init shadow view
        
        UIImage *shadowImage = [UIImage imageNamed:@"ComOpenthreadOTNotificationNotifShadow.png"];
        shadowImage = [shadowImage stretchableImageWithLeftCapWidth:47 topCapHeight:47];
        _cubeShadowView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _cubeShadowView.image = shadowImage;
        CGRect shadowFrame = _cubeRotateView.frame;
        shadowFrame.origin.x -= 27;
        shadowFrame.origin.y -= 27;
        shadowFrame.size.width += 54;
        shadowFrame.size.height += 54;
        _cubeShadowView.frame = shadowFrame;
        [self.contentView insertSubview:_cubeShadowView belowSubview:_cubeRotateView];
        
        //Add button to cube rotate view
        _cubeTouchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cubeTouchButton.frame = _cubeRotateView.bounds;
        [_cubeTouchButton addTarget:self action:@selector(cubeTouched) forControlEvents:UIControlEventTouchDown];
        [_cubeRotateView addSubview:_cubeTouchButton];
        
        UIView *currentRotateView = [[UIView alloc] initWithFrame:CGRectZero];
        [_cubeRotateView setCurrentView:currentRotateView];
        
        _notificationQueue = [NSMutableArray array];
        
        [self setHiddenPrivate:YES];
        self.state = OTNotificationWindowStateHidden;
    }
    return self;
}

//Change content view and notification view's frame when screen rotates
- (void)contentViewFrameChangedTo:(CGRect)frame
{
    _cubeRotateView.frame = self.contentView.bounds;
    _cubeTouchButton.frame = _cubeRotateView.bounds;
    
    CGRect shadowFrame = _cubeRotateView.frame;
    shadowFrame.origin.x -= 27;
    shadowFrame.origin.y -= 27;
    shadowFrame.size.width += 54;
    shadowFrame.size.height += 54;
    _cubeShadowView.frame = shadowFrame;
    
    //Avoid status bar screenshot be stretched, hide self when cube rotating out.
    if (self.state == OTNotificationWindowStateCubeRotatingOut)
    {
        [self setHiddenPrivate:YES];
        _cubeShadowView.hidden = YES;
        self.state = OTNotificationWindowStateHidden;
    }
}

//Remove notification message
- (void)removeNotificationMessage:(OTNotificationMessage *)message
{
    if ([_notificationQueue containsObject:message])
    {
        [_notificationQueue removeObject:message];
    }
}

//Post notification message
- (void)postNotificationMessage:(OTNotificationMessage *)message
{
    if ([_notificationQueue containsObject:message])
    {
        return;
    }
    [_notificationQueue addObject:message];
    [self checkStatusAfterPost];
}

- (void)removeNotificationView:(UIView *)view
{
    if([_notificationQueue containsObject:view])
    {
        [_notificationQueue removeObject:view];
    }
}

- (void)removeAllNotifications
{
    [_notificationQueue removeAllObjects];
}

- (void)postNotificationView:(UIView *)view
{
    if ([_notificationQueue containsObject:view])
    {
        return;
    }
    [_notificationQueue addObject:view];
    [self checkStatusAfterPost];
}

- (void)checkStatusAfterPost
{
    //If self is hidden, handle notification immediately
    if (self.state == OTNotificationWindowStateHidden)
    {
        [self handleNotifications];
    }
    //If wait hiding, cancel wait hiding, and handle notification immediately
    else if (self.state ==  OTNotificationWindowStateWaitingCubeRotatingOut)
    {
        [self handleNotifications];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cubeOut) object:nil];
    }
    // If cube rotating out, handle notification later.
    else if (self.state == OTNotificationWindowStateCubeRotatingOut)
    {
        [self performSelector:@selector(handleNotifications) withObject:nil afterDelay:1];
    }
    //otherwise, don't need to call `handleNotifications`, `handleNotifications` will call it self
}

- (void)handleNotifications
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleNotifications) object:nil];
    
    //If no notification comes in, cube out.
    if (_notificationQueue.count <= 0)
    {
        self.state = OTNotificationWindowStateWaitingCubeRotatingOut;
        [self performSelector:@selector(cubeOut) withObject:nil afterDelay:self.dismissInterval];
        return;
    }
        
    //If self is hidden, cube out screenshot and set hidden to NO
    UIImage *screenshot = nil;
    if (self.state == OTNotificationWindowStateHidden)
    {
        screenshot = [self getScreenshotForCubeRect];
        [_cubeRotateView setCurrentView:[[UIImageView alloc] initWithImage:screenshot]];
        [self setHiddenPrivate:NO];
        
        _cubeShadowView.alpha = 0;
        _cubeShadowView.hidden = NO;
        [UIView animateWithDuration:0.2f
                              delay:0.3f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _cubeShadowView.alpha = 1;

                         } completion:nil];
    }
    
    self.state = OTNotificationWindowStateCubeRotatingIn;
    
    //Get a notification view from notification view stack, and remove it from stack.
    id obj = _notificationQueue[0];
    [_notificationQueue removeObject:obj];
    
    UIView *view = nil;
    if ([obj isKindOfClass:[UIView class]])
    {
        view = obj;
    }
    else if ([obj isKindOfClass:[OTNotificationMessage class]])
    {
        view = [[ComOpenthreadOTNotificationMessageNotificationView alloc] init];
        ((ComOpenthreadOTNotificationMessageNotificationView *)view).notificationMessage = obj;
    }
    else
    {
        [self handleNotifications];
    }
    
    ComOpenthreadOTNotificationContentView *contentView = [[ComOpenthreadOTNotificationContentView alloc] initWithFrame:_cubeRotateView.bounds];
    contentView.notificationView = view;
    
    //set cube rotate view's background color to black
    _cubeRotateView.backgroundColor = [UIColor blackColor];
    
    //If on ipad, set rotating in and out content views' background image to screenshot
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        //set rotating in content view's background image to screenshot
        if (!screenshot) {screenshot = [self getScreenshotForCubeRect];}
        contentView.backgroundImage = screenshot;
        contentView.backgroundImageHidden = NO;
        
        //set rotating out content view's background image to screenshot
        UIView *currentView = _cubeRotateView.currentView;
        if ([currentView isKindOfClass:[ComOpenthreadOTNotificationContentView class]])
        {
            ((ComOpenthreadOTNotificationContentView *)currentView).backgroundImage = screenshot;
            ((ComOpenthreadOTNotificationContentView *)currentView).backgroundImageHidden = NO;
        }
    }
    
    if ([view respondsToSelector:@selector(viewWillRotateIn)])
    {
        objc_msgSend(view, @selector(viewWillRotateIn));
    }
    
    UIView *currentView = _cubeRotateView.currentView;
    UIView *oldNotifView = nil;
    if ([currentView isKindOfClass:[ComOpenthreadOTNotificationContentView class]])
    {
        oldNotifView = ((ComOpenthreadOTNotificationContentView *)currentView).notificationView;
    }
    if ([oldNotifView respondsToSelector:@selector(viewWillRotateOut)])
    {
        objc_msgSend(oldNotifView, @selector(viewWillRotateOut));
    }
    
    //Show notification view.
    [_cubeRotateView rotateToView:contentView
                             from:OTCubeViewRotateSideFromUpSide
                animationDuration:0.5 completion:^{
                    //set cube rotate view's background color to clear
                    _cubeRotateView.backgroundColor = [UIColor clearColor];
                    
                    if ([view respondsToSelector:@selector(viewDidRotateIn)])
                    {
                        objc_msgSend(view, @selector(viewDidRotateIn));
                    }
                    if ([oldNotifView respondsToSelector:@selector(viewDidRotateOut)])
                    {
                        objc_msgSend(oldNotifView, @selector(viewDidRotateOut));
                    }
                    
                    //If on ipad, set content background image to hidden
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
                    {
                        contentView.backgroundImageHidden = YES;
                        contentView.backgroundImage = nil;
                    }
                    [self performSelector:@selector(handleNotifications)
                               withObject:nil
                               afterDelay:self.notificationDisplayDuration];
                    
                    self.state = OTNotificationWindowStateShowing;
                }];
}

- (void)cubeOut
{
    if (self.state == OTNotificationWindowStateCubeRotatingOut)
    {
        return;
    }
    
    self.state = OTNotificationWindowStateCubeRotatingOut;
    UIImage *screenshot = [self getScreenshotForCubeRect];
    
    //set cube rotate view's background color to black
    _cubeRotateView.backgroundColor = [UIColor blackColor];
    
    //If on ipad, set rotating out content view's background image to screenshot
    //And hide cube's shadow
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        //set rotating out content view's background image to screenshot
        UIView *currentView = _cubeRotateView.currentView;
        if ([currentView isKindOfClass:[ComOpenthreadOTNotificationContentView class]])
        {
            ((ComOpenthreadOTNotificationContentView *)currentView).backgroundImage = screenshot;
            ((ComOpenthreadOTNotificationContentView *)currentView).backgroundImageHidden = NO;
        }
    }
    
    //Callback view rotate out event
    UIView *currentView = _cubeRotateView.currentView;
    UIView *oldNotifView = nil;
    if ([currentView isKindOfClass:[ComOpenthreadOTNotificationContentView class]])
    {
        oldNotifView = ((ComOpenthreadOTNotificationContentView *)currentView).notificationView;
    }
    if ([oldNotifView respondsToSelector:@selector(viewWillRotateOut)])
    {
        objc_msgSend(oldNotifView, @selector(viewWillRotateOut));
    }
    
    //Hide cube's shadow
    _cubeShadowView.alpha = 1;
    [UIView animateWithDuration:0.15f
                          delay:0.35f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _cubeShadowView.alpha = 0;
                     } completion:^(BOOL finished) {
                         _cubeShadowView.hidden = YES;
                         if ([oldNotifView respondsToSelector:@selector(viewDidRotateOut)])
                         {
                             objc_msgSend(oldNotifView, @selector(viewDidRotateOut));
                         }
                     }];
    
    if (!_screenshotView)
    {
        CGRect cubeRect = [self cubeRect];
        cubeRect.origin = CGPointZero;
        _screenshotView = [[ComOpenthreadOTNotificationUpdatingScreenshotView alloc] initWithFrame:cubeRect];
        _screenshotView.delegate = self;
    }
    
    [_cubeRotateView rotateToView:_screenshotView
                             from:OTCubeViewRotateSideFromUpSide
                animationDuration:0.5 completion:^{
                    [self setHiddenPrivate:YES];
                    _screenshotView.shouldUpdateScreenshot = NO;
                    _screenshotView = nil;
                    _cubeRotateView.currentView = nil;
                    self.state = OTNotificationWindowStateHidden;
                }];
    return;
}

- (UIImage *)screenshotImageToUpdate:(ComOpenthreadOTNotificationUpdatingScreenshotView *)view
{
    return [self getScreenshotForCubeRect];
}

- (void)cubeTouched
{
    if (self.state != OTNotificationWindowStateShowing &&
        self.state != OTNotificationWindowStateWaitingCubeRotatingOut)
    {
        return;
    }
    
    UIView *contentView = _cubeRotateView.currentView;
    if (![contentView isKindOfClass:[ComOpenthreadOTNotificationContentView class]])
    {
        return;
    }

    UIView *notificationView = ((ComOpenthreadOTNotificationContentView *)contentView).notificationView;
    if ([notificationView conformsToProtocol:@protocol(OTNotificationViewProtocol)])
    {
        UIView<OTNotificationViewProtocol> *touchedView = (UIView<OTNotificationViewProtocol> *)notificationView;
        
        //If view should hide on touch
        if ([touchedView respondsToSelector:@selector(otNotificationShouldHideOnTouch)] &&
            touchedView.otNotificationShouldHideOnTouch)
        {
            //If this is the last view in stack
            //Cancel `handleNotifications` and `cubeOut` perform
            //call `cubeOut` directly
            if (_notificationQueue.count <= 0)
            {
                [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                         selector:@selector(handleNotifications)
                                                           object:nil];
                [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                         selector:@selector(cubeOut)
                                                           object:nil];
                [self cubeOut];
            }
            //If this is not the last view in stack
            //Cancel `handleNotifications` perform
            //call `handleNotifications` directly
            else
            {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleNotifications) object:nil];
                [self handleNotifications];
            }
        }
        
        if ([touchedView respondsToSelector:@selector(otNotificationTouchBlock)] &&
            touchedView.otNotificationTouchBlock)
        {
            touchedView.otNotificationTouchBlock();
        }
        if ([touchedView respondsToSelector:@selector(otNotificationTouchTarget)] &&
            [touchedView respondsToSelector:@selector(otNotificationTouchSelector)] &&
            touchedView.otNotificationTouchTarget &&
            touchedView.otNotificationTouchSelector)
        {
            //If touch selector setted but not implemented, raise exception.
            objc_msgSend(touchedView.otNotificationTouchTarget,
                         touchedView.otNotificationTouchSelector,
                         touchedView);
        }
    }
}

- (CGRect)cubeRect
{
    CGRect cubeRect = [_cubeRotateView.superview convertRect:_cubeRotateView.frame toView:self];
    return cubeRect;
}

- (UIImage *)getScreenshotForCubeRect
{
    CGRect screenshotRect = [self cubeRect];
    UIImage *screenshot = [ComOpenthreadOTScreenshotHelper screenshotWithStatusBar:YES rect:screenshotRect];
    return screenshot;
}

#pragma mark - Super Methods

- (BOOL)isHidden
{
    return super.hidden;
}

- (BOOL)hidden
{
    return super.hidden;
}

- (void)setHidden:(BOOL)hidden
{
}

- (void)setHiddenPrivate:(BOOL)hidden
{
    [super setHidden:hidden];
}

- (void)show//Set hidden to NO
{
}

- (void)hide//Set hidden to YES
{
}

- (void)setWindowOrientation:(UIInterfaceOrientation)o
{
    [super setWindowOrientation:o];
}

- (void)setWindowOrientation:(UIInterfaceOrientation)o
                    animated:(BOOL)animated
{
    [super setWindowOrientation:o animated:animated];
}

- (void)setWindowOrientation:(UIInterfaceOrientation)o
                    animated:(BOOL)animated
           animationDuration:(NSTimeInterval)animationDuration
{
    [super setWindowOrientation:o animated:animated animationDuration:animationDuration];
}

#pragma mark - Singleton Method

+ (ComOpenthreadOTNotificationMessageWindow *)sharedInstance
{
    static ComOpenthreadOTNotificationMessageWindow *instance = nil;
    if (!instance)
    {
        instance = [[ComOpenthreadOTNotificationMessageWindow alloc] initWithFrame:CGRectZero];
    }
    return instance;
}

@end
