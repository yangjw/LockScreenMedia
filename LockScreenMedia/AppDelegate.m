//
//  AppDelegate.m
//  LockScreenMedia
//
//  Created by njdby on 15/11/18.
//  Copyright © 2015年 njdby. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    [session setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    NSError *activationError = nil;
    [session setActive:YES error:&activationError];    
    
//   设置获取时间
//    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
//   ios 8.0 消息处理机制
    UIMutableUserNotificationAction *notificationAction1 = [[UIMutableUserNotificationAction alloc] init];
    notificationAction1.identifier = @"Accept";
    notificationAction1.title = @"Accept";
    notificationAction1.activationMode = UIUserNotificationActivationModeBackground;
    notificationAction1.destructive = NO;
    notificationAction1.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *notificationAction2 = [[UIMutableUserNotificationAction alloc] init];
    notificationAction2.identifier = @"Reject";
    notificationAction2.title = @"Reject";
    notificationAction2.activationMode = UIUserNotificationActivationModeBackground;
    notificationAction2.destructive = YES;
    notificationAction2.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *notificationAction3 = [[UIMutableUserNotificationAction alloc] init];
    notificationAction3.identifier = @"Reply";
    notificationAction3.title = @"Reply";
    notificationAction3.activationMode = UIUserNotificationActivationModeForeground;
    notificationAction3.destructive = NO;
    notificationAction3.authenticationRequired = YES;
    
    UIMutableUserNotificationCategory *notificationCategory = [[UIMutableUserNotificationCategory alloc] init];
    notificationCategory.identifier = @"Email";
    [notificationCategory setActions:@[notificationAction1,notificationAction2,notificationAction3] forContext:UIUserNotificationActionContextDefault];
    [notificationCategory setActions:@[notificationAction1,notificationAction2] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:notificationCategory, nil];
    
    UIUserNotificationType notificationType = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    
//    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
//    localNotification.alertBody = @"Testing";
//    localNotification.category = @"Email"; //  Same as category identifier
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    return YES;
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    NSLog(@"--->%@",notification.alertBody);
    completionHandler(UIBackgroundFetchResultNewData);
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    程序进入后台显示图片
    //    [self.window addSubview:splashView];
//    [self.window bringSubviewToFront:splashView];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//     [self.splashView removeFromSuperview];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//background fetch

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"后台获取");
    
    
//    UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;
//    
//    id fetchViewController = navigationController.topViewController;
//    if ([fetchViewController respondsToSelector:@selector(fetchDataResult:)]) {
//        [fetchViewController fetchDataResult:^(NSError *error, NSArray *results){
//            if (!error) {
//                if (results.count != 0) {
//                    //Update UI with results.
//                    //Tell system all done.
//                    completionHandler(UIBackgroundFetchResultNewData);
//                } else {
//                    completionHandler(UIBackgroundFetchResultNoData);
//                }
//            } else {
//                completionHandler(UIBackgroundFetchResultFailed);
//            }
//        }];
//    } else {
//        completionHandler(UIBackgroundFetchResultFailed);
//    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
                       // Check result of your operation and call completion block with the result
                       completionHandler(UIBackgroundFetchResultNewData);
                   });
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
}

//Handoff
- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType
{
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
//    [self restoreUserActivityState:userActivity];
    
    NSDictionary *userInfo = userActivity.userInfo;
    if (userInfo && [userInfo isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"---->%@",userInfo);
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity
{
    [userActivity addUserInfoEntriesFromDictionary:@{@"Version":@"1.0"}];
}
- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error
{
    if (error.code != NSUserCancelledError)
    {
        [[[UIAlertView alloc] initWithTitle:@"Handoff error" message:@"The connection to your other device may have been interrupted. Please try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
    }
}

static NSString *remoteControlPlayButtonTapped = @"play pressed";
static NSString *remoteControlPauseButtonTapped = @"pause pressed";
static NSString *remoteControlStopButtonTapped = @"stop pressed";
static NSString *remoteControlForwardButtonTapped = @"forward pressed";
static NSString *remoteControlBackwardButtonTapped = @"backward pressed";
static NSString *remoteControlOtherButtonTapped = @"other pressed";

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            NSLog(@"播放");
            break;
        case UIEventSubtypeRemoteControlPause:
//            [self action];
            NSLog(@"暂停");
            break;
        case UIEventSubtypeRemoteControlStop:
            NSLog(@"停止");
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            NSLog(@"下一曲");
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            NSLog(@"上一曲");
            break;
        case UIEventSubtypeRemoteControlTogglePlayPause:
            
        default:
            
            break;
    }
}
-(void)action
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"" otherButtonTitles:@"收藏",@"上一曲", nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)postNotificationWithName:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}


@end
