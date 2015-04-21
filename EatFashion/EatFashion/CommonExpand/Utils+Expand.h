//
//  Util+Expand.h
//  ShiShang
//
//  Created by wlpiaoyi on 14/12/26.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//
#import "HttpUtil.h"
#import "Utils.h"
@interface Utils(Expand)
+(id<HttpUtilRequestDelegate>) getHttpUtilRequest;
+(UIWindow*) setShiShangController:(UIViewController*) vc;
+(id) getEntityManger;

@end
