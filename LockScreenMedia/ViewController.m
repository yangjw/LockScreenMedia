//
//  ViewController.m
//  LockScreenMedia
//
//  Created by njdby on 15/11/18.
//  Copyright © 2015年 njdby. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "YAudioPlayer.h"
#import <CoreMedia/CoreMedia.h>


static NSString *ActivityTypeView = @"com.razeware.shopsnap.view";
static NSString *ActivityTypeEdit = @"com.razeware.shopsnap.edit";

static NSString *ActivityItemsKey = @"shopsnap.items.key";
static NSString * ActivityItemKey  = @"shopsnap.item.key";

@interface ViewController ()<AVAudioPlayerDelegate>
{
   AVAudioPlayer *avAudioPlayer;
    YAudioPlayer *audioY;
    NSTimer *timer;
}
@end

@implementation ViewController

@synthesize audioPlayer = audioPlayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    audioY = [YAudioPlayer sharedPlay];
    
    [self initPlayer];
#warning Handoff
    //    [self startUserActivity];
    
    
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    NSLog(@"---->%@---->%@",theCollation.sectionTitles,[[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                                                 [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]]);
    
}

- (void)initPlayer
{
    //    [[AVAudioSession sharedInstance] setDelegate: self];
    NSError *myErr;
    // Initialize the AVAudioSession here.
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&myErr]) {
        // Handle the error here.
        NSLog(@"Audio Session error %@, %@", myErr, [myErr userInfo]);
    }
    else{
        
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
//    NSString *string = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
    //把音频文件转换成url格式
//    NSURL *url = [NSURL fileURLWithPath:string];
    //    audioPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    //    audioPlayer.allowsAirPlay = NO;
    //    [audioPlayer setShouldAutoplay:NO];
    //    [audioPlayer setControlStyle: MPMovieControlStyleEmbedded];
    //    audioPlayer.view.hidden = YES;
    //    audioPlayer.movieSourceType = MPMovieSourceTypeStreaming;
    //    [audioPlayer prepareToPlay];
    [self setupAudioPlayer:@"music"];
}
/*
 * Setup the AudioPlayer with
 * Filename and FileExtension like mp3
 * Loading audioFile and sets the time Labels
 */
- (void)setupAudioPlayer:(NSString*)fileName
{
    NSString *fileExtension = @"mp3";
    [audioY initPlayer:fileName fileExtension:fileExtension];
}
-(void)startUserActivity
{
    NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:ActivityTypeView];
    activity.title = @"Viewing Shopping List";
    activity.userInfo = @{ActivityItemsKey:@[@"Ice cream",@"Apple",@"Nuts"]};
    self.userActivity = activity;
    [self.userActivity becomeCurrent];
}

- (void)updateUserActivityState:(NSUserActivity *)activity
{
    [activity addUserInfoEntriesFromDictionary:@{ActivityItemKey: @[@"Ice cream",@"Apple",@"Nuts"]}];
    
    [super updateUserActivityState:activity];
}




- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
     NSLog(@"----->%f",player.currentTime);
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag{
        NSLog(@"----->%f",player.currentTime);
    //播放结束时执行的动作
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error{
    //解码错误执行的动作
}
- (void)audioPlayerBeginInteruption:(AVAudioPlayer*)player{
    //处理中断的代码
}
- (void)audioPlayerEndInteruption:(AVAudioPlayer*)player{
    //处理中断结束的代码
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)updateTime:(NSTimer *)timer {
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    
    
//    
//    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
//    
//    if (playingInfoCenter) {
//        
//        
//        
//        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
////        
//        UIImage *image = [UIImage imageNamed:@"AlbumArt"];
//        
//        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:image];
//        
//        //歌曲名称  
//        [songInfo setObject:@"深夜地下铁" forKey:MPMediaItemPropertyTitle];
//        //演唱者
//        
//        [songInfo setObject:@"陶钰玉" forKey:MPMediaItemPropertyArtist];
//        //专辑名
//        
//        [songInfo setObject:@"Audio Album" forKey:MPMediaItemPropertyAlbumTitle];
//        //专辑缩略图
//        
//        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
//        
//       
//        float  currentTime = [audioY getCurrentAudioTime];
//        float audoDruation = [audioY getAudioDuration];
//        
//        double backDruation = audoDruation - currentTime;
////        NSLog(@"***********%f\n",backDruation);
//        //音乐当前播放时间 在计时器中修改
////        [songInfo setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
//        //音乐剩余时长
////        [songInfo setObject:[NSNumber numberWithDouble:backDruation] forKey:MPMediaItemPropertyPlaybackDuration];
//        
//    
//        
//        [songInfo setObject:[NSNumber numberWithDouble:[audioY getCurrentAudioTime]] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经播放时间
//        [songInfo setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];//进度光标的速度 （这个随 自己的播放速率调整，我默认是原速播放）
//        [songInfo setObject:[NSNumber numberWithDouble:[audioY getAudioDuration]] forKey:MPMediaItemPropertyPlaybackDuration];//歌曲总时间设置
//
//        
//        //        设置锁屏状态下屏幕显示音乐信息
//        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
//        NSLog(@"***%f##…%@--->%@\n",backDruation,[NSNumber numberWithDouble:backDruation],songInfo[MPMediaItemPropertyPlaybackDuration]);
//    }
   
}

- (IBAction)playButtonPress:(id)sender {
    
    [timer invalidate];
    [audioY playAudio];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(updateTime:)
                                                userInfo:nil
                                                 repeats:YES];
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        UIImage *image = [UIImage imageNamed:@"AlbumArt"];
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:image];
        //歌曲名称
        [songInfo setObject:@"深夜地下铁" forKey:MPMediaItemPropertyTitle];
        //演唱者
        [songInfo setObject:@"陶钰玉" forKey:MPMediaItemPropertyArtist];
        //专辑名
        [songInfo setObject:@"Audio Album" forKey:MPMediaItemPropertyAlbumTitle];
        //专辑缩略图
        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        [songInfo setObject:[NSNumber numberWithDouble:[audioY getCurrentAudioTime]] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经播放时间
        [songInfo setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];//进度光标的速度 （这个随 自己的播放速率调整，我默认是原速播放）
        [songInfo setObject:[NSNumber numberWithDouble:[audioY getAudioDuration]] forKey:MPMediaItemPropertyPlaybackDuration];//歌曲总时间设置
        
        //        设置锁屏状态下屏幕显示音乐信息
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    }
}

