//
//  ViewController.m
//  WaterFlow
//
//  Created by shang_uai on 16/7/27.
//  Copyright © 2016年 shang_uai. All rights reserved.
//

#import "ViewController.h"
#import "WaterFlowLayout.h"

@interface ViewController ()<UICollectionViewDataSource, WaterFlowLayoutDelegate>

@end

@implementation ViewController

static NSString *const CellIndentifier = @"cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    WaterFlowLayout *flowLayout = [[WaterFlowLayout alloc] init];
    flowLayout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView setDataSource:self];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIndentifier];
    [self.view addSubview:collectionView];
}


#pragma mark - CollectionView dataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIndentifier forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor orangeColor]];
    
    NSInteger tag = 10;
    UILabel *label = [cell.contentView viewWithTag:tag];
    
    if (!label) {
        
        label = [[UILabel alloc] init];
        [label setTag:tag];
        [cell.contentView addSubview:label];
    }
    
    [label setText:[NSString stringWithFormat:@"%zd", indexPath.item]];
    [label sizeToFit];
    
    return cell;
}

#pragma mark waterFlowLayout delegate

- (CGFloat)waterFlowLayout:(WaterFlowLayout *)layout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    return 200 + arc4random_uniform(100);
}

- (NSInteger)waterFlowLayoutColumnCount:(WaterFlowLayout *)layout
{
    return 2;
}

- (CGFloat)waterFlowLayoutColumnSpacing:(WaterFlowLayout *)layout
{
    return 10;
}

- (CGFloat)waterFlowLayoutRowSpacing:(WaterFlowLayout *)layout
{
    return 15;
}

- (UIEdgeInsets)waterFlowLayoutEdgeInsets:(WaterFlowLayout *)layout
{
    return UIEdgeInsetsMake(5, 15, 30, 15);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
