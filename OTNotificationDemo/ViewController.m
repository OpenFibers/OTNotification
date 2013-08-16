//
//  ViewController.m
//  OTNotificationDemo
//
//  Created by openthread on 8/15/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import "ViewController.h"
#import "OTNotification.h"
#import <objc/message.h>

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController
{
    NSArray *_optionsArray;
    NSArray *_selectorArray;
    UITableView *_tableView;
    NSUInteger _notificationSeq;
}

#pragma mark - Code to create notification. 

- (void)simpleNotification
{
    OTNotificationManager *notificationManager = [OTNotificationManager defaultManager];
    OTNotificationMessage *notificationMessage = [[OTNotificationMessage alloc] init];
    notificationMessage.title = [self notificationTitle];
    notificationMessage.message = @"A notification. Touch me to hide me.";
    [notificationManager postNotificationMessage:notificationMessage];
}

- (void)notificationCannotTouch
{
    OTNotificationManager *notificationManager = [OTNotificationManager defaultManager];
    OTNotificationMessage *notificationMessage = [[OTNotificationMessage alloc] init];
    notificationMessage.title = [self notificationTitle];
    notificationMessage.message = @"A notification that can't touch to hide.";
    notificationMessage.otNotificationShouldHideOnTouch = NO;
    [notificationManager postNotificationMessage:notificationMessage];
}

- (void)notificationWithTouchBlock
{
    OTNotificationManager *notificationManager = [OTNotificationManager defaultManager];
    OTNotificationMessage *notificationMessage = [[OTNotificationMessage alloc] init];
    notificationMessage.title = [self notificationTitle];
    notificationMessage.message = @"Touch block notification. Touch and see log.";
    [notificationMessage setOtNotificationTouchBlock:^{
        NSLog(@"Notification with touch block touched!");
    }];
    [notificationManager postNotificationMessage:notificationMessage];
}

- (void)notificationWithTouchTargetAndSEL
{
    OTNotificationManager *notificationManager = [OTNotificationManager defaultManager];
    OTNotificationMessage *notificationMessage = [[OTNotificationMessage alloc] init];
    notificationMessage.title = [self notificationTitle];
    notificationMessage.message = @"Touch target notification. Touch and see log.";
    notificationMessage.otNotificationTouchTarget = self;
    notificationMessage.otNotificationTouchSelector = @selector(touched);
    [notificationManager postNotificationMessage:notificationMessage];
}

- (void)touched
{
    NSLog(@"Notification with touch target&SEL touched!");
}

- (void)notificationWithoutIcon
{
    OTNotificationManager *notificationManager = [OTNotificationManager defaultManager];
    OTNotificationMessage *notificationMessage = [[OTNotificationMessage alloc] init];
    notificationMessage.title = [self notificationTitle];
    notificationMessage.message = @"Notification without icon.";
    notificationMessage.showIcon = NO;
    [notificationManager postNotificationMessage:notificationMessage];
}

- (void)notificationWithCustomIcon
{
    OTNotificationManager *notificationManager = [OTNotificationManager defaultManager];
    OTNotificationMessage *notificationMessage = [[OTNotificationMessage alloc] init];
    notificationMessage.title = [self notificationTitle];
    notificationMessage.message = @"Notification with custom icon.";
    notificationMessage.iconImage = [UIImage imageNamed:@"CustomNotificationIcon.png"];
    [notificationManager postNotificationMessage:notificationMessage];
}

- (void)basicViewNotification
{
    OTNotificationManager *notificationManager = [OTNotificationManager defaultManager];
    OTBasicNotificationView *view = [[OTBasicNotificationView alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    label.text = @"Brazil color basic view notification.";
    label.backgroundColor = [UIColor yellowColor];
    label.textColor = [UIColor greenColor];
    [view addSubview:label];
    [notificationManager postNotificationView:view];
}

#pragma mark - Gen Notification Title

- (NSString *)notificationTitle
{
    return [NSString stringWithFormat:@"Notification%d", _notificationSeq++];
}

#pragma mark - UI

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _notificationSeq = 1;
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.title = @"OTNotification Demo";
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _optionsArray = @[@"Simple Notification",
                      @"Notification Cannot Touch",
                      @"Notification With Touch Block",
                      @"Notification With Target & SEL",
                      @"Notification Without Icon",
                      @"Notification With Custom Icon",
                      @"Basic View Notification"
                      ];
    _selectorArray = @[NSStringFromSelector(@selector(simpleNotification)),
                       NSStringFromSelector(@selector(notificationCannotTouch)),
                       NSStringFromSelector(@selector(notificationWithTouchBlock)),
                       NSStringFromSelector(@selector(notificationWithTouchTargetAndSEL)),
                       NSStringFromSelector(@selector(notificationWithoutIcon)),
                       NSStringFromSelector(@selector(notificationWithCustomIcon)),
                       NSStringFromSelector(@selector(basicViewNotification))
                       ];
    
    [self addObserver:self forKeyPath:@"view.frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"view.frame"])
    {
        _tableView.frame = self.view.bounds;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _optionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const reuseId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.textLabel.text = _optionsArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectorString = _selectorArray[indexPath.row];
    SEL selector = NSSelectorFromString(selectorString);
    objc_msgSend(self, selector);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Auto rotate methods.

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
