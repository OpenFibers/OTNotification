//
//  OTMessageNotificationView.m
//  OTNotificationWindowDemo
//
//  Created by openthread on 8/14/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import "ComOpenthreadOTNotificationMessageNotificationView.h"
#import "OTNotificationMessage.h"

@implementation ComOpenthreadOTNotificationMessageNotificationView
{
    UIImageView *_iconFrameView;
    UIImageView *_iconView;
    UIView *_splitterView;
    UILabel *_titleLabel;
    UILabel *_messageLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showIcon = YES;
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 18, 18)];
        _iconView.backgroundColor = [UIColor whiteColor];
        _iconView.image = [UIImage imageNamed:@"Icon.png"];
        [self addSubview:_iconView];
        
        UIImage *iconFrameImage = [UIImage imageNamed:@"ComOpenthreadOTNotificationNotifIconFrame.png"];
        _iconFrameView = [[UIImageView alloc] initWithImage:iconFrameImage];
        _iconFrameView.frame = (CGRect){CGPointMake(-1, -1), CGSizeMake(20, 20)};
        [_iconView addSubview:_iconFrameView];
        
        _splitterView = [[UIView alloc] initWithFrame:CGRectMake(31, 3, 1, 36)];
        _splitterView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
        [self addSubview:_splitterView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 4, 300, 18)];
        _titleLabel.textColor = [UIColor colorWithWhite:51/255.0f alpha:1.0f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:_titleLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 21, 300, 15)];
        _messageLabel.textColor = [UIColor colorWithWhite:51/255.0f alpha:1.0f];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.numberOfLines = 1;
        _messageLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_messageLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGFloat textOriginX = (self.showIcon ? 38 : 7);
    CGFloat textWidth = CGRectGetWidth(self.frame) - textOriginX - 7;
    _titleLabel.frame = CGRectMake(textOriginX, 4, textWidth, 18);
    _messageLabel.frame = CGRectMake(textOriginX, 21, textWidth, 15);
}

- (void)setShowIcon:(BOOL)showIcon
{
    _showIcon = showIcon;
    
    _iconView.hidden = !showIcon;
    _splitterView.hidden = !showIcon;
    
    [self setFrame:self.frame];
}

- (void)setIconImage:(UIImage *)iconImage
{
    if (!iconImage)
    {
        return;
    }
    _iconView.image = iconImage;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    _messageLabel.text = message;
}

- (void)setNotificationMessage:(OTNotificationMessage *)notificationMessage
{
    _notificationMessage = notificationMessage;
    self.title = notificationMessage.title;
    self.message = notificationMessage.message;
    self.showIcon = notificationMessage.showIcon;
    self.iconImage = notificationMessage.iconImage;
    self.otNotificationTouchBlock = notificationMessage.otNotificationTouchBlock;
    self.otNotificationTouchTarget = notificationMessage.otNotificationTouchTarget;
    self.otNotificationTouchSelector = notificationMessage.otNotificationTouchSelector;
    self.otNotificationShouldHideOnTouch = notificationMessage.otNotificationShouldHideOnTouch;
}

@end
