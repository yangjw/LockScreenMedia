//
//  YAudioPlayer.h
//  LockScreenMedia
//
//  Created by njdby on 15/11/19.
//  Copyright © 2015年 njdby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface YAudioPlayer : NSObject
+ (instancetype)sharedPlay;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

// Public methods
- (void)initPlayer:(NSString*) audioFile fileExtension:(NSString*)fileExtension;
- (void)playAudio;
- (void)pauseAudio;
- (BOOL)isPlaying;
- (void)setCurrentAudioTime:(float)value;
- (float)getAudioDuration;
- (NSString*)timeFormat:(float)value;
- (NSTimeInterval)getCurrentAudioTime;
@end
