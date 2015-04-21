//
//  NSMutableArray+Expand.m
//  Common
//
//  Created by wlpiaoyi on 15/1/7.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "NSMutableArray+Expand.h"

@implementation NSMutableArray(Expand)
+ (NSMutableArray*)mutableArrayUsingWeakReferences {
    return [self mutableArrayUsingWeakReferencesWithCapacity:0];
}
+ (NSMutableArray*)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity {
    CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
    // We create a weak reference array
    return (id)CFBridgingRelease(CFArrayCreateMutable(0, capacity, &callbacks));
}

@end
