//
//  VC2.m
//  LockScreenMedia
//
//  Created by njdby on 15/11/20.
//  Copyright © 2015年 njdby. All rights reserved.
//

#import "VC2.h"

@interface VC2 ()<NSUserActivityDelegate>

@end

@implementation VC2

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (void)userActivityWillSave:(NSUserActivity *)userActivity
{
    
}



- (void)restoreUserActivityState:(NSUserActivity *)activity
{
    
    
    
    [super restoreUserActivityState:activity];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
//
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.userActivity invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
