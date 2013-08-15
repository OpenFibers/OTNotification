//
//  OTNotificationSuperView.m
//  OTNotificationViewDemo
//
//  Created by openthread on 8/11/13.
//
//

#import "ComOpenthreadOTNotificationRotateWindow.h"

@implementation ComOpenthreadOTNotificationRotateWindow
{
    UIView *_contentView;
    UIInterfaceOrientation _currentOrientation;
}

@dynamic hidden;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];
        
        UIInterfaceOrientation o =[[UIApplication sharedApplication] statusBarOrientation];
        [self setWindowOrientation:o];
        
        self.shouldAutoRotateToInterfaceOrientation = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willRotateScreen:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification
                                                   object:nil];
        
        [self hide];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//Get content view reference
- (UIView *)contentView
{
    return _contentView;
}

//Adjust content view's frame

- (void)setFrame:(CGRect)frame
{
    [self setFrame:frame orientation:_currentOrientation];
}

- (void)setFrame:(CGRect)frame orientation:(UIInterfaceOrientation)o
{
    [super setFrame:frame];
    
    _currentOrientation = o;
    
    CGRect oldContentFrame = _contentView.frame;
    
    CGFloat windowWidth = (UIInterfaceOrientationIsPortrait(o) ?
                           CGRectGetWidth(frame) :
                           CGRectGetHeight(frame));
    CGFloat contentWidth = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 480 : windowWidth);
    _contentView.frame = CGRectMake((windowWidth - contentWidth) / 2, 0, contentWidth, 40);
    
    if (!CGRectEqualToRect(oldContentFrame, _contentView.frame) &&
        [self.contentViewFrameDelegate respondsToSelector:@selector(contentViewFrameChangedTo:)])
    {
        [self.contentViewFrameDelegate contentViewFrameChangedTo:_contentView.frame];
    }
}

//Show
- (void)show
{
    self.hidden = NO;
}

//Hide window
- (void)hide
{
    self.hidden = YES;
}

//Will rotate screen(auto rotate event)
- (void)willRotateScreen:(NSNotification *)notification
{
    if (!self.shouldAutoRotateToInterfaceOrientation)
    {
        return;
    }
    
    NSValue *rectValue = notification.userInfo[UIApplicationStatusBarFrameUserInfoKey];
    CGRect statusBarRect = rectValue.CGRectValue;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    UIInterfaceOrientation o = UIInterfaceOrientationPortrait;
    if (CGPointEqualToPoint(statusBarRect.origin, CGPointZero))
    {
        if (statusBarRect.size.width == screenWidth)
        {
            o = UIInterfaceOrientationPortrait;
        }
        else
        {
            o = UIInterfaceOrientationLandscapeLeft;
        }
    }
    else if (statusBarRect.origin.y == 0)
    {
        o = UIInterfaceOrientationLandscapeRight;
    }
    else
    {
        o = UIInterfaceOrientationPortraitUpsideDown;
    }
    
    if (self.hidden)
    {
        double delayInSeconds = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self setWindowOrientation:o];
        });
    }
    else
    {
        [self setWindowOrientation:o animated:YES];
    }
}

//Rotate methods
- (void)setWindowOrientation:(UIInterfaceOrientation)o
                    animated:(BOOL)animated
{
    NSTimeInterval duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [self setWindowOrientation:o animated:animated animationDuration:duration];
}

- (void)setWindowOrientation:(UIInterfaceOrientation)o
                    animated:(BOOL)animated
           animationDuration:(NSTimeInterval)animationDuration
{
    if (animated)
    {
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             [self setWindowOrientation:o];
                         }];
    }
    else
    {
        [self setWindowOrientation:o];
    }
}

- (void)setWindowOrientation:(UIInterfaceOrientation)o
{
    static CGFloat screenWidth = 0;
    screenWidth = [[UIScreen mainScreen] bounds].size.width;
    static CGFloat screenHeight = 0;
    screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    CGRect newFrame = CGRectMake(0, 0, screenWidth, screenHeight);
    CGAffineTransform t = CGAffineTransformIdentity;

    switch (o) {
        case UIInterfaceOrientationPortrait:
            t = CGAffineTransformIdentity;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            t = CGAffineTransformMakeRotation(M_PI);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            t = CGAffineTransformMakeRotation(- M_PI_2);
            break;
        case UIInterfaceOrientationLandscapeRight:
            t = CGAffineTransformMakeRotation(M_PI_2);
            break;
        default:
            break;
    }

    self.transform = t;
    [self setFrame:newFrame orientation:o];
}

//Make sure only content view can access user events
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isDescendantOfView:_contentView])
    {
        return view;
    }
    return nil;
}

+ (ComOpenthreadOTNotificationRotateWindow *)sharedInstance
{
    static ComOpenthreadOTNotificationRotateWindow *instance = nil;
    if (!instance)
    {
        instance = [[ComOpenthreadOTNotificationRotateWindow alloc] initWithFrame:CGRectZero];
    }
    return instance;
}

@end
