//
//  ViewController.m
//  UsefulFrame
//
//  Created by Mac-Pro on 15/5/20.
//  Copyright (c) 2015年 shy. All rights reserved.
//

#import "ViewController.h"
#import "FrameCell.h"

#import "MBProgressHUDViewController.h"


#define kScreenWidth     [UIScreen mainScreen].bounds.size.width
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height

#define kCellIdentifier @"frameWorkCell"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray  *dataArray;

@end

@implementation ViewController

/**
 *  第三方框架
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    {
        //沙盒路径
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSLog(@"=====documents = %@===",documents);
    }
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)setup
{
    {
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    {
        _dataArray = [NSMutableArray array];
        [_dataArray addObjectsFromArray:@[@"MBProgressHUD",@"Reachability",@"AFNetworking",@"SDWebImage"]];
    }
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FrameCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:11];
    nameLabel.text = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *frameName = [_dataArray[indexPath.row] stringByAppendingString:@"ViewController"];
    [self performSegueWithIdentifier:frameName sender:nil];
    
    
//    UIViewController *vc = [[NSClassFromString([frameName stringByAppendingString:@"ViewController"]) alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Push
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void)loadAllSubViews:(UIView *)view
{
    NSLog(@"%@ %@ %@",@(view.tag), NSStringFromCGRect(view.frame), NSStringFromClass([view class]));
    
    if (view.subviews.count == 0)
    {
        return;
    }
    
    for (UIView *subView in view.subviews)
    {
        [self loadAllSubViews:subView];
    }
}


@end