//暂停恢复播放更新 锁屏进度条
- (void)pasteAudio
{
    //当前播放时间
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
    [dict setObject:[NSNumber numberWithDouble:audioPlayer.playableDuration] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经过时间
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}
#pragma mark MPRemoteCommandCenter
-(void)commandcenter
{
        MPRemoteCommandCenter *rcc = [MPRemoteCommandCenter sharedCommandCenter];
//    MPSkipIntervalCommand *skipBackwardIntervalCommand = [rcc skipBackwardCommand];
//    [skipBackwardIntervalCommand setEnabled:YES];
//    [skipBackwardIntervalCommand addTarget:self action:@selector(skipBackwardEvent:)];
//    skipBackwardIntervalCommand.preferredIntervals = @[@(42)];  // 快进
//    
//    MPSkipIntervalCommand *skipForwardIntervalCommand = [rcc skipForwardCommand];
//    skipForwardIntervalCommand.preferredIntervals = @[@(42)];  // 倒退Max 99
//    [skipForwardIntervalCommand setEnabled:YES];
//    [skipForwardIntervalCommand addTarget:self action:@selector(skipForwardEvent:)];
    
    
    MPRemoteCommand *pauseCommand = [rcc pauseCommand];
    [pauseCommand setEnabled:YES];
    [pauseCommand addTarget:self action:@selector(playOrPauseEvent:)];
    //
    MPRemoteCommand *playCommand = [rcc playCommand];
    [playCommand setEnabled:YES];
    [playCommand addTarget:self action:@selector(playOrPauseEvent:)];
    
    
    MPRemoteCommand *nextCommand = [rcc nextTrackCommand];
    [nextCommand setEnabled:YES];
    [nextCommand addTarget:self action:@selector(nextCommandEvent:)];
    
    [self feedbackCommand:rcc];
//    [self reat:rcc];
}

- (void)playOrPauseEvent:(MPRemoteCommand *)command
{
    if (avAudioPlayer.isPlaying)
    {
        [avAudioPlayer pause];
    }else
    {
        [avAudioPlayer play];
    }
    NSLog(@"%@",command);
}

- (void)nextCommandEvent:(MPRemoteCommand *)command
{
   NSLog(@"%@",@"下一曲");
}

-(void)skipBackwardEvent: (MPSkipIntervalCommandEvent *)skipEvent
{
    NSLog(@"Skip backward by %f", skipEvent.interval);
}

-(void)skipForwardEvent: (MPSkipIntervalCommandEvent *)skipEvent
{
    NSLog(@"Skip forward by %f", skipEvent.interval);
}


-(void)feedbackCommand:(MPRemoteCommandCenter *)rcc
{
    MPFeedbackCommand *likeCommand = [rcc likeCommand];
    [likeCommand setEnabled:YES];
    [likeCommand setLocalizedTitle:@"I love it"];  // can leave this out for default
    [likeCommand addTarget:self action:@selector(likeEvent:)];
    
    MPFeedbackCommand *dislikeCommand = [rcc dislikeCommand];
    [dislikeCommand setEnabled:YES];
    [dislikeCommand setActive:YES];
    [dislikeCommand setLocalizedTitle:@"I hate it"]; // can leave this out for default
    [dislikeCommand addTarget:self action:@selector(dislikeEvent:)];
    
    BOOL userPreviouslyIndicatedThatTheyDislikedThisItemAndIStoredThat = YES;
    
    if (userPreviouslyIndicatedThatTheyDislikedThisItemAndIStoredThat) {
        [dislikeCommand setActive:YES];
    }
//    
//    MPFeedbackCommand *bookmarkCommand = [rcc bookmarkCommand];
//    [bookmarkCommand setEnabled:YES];
//    [bookmarkCommand addTarget:self action:@selector(bookmarkEvent:)];
    
    MPFeedbackCommand *bookmarkCommand = [rcc bookmarkCommand];
    [bookmarkCommand setEnabled:YES];
    [bookmarkCommand addTarget:self action:@selector(bookmarkEvent:)];
}

-(void)dislikeEvent: (MPFeedbackCommandEvent *)feedbackEvent
{
    NSLog(@"Mark the item disliked");
}

-(void)likeEvent: (MPFeedbackCommandEvent *)feedbackEvent
{
    NSLog(@"Mark the item liked");
}

-(void)bookmarkEvent: (MPFeedbackCommandEvent *)feedbackEvent
{
    NSLog(@"Bookmark the item or playback position");
}


-(void)reat:(MPRemoteCommandCenter *)rcc
{
        MPRatingCommand *ratingCommand = [rcc ratingCommand];
        [ratingCommand setEnabled:YES];
        [ratingCommand setMinimumRating:0.0];
        [ratingCommand setMaximumRating:5.0];
        [ratingCommand addTarget:self action:@selector(ratingEvent:)];
}
-(void)ratingEvent:(MPRatingCommand *)commd
{
    
}

-(void)playBackRate:(MPRemoteCommandCenter *)rcc
{
    MPChangePlaybackRateCommand *playBackRateCommand = [rcc changePlaybackRateCommand];
    [playBackRateCommand setEnabled:YES];
    [playBackRateCommand setSupportedPlaybackRates:@[@(1),@(1.5),@(2)]];
    [playBackRateCommand addTarget:self action:@selector(remoteControlReceivedWithEvent:)];
}


//计时器修改进度
- (void)changeProgress:(NSTimer *)sender{
    if(audioPlayer){
        //当前播放时间
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
        [dict setObject:[NSNumber numberWithDouble:audioPlayer.playableDuration] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经过时间
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        
    }
}

- (IBAction)stop:(id)sender {
    if ([audioPlayer isPreparedToPlay]) {
        [audioPlayer stop];
    }
}

- (void)setupNowPlayingInfoCenter:(MPMediaItem *)currentSong
{
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    CGFloat version = 4.0;
    if ([ver length] >= 3)
    {
        version = [[ver substringToIndex:3] floatValue];
    }
    
    if (version >= 5.0)
    {
        MPMediaItemArtwork *artwork = [currentSong valueForProperty:MPMediaItemPropertyArtwork];
        
        MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
        
        if (currentSong == nil)
        {
            infoCenter.nowPlayingInfo = nil;
            return;
        }
        
        infoCenter.nowPlayingInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [currentSong valueForKey:MPMediaItemPropertyTitle], MPMediaItemPropertyTitle,
                                     [currentSong valueForKey:MPMediaItemPropertyArtist], MPMediaItemPropertyArtist,
                                     [currentSong valueForKey:MPMediaItemPropertyAlbumTitle], MPMediaItemPropertyAlbumTitle,
                                     [currentSong valueForKey:MPMediaItemPropertyAlbumTrackCount], MPMediaItemPropertyAlbumTrackCount,
                                     [currentSong valueForKey:MPMediaItemPropertyAlbumTrackNumber], MPMediaItemPropertyAlbumTrackNumber,
                                     artwork, MPMediaItemPropertyArtwork,
                                     [currentSong valueForKey:MPMediaItemPropertyComposer], MPMediaItemPropertyComposer,
                                     [currentSong valueForKey:MPMediaItemPropertyDiscCount], MPMediaItemPropertyDiscCount,
                                     [currentSong valueForKey:MPMediaItemPropertyDiscNumber], MPMediaItemPropertyDiscNumber,
                                     [currentSong valueForKey:MPMediaItemPropertyGenre], MPMediaItemPropertyGenre,
                                     [currentSong valueForKey:MPMediaItemPropertyPersistentID], MPMediaItemPropertyPersistentID,
                                     [currentSong valueForKey:MPMediaItemPropertyPlaybackDuration], MPMediaItemPropertyPlaybackDuration,
                                     //                                     [NSNumber numberWithInt:self.mediaCollection.nowPlayingIndex + 1], MPNowPlayingInfoPropertyPlaybackQueueIndex,
                                     //                                     [NSNumber numberWithInt:[self.mediaCollection count]], MPNowPlayingInfoPropertyPlaybackQueueCount,
                                     nil];
    }
}
#pragma mark end

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });

}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
            {
                NSLog(@"UIEventSubtypeRemoteControlTogglePlayPause...");
                break;
            }
            case UIEventSubtypeRemoteControlPlay:
            {
                NSLog(@"UIEventSubtypeRemoteControlPlay...");

                break;
            }
            case UIEventSubtypeRemoteControlPause:
            {
                NSLog(@"UIEventSubtypeRemoteControlPause...");

                break;
            }
            case UIEventSubtypeRemoteControlStop:
            {
                NSLog(@"UIEventSubtypeRemoteControlStop...");
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack:
            {
                NSLog(@"UIEventSubtypeRemoteControlNextTrack...");
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack:
            {
                NSLog(@"UIEventSubtypeRemoteControlPreviousTrack...");
                break;
            }
                
            default:
                break;
        }
    }
    
}

