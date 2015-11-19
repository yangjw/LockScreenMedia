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
    NSString *string = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:string];
    
    
    //    audioPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    //    
    //    audioPlayer.allowsAirPlay = NO;
    //    
    //    [audioPlayer setShouldAutoplay:NO];
    //    [audioPlayer setControlStyle: MPMovieControlStyleEmbedded];
    //    audioPlayer.view.hidden = YES;
    //    audioPlayer.movieSourceType = MPMovieSourceTypeStreaming;
    //    [audioPlayer prepareToPlay];
    
    //初始化音频类 并且添加播放文件
//    avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//    //设置代理
//    avAudioPlayer.delegate = self;
//    
//    //设置初始音量大小
//    // avAudioPlayer.volume = 1;
//    
//    //设置音乐播放次数  -1为一直循环
//    avAudioPlayer.numberOfLoops = 1;
//    
//    //预播放
//    [avAudioPlayer prepareToPlay];
    
    [self setupAudioPlayer:@"music"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    audioY = [YAudioPlayer sharedPlay];
    
    [self initPlayer];
//    [self startUserActivity];
    
}

/*
 * Setup the AudioPlayer with
 * Filename and FileExtension like mp3
 * Loading audioFile and sets the time Labels
 */
- (void)setupAudioPlayer:(NSString*)fileName
{
    //insert Filename & FileExtension
    NSString *fileExtension = @"mp3";
    
    //init the Player to get file properties to set the time labels
    [audioY initPlayer:fileName fileExtension:fileExtension];
//    self.currentTimeSlider.maximumValue = [audioY getAudioDuration];
    
    //init the current timedisplay and the labels. if a current time was stored
    //for this player then take it and update the time display
//    self.timeElapsed.text = @"0:00";
    
//    self.duration.text = [NSString stringWithFormat:@"-%@",
//                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
    
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
        
        NSLog(@"***********%f",[audioY getAudioDuration] - [audioY getCurrentAudioTime]);
        float backDruation = [audioY getAudioDuration] - [audioY getCurrentAudioTime];
        //音乐剩余时长
        [songInfo setObject:[NSNumber numberWithDouble:backDruation] forKey:MPMediaItemPropertyPlaybackDuration];
        
        //音乐当前播放时间 在计时器中修改
        [songInfo setObject:[NSNumber numberWithDouble:[audioY getCurrentAudioTime]] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        
        
        //        设置锁屏状态下屏幕显示音乐信息
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
        
    }
    [self commandcenter];
}

- (IBAction)playButtonPress:(id)sender {
    
//    [audioPlayer play];
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(updateTime:)
                                                userInfo:nil
                                                 repeats:YES];
    
//    [self play];
    
    [audioY playAudio];

}

-(void)commandcenter
{
        MPRemoteCommandCenter *rcc = [MPRemoteCommandCenter sharedCommandCenter];
//    MPSkipIntervalCommand *skipBackwardIntervalCommand = [rcc skipBackwardCommand];
//    [skipBackwardIntervalCommand setEnabled:YES];
//    [skipBackwardIntervalCommand addTarget:self action:@selector(skipBackwardEvent:)];
//    skipBackwardIntervalCommand.preferredIntervals = @[@(42)];  // Set your own interval
//    
//    MPSkipIntervalCommand *skipForwardIntervalCommand = [rcc skipForwardCommand];
//    skipForwardIntervalCommand.preferredIntervals = @[@(42)];  // Max 99
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


//播放
- (void)play
{
    [avAudioPlayer play];
}
//暂停
- (void)pause
{
    [avAudioPlayer pause];
}
//停止
- (void)stop
{
    avAudioPlayer.currentTime = 0;  //当前播放时间设置为0
    [avAudioPlayer stop];
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


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
//    [self configNowPlayingInfoCenter];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });

}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
}

-(void)configNowPlayingInfoCenter{
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"name" forKey:MPMediaItemPropertyTitle];
        [dict setObject:@"singer" forKey:MPMediaItemPropertyArtist];
        [dict setObject:@"album" forKey:MPMediaItemPropertyAlbumTitle];
        
        UIImage *image = [UIImage imageNamed:@"test.jpg"];
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        
    }
    
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
//                [self pauseOrPlay];
                break;
            }
            case UIEventSubtypeRemoteControlPlay:
            {
                NSLog(@"UIEventSubtypeRemoteControlPlay...");
                [self action];
                break;
            }
            case UIEventSubtypeRemoteControlPause:
            {
                NSLog(@"UIEventSubtypeRemoteControlPause...");
                [self action];
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

-(void)action
{
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"" otherButtonTitles:@"收藏",@"上一曲", nil];
//    [sheet showInView:[UIApplication sharedApplication].keyWindow];
//    [[[UIAlertView alloc] initWithTitle:@"test" message:@"te" delegate:@"ete" cancelButtonTitle:@"e" otherButtonTitles:@"eggegege", nil] show];
}

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
