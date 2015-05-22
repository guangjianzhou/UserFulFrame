//
//  SDWebImageViewController.m
//  
//
//  Created by Mac-Pro on 15/5/22.
//
//

#import "SDWebImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageDetailViewController.h"


@interface SDWebImageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *urlArray;

@property (strong, nonatomic) NSIndexPath *selectIndex;

@end

@implementation SDWebImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    {
        self .urlArray = @[ @"http://c.hiphotos.baidu.com/image/w%3D2048/sign=396e9d640b23dd542173a068e531b2de/cc11728b4710b9123a8117fec1fdfc039245226a.jpg",
                            @"http://e.hiphotos.baidu.com/image/w%3D2048/sign=c9c32d60f1deb48ffb69a6dec4273b29/960a304e251f95cae5f125b7cb177f3e670952ae.jpg",
                            @"http://f.hiphotos.baidu.com/image/w%3D2048/sign=0e0fe1d417ce36d3a20484300ecb3b87/3801213fb80e7bec015d1eef2d2eb9389b506b3c.jpg",
                            @"http://a.hiphotos.baidu.com/image/w%3D2048/sign=6e8e7ce5b11c8701d6b6b5e613479f2f/b3fb43166d224f4a6059b1120bf790529922d1eb.jpg",
                            @"http://f.hiphotos.baidu.com/image/w%3D2048/sign=e0608e290cf41bd5da53eff465e280cb/aec379310a55b31976baeb7741a98226cffc1774.jpg",
                            @"http://g.hiphotos.baidu.com/image/w%3D2048/sign=4b5f112a0cf41bd5da53eff465e280cb/aec379310a55b319dd85747441a98226cffc17b6.jpg",
                            @"http://h.hiphotos.baidu.com/image/w%3D2048/sign=35229123708b4710ce2ffaccf7f6c2fd/c995d143ad4bd113fc73de3058afa40f4bfb0571.jpg",
                            @"http://b.hiphotos.baidu.com/image/w%3D2048/sign=ad8b74e88fb1cb133e693b13e96c574e/f9dcd100baa1cd11eba86d27bb12c8fcc3ce2d9e.jpg",
                            @"http://e.hiphotos.baidu.com/image/w%3D2048/sign=ac1303f0a5efce1bea2bcfca9b69f2de/838ba61ea8d3fd1f7dc8e23c324e251f94ca5ff6.jpg",
                            @"http://img.1985t.com/uploads/attaches/2014/07/17752-JiUfef.jpg",
                            @"http://g.hiphotos.baidu.com/image/pic/item/03087bf40ad162d9941feccc15dfa9ec8b13cd69.jpg",
                            @"http://d.hiphotos.baidu.com/image/pic/item/203fb80e7bec54e70d336dbaba389b504ec26ab2.jpg",
                            @"http://c.hiphotos.baidu.com/image/pic/item/10dfa9ec8a136327586f0778908fa0ec09fac7ff.jpg",
                            @"http://c.hiphotos.baidu.com/image/pic/item/6d81800a19d8bc3e7b7fd2d5808ba61ea8d345be.jpg",
                            @"http://b.hiphotos.baidu.com/image/pic/item/35a85edf8db1cb13a07aba3cde54564e92584b8a.jpg",
                            @"http://d.hiphotos.baidu.com/image/pic/item/00e93901213fb80e60ab352434d12f2eb83894ce.jpg",
                            @"http://c.hiphotos.baidu.com/image/pic/item/8644ebf81a4c510f3379b6e96259252dd52aa580.jpg",
                            ];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_urlArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSLog(@"cell = %p",cell);
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    NSURL *imageURL = [NSURL URLWithString:_urlArray[indexPath.row]];
//    [imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"chat_place_default.png"]];
//    return cell;
    //block
    [imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"chat_place_default.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"=====error = %@====",error);
        imageView.image = image;
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectIndex = indexPath;
    [self performSegueWithIdentifier:@"ImageDetailViewController" sender:nil];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ImageDetailViewController"])
    {
        ImageDetailViewController *detailVC = segue.destinationViewController;
        detailVC.url = _urlArray[_selectIndex.row];
        detailVC.urlArray = _urlArray;
    }
}

@end
