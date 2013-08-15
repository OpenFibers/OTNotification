//
//  OTNotificationContentView.m
//  OTNotificationViewDemo
//
//  Created by openthread on 8/13/13.
//
//

#import "ComOpenthreadOTNotificationContentView.h"

@implementation ComOpenthreadOTNotificationContentView
{
    UIImageView *_backgroundImageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //iphone doesn't need background image in notification content view.
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
            [self addSubview:_backgroundImageView];
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _backgroundImageView.frame = self.bounds;
    _notificationView.frame = self.bounds;
}

- (BOOL)backgroundImageHidden
{
    return _backgroundImageView.hidden;
}

- (void)setBackgroundImageHidden:(BOOL)backgroundImageHidden
{
    _backgroundImageView.hidden = backgroundImageHidden;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{    
    _backgroundImageView.image = backgroundImage;
}

- (void)setNotificationView:(UIView *)notificationView
{
    _notificationView = notificationView;
    notificationView.frame = self.bounds;
    [self addSubview:_notificationView];
}

@end
