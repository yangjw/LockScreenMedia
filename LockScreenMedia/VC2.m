//
//  VC2.m
//  LockScreenMedia
//
//  Created by njdby on 15/11/20.
//  Copyright © 2015年 njdby. All rights reserved.
//

#import "VC2.h"

@interface VC2 ()<NSUserActivityDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation VC2

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self creatHandOffUserActivity];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}


- (void)creatHandOffUserActivity
{
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 8) {
        if (self.userActivity !=nil) {
            self.userActivity = nil;
        }
        self.userActivity = [[NSUserActivity alloc] initWithActivityType:@"com.sse.ustc.handoffdemo.dosomething"];
        self.userActivity.title = @"twoVC";
        self.userActivity.delegate = self;
        self.userActivity.userInfo = @{@"jumpId":@"0",@"info":@"跳转到第1个VC"};
/*
    needsSave这个属性如果设置成YES，那么这个活动的代理(这里是当前的VC)就触发一个方法userActivityWillSave:，触发时机是这个活动被发送之前,用这个来做最后的改动。
 */
        self.userActivity.needsSave = YES;
        self.userActivity.webpageURL = [NSURL URLWithString:@"http://www.baidu.com"];
/*
    becomeCurrent使得当前这个活动被“发射”出去，被其他的设备接收到，那么就会在锁屏的左下角就会出现一个app 的icon，这个becomeCurrent的时机还是很重要的，如果这个useractivity需要很重要的信息保存在字典里，如果就在viewdidload中调用的话不是很保险，通常我在viewwillappear里边去调用。
 */
        
        [self.userActivity becomeCurrent];
    }
}
#pragma mark - UICollectionViewFlowLayout

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat picDimension = self.view.frame.size.width / 4.0f;
//    return CGSizeMake(picDimension, picDimension);
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    CGFloat leftRightInset = self.view.frame.size.width / 14.0f;
//    return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset);
//}


- (void)userActivityWillSave:(NSUserActivity *)userActivity
{
    
}



- (void)restoreUserActivityState:(NSUserActivity *)activity
{
    
    NSString *jumpto = [[activity userInfo] objectForKey:@"jumpId"];
    if ([jumpto isEqualToString:@"0"]) {
        NSString *info = [[activity userInfo] objectForKey:@"info"];
        NSLog(@"---->%@",info);
    }
    [super restoreUserActivityState:activity];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
