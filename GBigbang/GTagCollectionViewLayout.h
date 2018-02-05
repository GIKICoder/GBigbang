//
//  GTagCollectionViewLayout.h
//  GBigbang
//
//  Created by GIKI on 2017/11/23.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTagLayoutDataProtocol<UICollectionViewDelegateFlowLayout>
- (CGFloat)maxWidthOfLine_BookBangCollectionViewLayout;//--一行的最大宽度
@end


@interface GTagCollectionViewLayout : UICollectionViewFlowLayout
@property (nonatomic, strong) id<GTagLayoutDataProtocol>  delegate;
@end
