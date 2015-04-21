//
//  FoodService.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/25.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//




#define URL_FOODGET @"restful/product/get"
#define URL_FOODTYPEADD @"restful/product/add_type"
#define URL_FOODTYPEUPDATE @"restful/product/update_type"
#define URL_FOODTYPEDELETE @"restful/product/delete_type"
#define URL_FOODADD @"restful/product/add"
#define URL_FOODUPDATE @"restful/product/update"
#define URL_FOODDELETE @"restful/product/delete"

#define URL_ORDERADD @"restful/order/add"

#import "FoodService.h"
#import "Common+Expand.h"
#import "EntityFood.h"

static id synquery;

NSString *const KeyFoodProductVersion = @"KeyFoodProductVersion";

@implementation FoodService
+(void) initialize{
    synquery = [NSObject new];
}
-(id) init{
    if (self = [super init]) {
        self->_em = [Utils getEntityManger];
    }
    return self;
}
-(BOOL) updateAllFood:(NSDictionary*) result{
    if (result) {
        NSNumber *shopId = [ConfigManage getLoginUser].shopId;
        NSString *versionKey = [NSString stringWithFormat:@"version_id_%d",shopId.intValue];
        NSString *versionId = [result valueForKey:@"version_id"];
        NSArray *dics = [result valueForKey:@"products"];
        NSString *configerVersionId = [ConfigManage getConfigValue:versionKey];
        if (![versionId isEqualToString:configerVersionId]) {
            [self.em excuSql:@"DELETE FROM EntityFood  where shopId = ?" Params:@[shopId]];
            [self.em beginTransation];
            for (NSDictionary *dic in dics) {
                EntityFood *food = [EntityFood entityWithJson:dic];
                [self.em persist:food];
            }
            [self.em commitTarnsation];
            [ConfigManage setConfigValue:configerVersionId Key:versionKey];
            return true;
        }
    }
    return false;
}
-(void) excuteQuerySuccess:(CallBackHttpUtilRequest) success result:(NSDictionary*) result {
    @synchronized(synquery){
        NSArray *datas = nil;
        if([self updateAllFood:result]){
            datas =  [self queryAllFoodFromDataBase];
        }
        if (success) {
            success (datas,nil);
        }
    }
    
}
-(void) queryAllFoodForSuccess:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_FOODGET];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        if([self isSuccessResult:&result data:data]){
        }
        [self excuteQuerySuccess:success result:(NSDictionary*)result.data];
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        NSArray *datas =  [self queryAllFoodFromDataBase];
        if (datas&&[datas count]) {
            success(datas,userInfo);
        }else{
            faild(data,userInfo);
            [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
        }
    }];
    [nwh requestGET:@{@"userID":[[ConfigManage getLoginUser].keyId stringValue],@"shopID":[[ConfigManage getLoginUser].shopId stringValue]}];
}
-(NSArray*) queryAllFoodFromDataBase{
    NSNumber *shopId = [ConfigManage getLoginUser].shopId;
    if (!shopId) {
        return nil;
    }
    NSArray *datas =  [self.em queryBySql:@"select * from EntityFood f where f.shopId = ?" Clazz:[EntityFood class] Params:@[shopId]];
    return datas;
}


-(void) presistType:(NSString*) type success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@?userID=%@&shopID=%@&newType=%@",BASEURL,URL_FOODTYPEADD,[[ConfigManage getLoginUser].keyId stringValue],[[ConfigManage getLoginUser].shopId stringValue],type];
    [nwh setRequestString:url];
    EntityFood *food = [EntityFood new];
    food.entityId = @0;
    food.name = @"样品";
    food.price = @0;
    food.type = type;
    food.shopId = [ConfigManage getLoginUser].shopId;
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url,@"food":food}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        BOOL flag = false;
        if ([self isSuccessResult:&result data:data]) {
            flag = [self updateAllFood:(NSDictionary*)result.data];
        }
        if (success) {
            success(flag?@"":nil,nil);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
    }];
    [nwh requestPOST:[food toJson]];
}

-(void) mergeType:(NSString*) type oldType:(NSString*) oldType  success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@?userID=%@&shopID=%@&oldType=%@&newType=%@",BASEURL,URL_FOODTYPEUPDATE,[[ConfigManage getLoginUser].keyId stringValue],[[ConfigManage getLoginUser].shopId stringValue],oldType,type];
    [nwh setRequestString:url];
    EntityFood *food = [EntityFood new];
    food.name = oldType;
    food.type = type;
    food.shopId = [ConfigManage getLoginUser].shopId;
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url,@"food":food}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
//        NSDataResult *result;
//        BOOL flag = false;
//        if ([self isSuccessResult:&result data:data]) {
//            flag = [self updateAllFood:(NSDictionary*)result.data];
//        }
        if (success) {
            success(@"",nil);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
    }];
    [nwh requestPUT:[food toJson]];
}

