//
//  EntityMessage.m
//  ShiShang
//
//  Created by wlpiaoyi on 15/1/17.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "EntityMessage.h"

@implementation EntityMessage
+ (NSArray*) getJsonKeys{
    return @[@{JSON_PROPERTY:@"applicantId",JSON_KEY:@"applicantID"},@"name",@{JSON_KEY:@"shopID",JSON_PROPERTY:@"shopId"},@"applyStatus"];
}

@end
