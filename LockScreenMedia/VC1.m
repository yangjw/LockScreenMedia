//
//  VC1.m
//  LockScreenMedia
//
//  Created by njdby on 15/11/20.
//  Copyright © 2015年 njdby. All rights reserved.
//

#import "VC1.h"

@interface VC1 ()<NSUserActivityDelegate>

@end

@implementation VC1

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self creatHandOffUserActivity];
}

- (void)creatHandOffUserActivity
{
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 8) {
        if (self.userActivity !=nil) {
            self.userActivity = nil;
        }
        self.userActivity = [[NSUserActivity alloc] initWithActivityType:@"com.handoffdemo.dosomething"];
        self.userActivity.title = @"oneVC";
        self.userActivity.delegate = self;
        self.userActivity.userInfo = @{@"jumpId":@"1",@"info":@"由VC1跳转到第二个VC2"};
        self.userActivity.needsSave = YES;
        self.userActivity.webpageURL = [NSURL URLWithString:@"http://www.baidu.com"];
        [self.userActivity becomeCurrent];
    }
}

- (void)userActivityWillSave:(NSUserActivity *)userActivity
{
    
}

-(void)userActivityWasContinued:(NSUserActivity *)userActivity
{
    NSLog(@"这个软件已经在另一台设备上打开");
}

-(void)restoreUserActivityState:(NSUserActivity *)activity
{
    NSString *jumpto = [[activity userInfo] objectForKey:@"jumpId"];
    if ([jumpto isEqualToString:@"0"]) {
        NSString *info = [[activity userInfo] objectForKey:@"info"];
        NSLog(@"---->%@",info);
    }
    [super restoreUserActivityState:activity];
}


- (void)updateUserActivityState:(NSUserActivity *)activity
{
    if ([activity.activityType isEqualToString:@"com.handoffdemo.dosomething"]) {
        
        [activity addUserInfoEntriesFromDictionary:@{@"jumpId":@"1",@"info":@"由VC1跳转到第二个VC2更新信息"}];
        
    }
    
    [super updateUserActivityState:activity];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
//废弃  userActivity
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
