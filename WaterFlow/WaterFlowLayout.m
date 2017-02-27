//
//  WaterFlowLayout.m
//  WaterFlow
//
//  Created by shang_uai on 16/7/27.
//  Copyright © 2016年 shang_uai. All rights reserved.
//

#import "WaterFlowLayout.h"

static NSInteger const DefaultColumnCount = 3;
static CGFloat const DefaultColumnSpacing = 10;
static CGFloat const DefaultRowSpacing = 10;
static UIEdgeInsets const DefaultEdgeInsets = {10, 10, 10, 10};

@interface WaterFlowLayout ()

@property (nonatomic, strong) NSMutableArray *attrArray;
@property (nonatomic, strong) NSMutableArray *maxYArray;

- (NSInteger)columnCount;
- (CGFloat)columnSpacing;
- (CGFloat)rowSpacing;
- (UIEdgeInsets)edgeInsets;

@end

@implementation WaterFlowLayout

- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(waterFlowLayoutColumnCount:)]) {
        return [self.delegate waterFlowLayoutColumnCount:self];
    }
    return DefaultColumnCount;
}

- (CGFloat)columnSpacing
{
    if ([self.delegate respondsToSelector:@selector(waterFlowLayoutColumnSpacing:)]) {
        return [self.delegate waterFlowLayoutColumnSpacing:self];
    }
    return DefaultColumnSpacing;
}

- (CGFloat)rowSpacing
{
    if ([self.delegate respondsToSelector:@selector(waterFlowLayoutRowSpacing:)]) {
        return [self.delegate waterFlowLayoutRowSpacing:self];
    }
    return DefaultRowSpacing;
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(waterFlowLayoutEdgeInsets:)]) {
        return [self.delegate waterFlowLayoutEdgeInsets:self];
    }
    return DefaultEdgeInsets;
}


- (NSMutableArray *)maxYArray
{
    if (!_maxYArray) {
        _maxYArray = [NSMutableArray array];
    }
    
    return _maxYArray;
}


- (NSMutableArray *)attrArray
{
    if (!_attrArray) {
        _attrArray = [NSMutableArray array];
    }
    
    return _attrArray;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.attrArray removeAllObjects];
    [self.maxYArray removeAllObjects];
    
    for (NSInteger i = 0; i < [self columnCount]; i++) {
        
        [self.maxYArray addObject:@([self edgeInsets].top)];
    }
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < itemCount; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.attrArray addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger __block minHeightColumn = 0;
    NSInteger __block minHeight = [[self.maxYArray objectAtIndex:minHeightColumn] floatValue];
    
    
    [self.maxYArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat columnHeight = [(NSNumber *)obj floatValue];
        
        if (minHeight > columnHeight) {
            minHeight = columnHeight;
            minHeightColumn = idx;
        }
    }];
    
    UIEdgeInsets edgeInsets = [self edgeInsets];
    
    CGFloat width = (CGRectGetWidth(self.collectionView.frame) - edgeInsets.left - edgeInsets.right - [self columnSpacing] * ([self columnCount] - 1)) / [self columnCount];
    
    CGFloat height = [self.delegate waterFlowLayout:self heightForItemAtIndex:indexPath.item itemWidth:width];
    
    CGFloat originX = edgeInsets.left + minHeightColumn * (width + [self columnSpacing]);
    
    CGFloat originY = minHeight;
    
    if (originY != edgeInsets.top) {
        
        originY += [self rowSpacing];
    }

    [attributes setFrame:CGRectMake(originX, originY, width, height)];
    
    self.maxYArray[minHeightColumn] = @(CGRectGetMaxY(attributes.frame));
    
    return attributes;
}


- (CGSize)collectionViewContentSize
{
    NSInteger __block maxHeight = 0;
    
    [self.maxYArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat columnHeight = [(NSNumber *)obj floatValue];
        
        if (maxHeight < columnHeight) {
            maxHeight = columnHeight;
        }
    }];
    
    return CGSizeMake(0, maxHeight + [self edgeInsets].bottom);
}

@end
