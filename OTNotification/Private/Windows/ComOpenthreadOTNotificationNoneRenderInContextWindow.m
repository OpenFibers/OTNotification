//
//  OTNotificationWindow.m
//  OTNotificationViewDemo
//
//  Created by openthread on 8/11/13.
//
//

#import "ComOpenthreadOTNotificationNoneRenderInContextWindow.h"
#import <QuartzCore/QuartzCore.h>

@interface ComOpenthreadOTNotificationNoneRenderLayer : CALayer
@end

@implementation ComOpenthreadOTNotificationNoneRenderLayer

//Make ComOpenthreadOTNotificationNoneRenderInContextView won't excute renderInContext:
- (void)renderInContext:(CGContextRef)ctx
{
    return;
}

@end

@implementation ComOpenthreadOTNotificationNoneRenderInContextWindow

//Make ComOpenthreadOTNotificationNoneRenderInContextView won't excute renderInContext:
+ (Class) layerClass
{
    return [ComOpenthreadOTNotificationNoneRenderLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

@end
