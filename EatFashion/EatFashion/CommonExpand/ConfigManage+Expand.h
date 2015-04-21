//
//  ConfigManage+Expand.h
//  ShiShang
//
//  Created by wlpiaoyi on 14/12/2.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ConfigManage.h"
#import "EntityUser.h"

@interface ConfigManage(Expand)
+(NSString*) getUserName;
+(NSString*) getPassword;
+(NSNumber*) getShopId;
+(void) setUserName:(NSString*) userName;
+(void) setPassword:(NSString*) passowrd;
+(void) setShopId:(NSNumber*) _shopId_;
+(void) setConfigValueByUser:(id)value Key:(NSString *)key;
+(id) getConfigValueByUser:(NSString *)key;
+(void) setLoginUser:(EntityUser*) user;
+(EntityUser*) getLoginUser;

@end
