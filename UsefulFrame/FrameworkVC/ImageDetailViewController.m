



//
//  ImageDetailViewController.m
//  UsefulFrame
//
//  Created by Mac-Pro on 15/5/22.
//  Copyright (c) 2015年 shy. All rights reserved.
//

#import "ImageDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ImageDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation ImageDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:self.url] placeholderImage:[UIImage imageNamed:@"chat_place_default.png"]];
    
    _imageView.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *rightRecongnize = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
    rightRecongnize.direction = UISwipeGestureRecognizerDirectionRight;
    [_imageView addGestureRecognizer:rightRecongnize];

    UISwipeGestureRecognizer *leftRecongnize = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
    leftRecongnize.direction = UISwipeGestureRecognizerDirectionLeft;
    [_imageView addGestureRecognizer:leftRecongnize];
    
    _currentIndex = [_urlArray indexOfObject:_url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)changeImage:(UISwipeGestureRecognizer *)ges
{
    NSString *selectURLStr;
    if (ges.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (_currentIndex == 0)
        {
            selectURLStr = _urlArray[_urlArray.count-1];
            _currentIndex = _urlArray.count -1;
        }
        else
        {
            selectURLStr = _urlArray[_currentIndex -1];
            _currentIndex --;
        }
        
    }
    else if(ges.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (_currentIndex == (_urlArray.count-1))
        {
            selectURLStr = _urlArray[0];
            _currentIndex = 0;
        }
        else
        {
            selectURLStr = _urlArray[_currentIndex +1];
            _currentIndex ++;
        }
    }
    else
    {
        NSLog(@"上下====");
    }
    [_imageView sd_setImageWithURL:[NSURL URLWithString:selectURLStr]];
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
