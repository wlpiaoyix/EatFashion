//
//  NSDataResult.h
//  ShiShang
//
//  Created by wlpiaoyi on 14/12/18.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDataResult : NSObject
@property (nonatomic) int code;
@property (nonatomic,strong) NSObject *data;
@end
