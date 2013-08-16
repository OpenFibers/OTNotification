//
//  CustomNotificationView.m
//  OTNotificationDemo
//
//  Created by openthread on 8/16/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import "CustomNotificationView.h"

@implementation CustomNotificationView
{
    UILabel *_customLabel;
}

//Implement property if needed.
@synthesize otNotificationTouchBlock = _otNotificationTouchBlock;
@synthesize otNotificationTouchTarget = _otNotificationTouchTarget;
@synthesize otNotificationTouchSelector = _otNotificationTouchSelector;
@synthesize otNotificationShouldHideOnTouch = _otNotificationShouldHideOnTouch;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _customLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _customLabel.font = [UIFont systemFontOfSize:14.0f];
        _customLabel.text = @"This is a CustomNotificationView\nTouch me to see log";
        _customLabel.numberOfLines = 0;
        [self addSubview:_customLabel];
        
        self.backgroundColor = [UIColor blackColor];
        self.otNotificationShouldHideOnTouch = YES;
        
        self.otNotificationTouchBlock = ^{
            NSLog(@"CustomNotificationView touched");
        };
    }
    return self;
}

//Re-layout subviews here.
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _customLabel.frame = CGRectMake(10, 2, CGRectGetWidth(self.bounds) - 20, 38);
}

//Or re-layout subviews here.
- (void)layoutSubviews
{
    [super layoutSubviews];
}

//Handle did rotate in event if needed.
- (void)viewDidRotateIn
{
    NSLog(@"Handle did rotate in event if needed.");
}

//Handle will rotate out event if needed.
- (void)viewWillRotateOut
{
    NSLog(@"Handle will rotate out event if needed.");
}

//Handle will rotate in event if needed.
- (void)viewWillRotateIn
{
    NSLog(@"Handle will rotate in event if needed.");
}

//Handle did rotate out event if needed.
- (void)viewDidRotateOut
{
    NSLog(@"Handle did rotate out event if needed.");
}

@end
