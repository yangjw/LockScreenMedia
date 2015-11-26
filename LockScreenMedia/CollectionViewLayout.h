//
//  CollectionViewLayout.h
//  LockScreenMedia
//
//  Created by njdby on 15/11/23.
//  Copyright © 2015年 njdby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewLayout : UICollectionViewLayout

@property (nonatomic, readonly) CGFloat horizontalInset;
@property (nonatomic, readonly) CGFloat verticalInset;

@property (nonatomic, readonly) CGFloat minimumItemWidth;
@property (nonatomic, readonly) CGFloat maximumItemWidth;
@property (nonatomic, readonly) CGFloat itemHeight;

@end
