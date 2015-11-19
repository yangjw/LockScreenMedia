//
//  ViewController.h
//  LockScreenMedia
//
//  Created by njdby on 15/11/18.
//  Copyright © 2015年 njdby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMoviePlayerController.h>
@interface ViewController : UIViewController
{
    MPMoviePlayerController *audioPlayer;
}
@property (nonatomic, retain) MPMoviePlayerController *audioPlayer;
@end