#pragma mark data protect
//data protect
-(void)saveDataProtect
{
    NSString *infoString = @"来设定文件系统中的文件 设置权限";
    
    NSString *documentsPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"DataProtect"];
    [infoString writeToFile:filePath
                 atomically:YES
                   encoding:NSUTF8StringEncoding
                      error:nil];
    /*
     //文件保护等级属性列表
    NSFileProtectionNone                                    //文件未受保护，随时可以访问 （Default）
    NSFileProtectionComplete                                //文件受到保护，而且只有在设备未被锁定时才可访问
    NSFileProtectionCompleteUntilFirstUserAuthentication    //文件收到保护，直到设备启动且用户第一次输入密码
    NSFileProtectionCompleteUnlessOpen                      //文件受到保护，而且只有在设备未被锁定时才可打开，不过即便在设备被锁定时，已经打开的文件还是可以继续使用和写入
     
     设置keychain项保护等级
    NSDictionary *query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrGeneric:@"MyItem",
                            (__bridge id)kSecAttrAccount:@"username",
                            (__bridge id)kSecValueData:@"password",
                            (__bridge id)kSecAttrService:[NSBundle mainBundle].bundleIdentifier,
                            (__bridge id)kSecAttrLabel:@"",
                            (__bridge id)kSecAttrDescription:@"",
                            (__bridge id)kSecAttrAccessible:(__bridge id)kSecAttrAccessibleWhenUnlocked};
    
    OSStatus result = SecItemAdd((__bridge CFDictionaryRef)(query), NULL);
     //keychain项保护等级列表
     kSecAttrAccessibleWhenUnlocked                          //keychain项受到保护，只有在设备未被锁定时才可以访问
     kSecAttrAccessibleAfterFirstUnlock                      //keychain项受到保护，直到设备启动并且用户第一次输入密码
     kSecAttrAccessibleAlways                                //keychain未受保护，任何时候都可以访问 （Default）
     kSecAttrAccessibleWhenUnlockedThisDeviceOnly            //keychain项受到保护，只有在设备未被锁定时才可以访问，而且不可以转移到其他设备
     kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly        //keychain项受到保护，直到设备启动并且用户第一次输入密码，而且不可以转移到其他设备
     kSecAttrAccessibleAlwaysThisDeviceOnly                  //keychain未受保护，任何时候都可以访问，但是不能转移到其他设备
    */
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                           forKey:NSFileProtectionKey];
    [[NSFileManager defaultManager] setAttributes:attributes
                                     ofItemAtPath:filePath
                                            error:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
