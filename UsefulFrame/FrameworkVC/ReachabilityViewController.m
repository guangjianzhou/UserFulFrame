//
//  ReachabilityViewController.m
//  UsefulFrame
//
//  Created by Mac-Pro on 15/5/21.
//  Copyright (c) 2015年 shy. All rights reserved.
//

#import "ReachabilityViewController.h"
#import "Reachability.h"


@interface ReachabilityViewController ()
{
    Reachability *reach;
}

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *notificationLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentLabel;


@end

@implementation ReachabilityViewController

/**
 *  block 监测、Notification监测
 *
 *   监视目标网络是否可用
     监视当前网络的连接方式
     监测连接方式的变更
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [self blockFocus];
    [self notificationFocus];
    [self currentNetType];
}


- (void)blockFocus
{
    __weak typeof(self)weakSelf = self;
    //检测网络变化
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.statusLabel.text = @"网络可用";
            weakSelf.statusLabel.backgroundColor = [UIColor greenColor];
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.statusLabel.text = @"网络不可用";
            weakSelf.statusLabel.backgroundColor = [UIColor redColor];
        });
    };
    [reach startNotifier];
}

- (void)notificationFocus
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [reach startNotifier];
}

- (void) reachabilityChanged: (NSNotification*)note {
    Reachability * reachs = [note object];
    [self currentNetType];
    if(![reachs isReachable])
    {
        self.notificationLabel.text = @"网络不可用";
        self.notificationLabel.backgroundColor = [UIColor redColor];
        return;
    }
    
    self.notificationLabel.text = @"网络可用";
    self.notificationLabel.backgroundColor = [UIColor greenColor];
}

- (void)currentNetType
{
    switch (reach.currentReachabilityStatus) {
        case NotReachable: {
            _currentLabel.text = @"无网络";
            break;
        }
        case ReachableViaWiFi: {
            _currentLabel.text = @"wifi连接";
            break;
        }
        case ReachableViaWWAN: {
            _currentLabel.text = @"2G/3G/4G连接";
            break;
        }
        default: {
            break;
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
