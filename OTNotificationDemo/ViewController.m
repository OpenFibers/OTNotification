//
//  ViewController.m
//  OTNotificationDemo
//
//  Created by openthread on 8/15/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import "ViewController.h"
#import "OTNotificationManager.h"

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
    OTNotificationManager *notificationManager = [OTNotificationManager defaultManager];
    OTNotificationMessage *notificationMessage = [[OTNotificationMessage alloc] init];
    notificationMessage.title = @"Notification";
    notificationMessage.message = @"Very very very very very very very very very very very very very long notification";
    [notificationManager postNotificationMessage:notificationMessage];
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
