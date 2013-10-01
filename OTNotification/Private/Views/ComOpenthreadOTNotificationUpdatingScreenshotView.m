//
//  ComOpenthreadOTNotificationUpdatingScreenshotView.m
//  OTNotificationDemo
//
//  Created by openthread on 10/2/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import "ComOpenthreadOTNotificationUpdatingScreenshotView.h"

@interface ComOpenthreadOTNotificationUpdatingScreenshotView ()
@property (nonatomic, assign) BOOL isUpdating;
@property (nonatomic, assign) NSTimeInterval lastUpdateInterval;
@end

@implementation ComOpenthreadOTNotificationUpdatingScreenshotView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.shouldUpdateScreenshot = YES;
    }
    return self;
}

- (void)setShouldUpdateScreenshot:(BOOL)shouldUpdateScreenshot
{
    _shouldUpdateScreenshot = shouldUpdateScreenshot;
    if (_shouldUpdateScreenshot)
    {
        [self updateAsync];
    }
}

- (void)updateAsync
{
    if (!self.shouldUpdateScreenshot)
    {
        return;
    }
    
    NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
    
    if (!self.isUpdating && currentInterval - self.lastUpdateInterval > 1/30)
    {
        self.isUpdating = YES;
        self.lastUpdateInterval = currentInterval;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            UIImage *snapshot = [self.delegate screenshotImageToUpdate:self];
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                //set image
                self.image = snapshot;
                
                self.isUpdating = NO;
                
                //render next view
                [self performSelectorOnMainThread:@selector(updateAsync)
                                       withObject:nil
                                    waitUntilDone:NO
                                            modes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
            });
        });
    }
    else
    {
        //try again
        [self performSelectorOnMainThread:@selector(updateAsync)
                               withObject:nil
                            waitUntilDone:NO
                                    modes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
    }
}

- (void)dealloc
{
    self.shouldUpdateScreenshot = NO;
}

@end
