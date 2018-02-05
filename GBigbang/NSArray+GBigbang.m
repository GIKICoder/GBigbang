//
//  NSArray+GBigbang.m
//  GBigbang
//
//  Created by GIKI on 2018/2/5.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "NSArray+GBigbang.h"

@implementation NSArray (GBigbang)

- (id)objectAtIndexSafely:(NSUInteger)index
{
    if (index >= self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

@end

@implementation NSMutableArray (Safely)

- (void)addObjectSafely:(id)anObject {
    if (anObject != nil) {
        [self addObject:anObject];
    }
}

- (void)insertObjectSafely:(id)anObject atIndex:(NSUInteger)index {
    if (anObject != nil && index < [self count]) {
        [self insertObject:anObject atIndex:index];
    }
}

- (void)removeObjectAtIndexSafely:(NSUInteger)index {
    if (index < [self count]) {
        [self removeObjectAtIndex:index];
    }
}

- (void)replaceObjectAtIndexSafely:(NSUInteger)index withObject:(id)anObject {
    if (anObject != nil && index < [self count]) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}


@end
