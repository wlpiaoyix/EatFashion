 //
//  UserService.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#define URL_LOGIN @"restful/customer/login"
#define URL_REGESTER @"restful/customer/register"
#define URL_UPDATEPASSWORD @"restful/customer/updatePassword"
#define URL_UPDATEPROFILE @"restful/customer/updateProfile"

#import "UserService.h"

#import "Common+Expand.h"

@implementation UserService
+(void) excuteLoginSuccess:(CallBackHttpUtilRequest) success json:(NSDataResult*) resulte {
    
    EntityUser *user  = nil;
    if (resulte&&resulte.code==200) {
        NSDictionary *json = (NSDictionary*)resulte.data;
        NSNumber *shopId = [[json objectForKey:@"shop"] objectForKey:@"id"];
        NSString *shopName = [[json objectForKey:@"shop"] objectForKey:@"shopName"];
        NSMutableDictionary *customer = [NSMutableDictionary dictionaryWithDictionary:[json objectForKey:@"customer"]];
        [customer setObject:shopId forKey:KeyUserShopId];
        [customer setObject:shopName forKey:KeyUserShopName];
        if (customer) {
            user = [EntityUser entityWithJson:customer];
        }
        [ConfigManage setShopId:shopId];
    }
    [ConfigManage setLoginUser:user];
    if (success) {
        success(user,nil);
    }
}
-(void) loginWithUserName:(NSString*) userName password:(NSString*) password success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_LOGIN];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        if ([self isSuccessResult:&result data:data]) {
            NSString *key = KEY_CACHE_HTTP_UEL(URL_LOGIN);
            [ConfigManage setConfigValueByUser:data Key:key];
        }
        [UserService excuteLoginSuccess:success json:result];
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        NSString *key = KEY_CACHE_HTTP_UEL(URL_LOGIN);
        NSDictionary *cache = [ConfigManage getConfigValueByUser:key];
        NSDataResult *result;
        if ([NSString isEnabled:cache]&&[self isSuccessResult:&result data:cache]) {
            [UserService excuteLoginSuccess:success json:result];
        }else{
            faild(data,userInfo);
            [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
        }
        
    }];
    [nwh requestPOST:@{@"loginName":userName,@"plainPassword":password}];
}

-(void) exitLogin{
    [ConfigManage setLoginUser:nil];
    [ConfigManage setPassword:nil];
    
}

-(void) regesiterWithUser:(EntityUser*) user success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_REGESTER];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
    
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        if ([self isSuccessResult:&result data:data]) {
        }
        if (success) {
            success(result.data,userInfo);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
        
    }];
    [nwh requestPOST:[user toJson]];
    
}

-(int) smsVerificationRegesiterWithPhone:(NSString*) phone success:(CallBackHttpUtilRequest) success{
    
    [Utils showLoading:@"短信发送中..."];
    id<HttpUtilRequestDelegate> nwh = [HttpUtilRequest new];
    [nwh setHttpEncoding:NSUTF8StringEncoding];
    NSString *url = @"http://106.ihuyi.com/webservice/sms.php?method=Submit";
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        if (success) {
            success(nil,nil);
        }
        
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
    }];
    int num = random()%1000000;
    NSString *content = [NSString stringWithFormat:NSLocalizedString(@"regesit_SMS_verification", ),num];
    [nwh requestPOST:@{@"account":@"cf_shang",@"password":@"20140818js",@"mobile":phone,@"content":content}];
    return num;
}

-(void) updatePassword:(NSString*) password phone:(NSString*) phone success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_UPDATEPASSWORD];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        if ([self isSuccessResult:&result data:data]) {
        }
        if (success) {
            success(result.data,userInfo);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
        
    }];
    [nwh requestPOST:@{@"phoneNumber":phone,@"plainPassword":password}];
}
-(int) smsVerificationUpadatePasswordWithPhone:(NSString*) phone success:(CallBackHttpUtilRequest) success{
    
    [Utils showLoading:@"短信发送中..."];
    id<HttpUtilRequestDelegate> nwh = [HttpUtilRequest new];
    [nwh setHttpEncoding:NSUTF8StringEncoding];
    NSString *url = @"http://106.ihuyi.com/webservice/sms.php?method=Submit";
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        if (success) {
            success(nil,nil);
        }
        
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
    }];
    int num = random()%1000000;
    NSString *content = [NSString stringWithFormat:NSLocalizedString(@"updatePassword_SMS_verification", ),num];
    [nwh requestPOST:@{@"account":@"cf_shang",@"password":@"20140818js",@"mobile":phone,@"content":content}];
    return num;
}

- (void)updateProfileWithParams:(NSDictionary *)params success:(CallBackHttpUtilRequest)success faild:(CallBackHttpUtilRequest)faild
{
    NSDictionary *customerDict = params[@"customer"];
    NSDictionary *shopDict = params[@"shop"];
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@?userID=%@&shopID=%@&nickName=%@&shopName=%@",BASEURL,URL_UPDATEPROFILE,customerDict[@"id"],shopDict[@"id"],customerDict[@"name"],
                     shopDict[@"shopName"]];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        if ([self isSuccessResult:&result data:data]) {
        }
        [UserService excuteLoginSuccess:nil json:result];
        if (success) {
            success(result.data,userInfo);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
        
    }];
    [nwh requestPOST:params];
}

@end
