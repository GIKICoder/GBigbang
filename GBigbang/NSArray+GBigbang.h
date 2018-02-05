//
//  NSArray+GBigbang.h
//  GBigbang
//
//  Created by GIKI on 2018/2/5.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (GBigbang)

- (id)objectAtIndexSafely:(NSUInteger)index;

@end

@interface NSMutableArray (Safely)

- (void)addObjectSafely:(id)anObject;
- (void)insertObjectSafely:(id)anObject atIndex:(NSUInteger)index;
- (void)removeObjectAtIndexSafely:(NSUInteger)index;
- (void)replaceObjectAtIndexSafely:(NSUInteger)index withObject:(id)anObject;

@end
