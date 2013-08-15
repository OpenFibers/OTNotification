//
//  ViewController.m
//  OTNotificationDemo
//
//  Created by openthread on 8/15/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import "ViewController.h"
#import "ComOpenthreadOTNotificationMessageWindow.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(140, 240, 40, 40);
    [button addTarget:self action:@selector(buttonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonTouched
{
    ComOpenthreadOTNotificationMessageWindow *notifWindow = [ComOpenthreadOTNotificationMessageWindow sharedInstance];
    OTNotificationMessage *notificationMessage = [[OTNotificationMessage alloc] init];
    notificationMessage.title = @"Notification";
    notificationMessage.message = @"Very very very very very very very very very very very very very long notification";
    [notifWindow postNotificationMessage:notificationMessage];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
