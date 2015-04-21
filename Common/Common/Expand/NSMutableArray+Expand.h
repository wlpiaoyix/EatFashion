//
//  NSMutableArray+Expand.h
//  Common
//
//  Created by wlpiaoyi on 15/1/7.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray(Expand)
+ (NSMutableArray*)mutableArrayUsingWeakReferences;
+ (NSMutableArray*)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity;
@end
