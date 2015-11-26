//
//  CollectionViewLayout.m
//  LockScreenMedia
//
//  Created by njdby on 15/11/23.
//  Copyright © 2015年 njdby. All rights reserved.
//

#import "CollectionViewLayout.h"

@interface CollectionViewLayout ()
{
    NSMutableDictionary *_layoutAttributes;
    CGSize _contentSize;
}
@end

@implementation CollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
- (void)prepareLayout
{
    [super prepareLayout];
    
    _layoutAttributes = [NSMutableDictionary dictionary]; // 1
    
    NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:path];
    attributes.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, self.itemHeight / 4.0f);
    
    NSString *headerKey = [self layoutKeyForHeaderAtIndexPath:path];
    _layoutAttributes[headerKey] = attributes; // 2
    
    NSUInteger numberOfSections = [self.collectionView numberOfSections]; // 3
    
    CGFloat yOffset = self.itemHeight / 4.0f;
    
    for (int section = 0; section < numberOfSections; section++)
    {
        NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section]; // 3
        
        CGFloat xOffset = self.horizontalInset;
        
        for (int item = 0; item < numberOfItems; item++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath]; // 4
            
            CGSize itemSize = CGSizeZero;
            
            BOOL increaseRow = NO;
            
            if (self.collectionView.frame.size.width - xOffset > self.maximumItemWidth * 1.5f)
            {
                itemSize = [self randomItemSize]; // 5
            }
            else
            {
                itemSize.width = self.collectionView.frame.size.width - xOffset - self.horizontalInset;
                itemSize.height = self.itemHeight;
                increaseRow = YES; // 6
            }
            
            attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
            NSString *key = [self layoutKeyForIndexPath:indexPath];
            _layoutAttributes[key] = attributes; // 7
            
            xOffset += itemSize.width;
            xOffset += self.horizontalInset; // 8
            
            if (increaseRow
                && !(item == numberOfItems-1 && section == numberOfSections-1)) // 9
            {
                yOffset += self.verticalInset;
                yOffset += self.itemHeight;
                xOffset = self.horizontalInset;
            }
        }
    }
    
    yOffset += self.itemHeight; // 10
    
    _contentSize = CGSizeMake(self.collectionView.frame.size.width, yOffset + self.verticalInset); // 11
}


#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))

- (CGSize)randomItemSize
{
    return CGSizeMake([self getRandomWidth], self.itemHeight);
}

- (CGFloat)getRandomWidth
{
    return RAND_FROM_TO(self.minimumItemWidth, self.maximumItemWidth);
}

- (NSString *)layoutKeyForIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"%ld_%ld", indexPath.section, indexPath.row];
}

- (NSString *)layoutKeyForHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"s_%ld_%ld", indexPath.section, indexPath.row];
}


- (CGSize)collectionViewContentSize
{
    return _contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *headerKey = [self layoutKeyForHeaderAtIndexPath:indexPath];
    return _layoutAttributes[headerKey];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self layoutKeyForIndexPath:indexPath];
    return _layoutAttributes[key];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
        UICollectionViewLayoutAttributes *layoutAttribute = _layoutAttributes[evaluatedObject];
        return CGRectIntersectsRect(rect, [layoutAttribute frame]);
    }];
    
    NSArray *matchingKeys = [[_layoutAttributes allKeys] filteredArrayUsingPredicate:predicate];
    return [_layoutAttributes objectsForKeys:matchingKeys notFoundMarker:[NSNull null]];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !(CGSizeEqualToSize(newBounds.size, self.collectionView.frame.size));
}

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            case UICollectionUpdateActionDelete:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
            case UICollectionUpdateActionMove:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            default:
                NSLog(@"unhandled case: %@", updateItem);
                break;
        }
    }
//    self.indexPathsToAnimate = indexPaths;
}

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//    
//    if ([_indexPathsToAnimate containsObject:itemIndexPath]) {
//        attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
//        attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
//        [_indexPathsToAnimate removeObject:itemIndexPath];
//    }
    
    return attr;
}
@end
