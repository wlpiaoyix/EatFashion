//
//  ConfigManage+Expand.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/12/2.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ConfigManage+Expand.h"
#import "Common+Expand.h"

#define KEYUSERNAME @"adfasdfdf"
#define KEYPASSWORD @"adsfasdfafd"
#define KEYSHOPID @"shopId"
static EntityUser *loginUser;
@implementation ConfigManage(Expand)
+(NSString*) getUserName{
    return [ConfigManage getConfigValue:KEYUSERNAME];
}
+(NSString*) getPassword{
    return [ConfigManage getConfigValue:KEYPASSWORD];
}
+(NSNumber*) getShopId{
    return [ConfigManage getConfigValueByUser:KEYSHOPID];
}
+(void) setUserName:(NSString*) _userName_{
    [ConfigManage setConfigValue:_userName_ Key:KEYUSERNAME];
}
+(void) setPassword:(NSString*) _passowrd_{
    [ConfigManage setConfigValue:_passowrd_ Key:KEYPASSWORD];
}
+(void) setShopId:(NSNumber*) _shopId_{
    [ConfigManage setConfigValueByUser:_shopId_ Key:KEYSHOPID];
}
+(void) setLoginUser:(EntityUser*) user{
    loginUser = user;
}
+(EntityUser*) getLoginUser{
    return loginUser;
}
+(void) setConfigValueByUser:(id)value Key:(NSString *)key{
    NSString *username = [ConfigManage getUserName];
    if ([NSString isEnabled:username]) {
        [ConfigManage setConfigValue:value Key:[NSString stringWithFormat:@"%@_%@",username,key]];
    }
}
+(id) getConfigValueByUser:(NSString *)key{
    NSString *username = [ConfigManage getUserName];
    if ([NSString isEnabled:username]) {
        return [ConfigManage getConfigValue:[NSString stringWithFormat:@"%@_%@",username,key]];
    }
    return nil;
    
}

@end