-(void) removeType:(NSString*) type success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_FOODTYPEDELETE];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        if (success) {
            success(nil,nil);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
    }];
    [nwh requestDELETE:@{@"userID":[ConfigManage getLoginUser].keyId.stringValue,@"shopID":[ConfigManage getLoginUser].shopId.stringValue,@"proType":type}];

}

-(void) presistFood:(EntityFood*) food success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@?userID=%@&shopID=%@",BASEURL,URL_FOODADD,[[ConfigManage getLoginUser].keyId stringValue],[[ConfigManage getLoginUser].shopId stringValue]];
    [nwh setRequestString:url];
    food.shopId = [ConfigManage getLoginUser].shopId;
//    food.userId = [ConfigManage getLoginUser].keyId;
    if (![NSString isEnabled:food.name]) {
        @throw [[NSException alloc] initWithName:@"persist erro" reason:NSLocalizedString(@"foodname_opt_null", nil) userInfo:nil];
    }
    if (!food.price) {
        @throw [[NSException alloc] initWithName:@"persist erro" reason:NSLocalizedString(@"foodprice_opt_null", nil) userInfo:nil];
    }
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url,@"food":food}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        BOOL flag = false;
        if ([self isSuccessResult:&result data:data]) {
            flag = [self updateAllFood:(NSDictionary*)result.data];
        }
        if (success) {
            success(flag?@"":nil,nil);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
    }];
    [nwh requestPOST:[food toJson]];

}
-(void) mergeFood:(EntityFood*) food success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@?userID=%@&shopID=%@",BASEURL,URL_FOODUPDATE,[[ConfigManage getLoginUser].keyId stringValue],[[ConfigManage getLoginUser].shopId stringValue]];
    food.shopId = [ConfigManage getLoginUser].shopId;
    food.userId = nil;
    [nwh setRequestString:url];
    if(!food.keyId){
        @throw [[NSException alloc] initWithName:@"merge erro" reason:NSLocalizedString(@"foodID_opt_null", nil) userInfo:nil];
    }
    if (![NSString isEnabled:food.name]) {
        @throw [[NSException alloc] initWithName:@"merge erro" reason:NSLocalizedString(@"foodname_opt_null", nil) userInfo:nil];
    }
    if (!food.price) {
        @throw [[NSException alloc] initWithName:@"merge erro" reason:NSLocalizedString(@"foodprice_opt_null", nil) userInfo:nil];
    }
    if (!food.shopId) {
        @throw [[NSException alloc] initWithName:@"merge erro" reason:NSLocalizedString(@"shopId_opt_null", nil) userInfo:nil];
    }
    if (![NSString isEnabled:food.type]) {
        @throw [[NSException alloc] initWithName:@"merge erro" reason:NSLocalizedString(@"foodtype_opt_null", nil) userInfo:nil];
    }
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url,@"food":food}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        BOOL flag = false;
        if ([self isSuccessResult:&result data:data]) {
            flag = [self updateAllFood:(NSDictionary*)result.data];
        }
        if (success) {
            success(flag?@"":nil,nil);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
    }];
    [nwh requestPUT:@{KeyFoodEntityId:food.entityId,
                      KeyFoodName:food.name,
                      KeyFoodPrice:food.price,
                      KeyFoodType:food.type,
                      KeyFoodShopId:food.shopId}];
}
-(void) removeFood:(EntityFood*) food success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@?userID=%@&shopID=%@",BASEURL,URL_FOODDELETE,[[ConfigManage getLoginUser].keyId stringValue],[[ConfigManage getLoginUser].shopId stringValue]];
    [nwh setRequestString:url];
    food.shopId = [ConfigManage getLoginUser].shopId;
    food.userId = [ConfigManage getLoginUser].keyId;
    if(!food.keyId){
        @throw [[NSException alloc] initWithName:@"remove erro" reason:NSLocalizedString(@"foodID_opt_null", nil) userInfo:nil];
    }
    if (!food.shopId) {
        @throw [[NSException alloc] initWithName:@"remove erro" reason:NSLocalizedString(@"shopId_opt_null", nil) userInfo:nil];
    }
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url,@"food":food}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        BOOL flag = false;
        if ([self isSuccessResult:&result data:data]) {
            flag = [self updateAllFood:(NSDictionary*)result.data];
        }
        if (success) {
            success(flag?@"":nil,nil);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
    }];
    [nwh requestPUT:@{KeyFoodEntityId:food.entityId,KeyFoodShopId:food.shopId}];
}

@end
