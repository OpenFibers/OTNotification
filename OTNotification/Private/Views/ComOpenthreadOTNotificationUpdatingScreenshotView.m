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
    if (!self.isUpdating)
    {
        self.isUpdating = YES;
        UIImage *snapshot = [self.delegate screenshotImageToUpdate:self];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
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
