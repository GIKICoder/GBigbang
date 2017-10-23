//
//  GTagFlowContainer.h
//  GBigbangExample
//
//  Created by GIKI on 2017/10/20.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTagFlowView.h"

#define kGPopContainerHiddenKey @"kGPopContainerHiddenKey"
typedef void(^GTagFlowActionBlock) (NSString *actionTitle,NSString*newText);

@interface GTagFlowContainer : UIView

@property (nonatomic, copy) GTagFlowActionBlock  actionBlock;

@property (nonatomic, strong,readonly) GTagFlowView * flowView;
- (void)configDatas:(NSArray*)flowDatas;
- (void)show;
- (void)hide;
@end
