//
//  BaseService.h
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#define KEY_CACHE_HTTP_UEL(_URL_) [NSString stringWithFormat:@"HTTPHEAD_%@",_URL_];

#import <Foundation/Foundation.h>
#import "Utils+Expand.h"
#import "NSDataResult.h"


extern  NSString *KEY_STATUS;
extern  NSString *KEY_DATA;
extern  NSString *KEY_CODE;
extern  NSString *KEY_MESSAGE;

@interface BaseService : NSObject
-(BOOL) isSuccessResult:(NSDataResult**) result data:(NSObject*) data;
@end
