//
//  WaterFlowLayout.h
//  WaterFlow
//
//  Created by shang_uai on 16/7/27.
//  Copyright © 2016年 shang_uai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterFlowLayout;

@protocol WaterFlowLayoutDelegate <NSObject>

@required
- (CGFloat)waterFlowLayout:(WaterFlowLayout *)layout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (NSInteger)waterFlowLayoutColumnCount:(WaterFlowLayout *)layout;
- (CGFloat)waterFlowLayoutColumnSpacing:(WaterFlowLayout *)layout;
- (CGFloat)waterFlowLayoutRowSpacing:(WaterFlowLayout *)layout;
- (UIEdgeInsets)waterFlowLayoutEdgeInsets:(WaterFlowLayout *)layout;

@end


@interface WaterFlowLayout : UICollectionViewLayout

@property (nonatomic, weak) id<WaterFlowLayoutDelegate>delegate;

@end
