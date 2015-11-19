//
//  Player.m
//  LockScreenMedia
//
//  Created by njdby on 15/11/19.
//  Copyright © 2015年 njdby. All rights reserved.
//

#import "Player.h"

@implementation Player

+ (instancetype)sharedPlay {
    static Player *_sharedPlay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPlay = [[Player alloc] init];
    });
    
    return _sharedPlay;
}
@end
