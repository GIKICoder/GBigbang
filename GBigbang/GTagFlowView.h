//
//  GTagFlowView.h
//  GBigbangExample
//
//  Created by GIKI on 2017/10/13.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTagFlowLayout.h"

typedef void(^GTagFlowViewHeightChanged) (CGFloat original,CGFloat newHeight);
typedef void(^GTagFlowViewSelectedChanged) (BOOL hasSelected);

@interface GTagFlowView : UIView

@property (nonatomic, strong) UICollectionView * collectionView;
/// 标签行间距 Default:10.f
@property (nonatomic, assign) CGFloat lineSpacing;

/// 标签间距 Default:4.f
@property (nonatomic, assign) CGFloat interitemSpacing;

/// collectionView EdgeInsets
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/// 是否支持滑动选择 Default:YES
@property (nonatomic, assign) BOOL  supportSlideSelection;

/// 是否按照添加顺序生成字符串 Default:NO
@property (nonatomic, assign) BOOL  isAddingOrder;

@property (nonatomic, copy ) NSArray<GTagFlowLayout*> * flowDatas;

@property (nonatomic, copy  ) GTagFlowViewHeightChanged  heightChangedBlock;
@property (nonatomic, copy  ) GTagFlowViewSelectedChanged  selectedChangedBlock;

- (void)reloadDatas;

- (void)hiddenAllVisibleCells;
- (void)showCellsWithAnimation;

- (NSString*)getNewTextOrderByAdding:(BOOL)addingOrder;
- (NSArray *)filterAllSelectTitlesOrderByAdding:(BOOL)addingOrder;

- (NSString*)getNewTextstring;
- (NSArray *)filterAllSelectTitles;
- (NSArray *)filterNoSelectTitles;

@end
