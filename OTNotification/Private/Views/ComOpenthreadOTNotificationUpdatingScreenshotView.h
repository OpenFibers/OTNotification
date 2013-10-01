//
//  ComOpenthreadOTNotificationUpdatingScreenshotView.h
//  OTNotificationDemo
//
//  Created by openthread on 10/2/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComOpenthreadOTNotificationUpdatingScreenshotView;

@protocol ComOpenthreadOTNotificationUpdatingScreenshotViewDelegate <NSObject>

- (UIImage *)screenshotImageToUpdate:(ComOpenthreadOTNotificationUpdatingScreenshotView *)view;

@end

@interface ComOpenthreadOTNotificationUpdatingScreenshotView : UIImageView

@property (nonatomic, assign) id<ComOpenthreadOTNotificationUpdatingScreenshotViewDelegate> delegate;
@property (nonatomic, assign) BOOL shouldUpdateScreenshot;

@end
