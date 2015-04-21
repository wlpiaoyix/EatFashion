//
//  OrdersService.m
//  ShiShang
//
//  Created by torin on 14/12/27.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "OrdersService.h"
#import "Common+Expand.h"

#define URL_STATISGET @"restful/order/get"
#define URL_ORDERADD @"restful/order/add"
#define URL_ORDERCANCEL @"restful/order/canceled"

@implementation OrdersService
- (void)queryOrdersForDate:(NSDate *)date  pageNum:(int) pageNum Success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild
{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_STATISGET];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        success(data,nil);
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
    }];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *curretnDate = [formatter stringFromDate:date];
    NSString *formatterDate = [NSString stringWithFormat:@"%@%@",curretnDate,@"23:59:59"];
    
    NSDictionary *dict = @{@"userID":[[ConfigManage getLoginUser].keyId stringValue],@"shopID":[[ConfigManage getLoginUser].shopId stringValue],@"currentTime":formatterDate,@"page":[NSNumber numberWithInt:pageNum].stringValue};
    [nwh requestGET:dict];
}

-(void) persistOrder:(EntityOrder*) order success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    order.entityId = [ConfigManage getLoginUser].keyId;
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@?userID=%@&shopID=%@",BASEURL,URL_ORDERADD,[[ConfigManage getLoginUser].keyId stringValue],[[ConfigManage getLoginUser].shopId stringValue]];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        if([self isSuccessResult:&result data:data]){
        }
        success(data,nil);
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
    }];
    NSDictionary *json = [order toJson];
    [nwh requestPOST:json];
}

- (void)cancelOrder:(NSDictionary *)dict success:(CallBackHttpUtilRequest)success faild:(CallBackHttpUtilRequest)faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@?userID=%@&shopID=%@&orderID=%@",BASEURL,URL_ORDERCANCEL,[[ConfigManage getLoginUser].keyId stringValue],dict[@"shopID"],dict[KeyOrderId]];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        if (success) {
            success(data,nil);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
        
    }];
    [nwh requestPOST:nil];
}
@end
