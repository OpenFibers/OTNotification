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
- (void)viewWillRotateIn;
- (void)viewDidRotateIn;
- (void)viewWillRotateOut;
- (void)viewDidRotateOut;

@end
