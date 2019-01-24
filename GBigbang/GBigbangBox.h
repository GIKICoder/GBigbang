//
//  GBigbangBox.h
//  GBigbang
//
//  Created by GIKI on 2017/10/19.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GBigbangItem;
typedef NS_OPTIONS(NSInteger, PINSegmentationOptions) {
    PINSegmentationOptionsNone              = 0,
    PINSegmentationOptionsDeduplication     = 1 << 0,
    PINSegmentationOptionsKeepEnglish       = 1 << 1,
    PINSegmentationOptionsKeepSymbols       = 1 << 2,
};
@interface GBigbangBox : NSObject

+ (NSArray<GBigbangItem*>*)bigBang:(NSString*)string;

/**
 https://github.com/cyanzhong/segmentation
 */
+ (NSArray<GBigbangItem *> *)bigBangWithOption:(PINSegmentationOptions)options string:(NSString*)string;

@end

@interface GBigbangItem : NSObject
@property (nonatomic, copy,readonly) NSString * text;
@property (nonatomic, assign,readonly) BOOL isSymbolOrEmoji;
+(instancetype)bigbangText:(NSString*)text isSymbol:(BOOL)isSymbol;
@end
