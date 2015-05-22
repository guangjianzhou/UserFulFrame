//
//  MBProgressHUDViewController.m
//  UsefulFrame
//
//  Created by Mac-Pro on 15/5/21.
//  Copyright (c) 2015年 shy. All rights reserved.
//

#import "MBProgressHUDViewController.h"
#import "MBProgressHUD.h"

@interface MBProgressHUDViewController ()
{
    MBProgressHUD *hud;
}
@end

@implementation MBProgressHUDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"正在加载";
    [self.view addSubview:hud];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showHub:(UIButton *)sender
{
    [hud show:YES];
}

- (IBAction)hideHub:(UIButton *)sender
{
    [hud hide:YES];
}

@end
