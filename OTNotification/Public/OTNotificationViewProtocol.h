//
//  OTNotificationView.h
//  OTNotificationWindowDemo
//
//  Created by openthread on 8/14/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OTNotificationViewProtocol <NSObject>

@optional

//view state callback.
- (void)viewWillRotateIn;
- (void)viewDidRotateIn;
- (void)viewWillRotateOut;
- (void)viewDidRotateOut;

//touch block
@property (nonatomic, copy) void (^touchBlock) (void);

//touch target and selector
@property (nonatomic, assign) id touchTarget;
@property (nonatomic, assign) SEL touchSelector;

@end
