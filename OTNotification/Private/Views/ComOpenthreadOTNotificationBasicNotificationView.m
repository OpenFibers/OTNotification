//
//  OTMessageNotificationView.m
//  OTNotificationWindowDemo
//
//  Created by openthread on 8/14/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import "ComOpenthreadOTNotificationBasicNotificationView.h"

@implementation ComOpenthreadOTNotificationBasicNotificationView
{
    UIView *_upSideHalfBackgroundView;
    UIImageView *_backgroundImageView;
}

@synthesize otNotificationTouchBlock = _otNotificationTouchBlock;
@synthesize otNotificationTouchTarget = _otNotificationTouchTarget;
@synthesize otNotificationTouchSelector = _otNotificationTouchSelector;
@synthesize otNotificationShouldHideOnTouch = _otNotificationShouldHideOnTouch;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect bounds = self.bounds;
        
        //on iphone, when did rotate in, set _upSideHalfBackgroundView background color to black.
        //on iphone, when will rotate out, set _upSideHalfBackgroundView background color to clear.
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            bounds.size.height /= 2;
            _upSideHalfBackgroundView = [[UIView alloc] initWithFrame:bounds];
            _upSideHalfBackgroundView.backgroundColor = [UIColor blackColor];
            [self addSubview:_upSideHalfBackgroundView];
        }
        
        bounds = self.bounds;
        bounds.origin.y += 2;
        bounds.size.height -= 2;
        _backgroundImageView = [[UIImageView alloc] initWithFrame:bounds];
        
        UIImage *backgroundImage = [UIImage imageNamed:@"ComOpenthreadOTNotificationNotifBackground.png"];
        backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:8 topCapHeight:0];
        _backgroundImageView.image = backgroundImage;
        
        [self addSubview:_backgroundImageView];
        
        self.otNotificationShouldHideOnTouch = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect bounds = self.bounds;
    bounds.size.height /= 2;
    _upSideHalfBackgroundView.frame = bounds;
    
    bounds = self.bounds;
    bounds.origin.y += 2;
    bounds.size.height -= 2;
    _backgroundImageView.frame = bounds;
}

- (void)viewDidRotateIn
{
    //on iphone, when did rotate in, set _upSideHalfBackgroundView background color to black.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        _upSideHalfBackgroundView.backgroundColor = [UIColor blackColor];
    }
}

- (void)viewWillRotateOut
{  
    //on iphone, when will rotate out, set _upSideHalfBackgroundView background color to black.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        _upSideHalfBackgroundView.backgroundColor = [UIColor clearColor];
    }
}

//Handle will rotate in event if needed.
- (void)viewWillRotateIn
{
}

//Handle did rotate out event if needed.
- (void)viewDidRotateOut
{
}

@end
