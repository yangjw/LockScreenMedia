//
//  YAudioPlayer.m
//  LockScreenMedia
//
//  Created by njdby on 15/11/19.
//  Copyright © 2015年 njdby. All rights reserved.
//

#import "YAudioPlayer.h"

@implementation YAudioPlayer

+ (instancetype)sharedPlay {
    static YAudioPlayer *_sharedPlay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPlay = [[YAudioPlayer alloc] init];
    });
    
    return _sharedPlay;
}



/*
 * Init the Player with Filename and FileExtension
 */
- (void)initPlayer:(NSString*) audioFile fileExtension:(NSString*)fileExtension
{
//    NSURL *audioFileLocationURL = [[NSBundle mainBundle] URLForResource:audioFile withExtension:fileExtension];
    NSError *error;
    
    NSString *string = [[NSBundle mainBundle] pathForResource:audioFile ofType:fileExtension];
    //把音频文件转换成url格式
    NSURL *audioFileLocationURL = [NSURL fileURLWithPath:string];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocationURL error:&error];
    self.audioPlayer.volume = 1;
    self.audioPlayer.numberOfLoops = 0;
    [self.audioPlayer prepareToPlay];
    
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
}

/*
 * Simply fire the play Event
 */
- (void)playAudio {
    [self.audioPlayer play];
}

/*
 * Simply fire the pause Event
 */
- (void)pauseAudio {
    [self.audioPlayer pause];
}

/*
 * get playingState
 */
- (BOOL)isPlaying {
    return [self.audioPlayer isPlaying];
}

/*
 * Format the float time values like duration
 * to format with minutes and seconds
 */
-(NSString*)timeFormat:(float)value{
    
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
    
    int roundedSeconds = lroundf(seconds);
    int roundedMinutes = lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%d:%02d",
                      roundedMinutes, roundedSeconds];
    return time;
}

/*
 * To set the current Position of the
 * playing audio File
 */
- (void)setCurrentAudioTime:(float)value {
    [self.audioPlayer setCurrentTime:value];
}

/*
 * Get the time where audio is playing right now
 */
- (NSTimeInterval)getCurrentAudioTime {
    return [self.audioPlayer currentTime];
}

/*
 * Get the whole length of the audio file
 */
- (float)getAudioDuration {
    return [self.audioPlayer duration];
}

- (NSString *)convertTimeFromSeconds:(NSString *)seconds {
    
    // Return variable.
    NSString *result = @"";
    
    // Int variables for calculation.
    int secs = [seconds intValue];
    int tempHour    = 0;
    int tempMinute  = 0;
    int tempSecond  = 0;
    
    NSString *hour      = @"";
    NSString *minute    = @"";
    NSString *second    = @"";
    
    // Convert the seconds to hours, minutes and seconds.
    tempHour    = secs / 3600;
    tempMinute  = secs / 60 - tempHour * 60;
    tempSecond  = secs - (tempHour * 3600 + tempMinute * 60);
    
    hour    = [[NSNumber numberWithInt:tempHour] stringValue];
    minute  = [[NSNumber numberWithInt:tempMinute] stringValue];
    second  = [[NSNumber numberWithInt:tempSecond] stringValue];
    
    // Make time look like 00:00:00 and not 0:0:0
    if (tempHour < 10) {
        hour = [@"0" stringByAppendingString:hour];
    }
    
    if (tempMinute < 10) {
        minute = [@"0" stringByAppendingString:minute];
    }
    
    if (tempSecond < 10) {
        second = [@"0" stringByAppendingString:second];
    }
    
    if (tempHour == 0) {
        
        NSLog(@"Result of Time Conversion: %@:%@", minute, second);
        result = [NSString stringWithFormat:@"%@:%@", minute, second];
        
    } else {
        
        NSLog(@"Result of Time Conversion: %@:%@:%@", hour, minute, second);
        result = [NSString stringWithFormat:@"%@:%@:%@",hour, minute, second];
        
    }
    
    return result;
    
}


@end
