//
//  ExpenditureService.m
//  EatFashion
//
//  Created by wlpiaoyi on 15/4/12.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "ExpenditureService.h"
#import "Common+Expand.h"

#define URL_EXPENSE_GET @"restful/expense/get"
#define URL_EXPENSE_ADD @"restful/expense/add"
#define URL_EXPENSE_CANCELED @"restful/expense/canceled"
#define URL_EXPENSE_GETSTATIS @"restful/expense/getStatis"
@implementation ExpenditureService
/**
 查询支出信息
 */
- (void)queryExpenseForStartTime:(NSDate*) startTime endTime:(NSDate*) endTime pageNum:(int) pageNum Success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_EXPENSE_GET];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        id json = nil;
        if(data){
            json = [(NSString*)data JSONValue];
        }
        success(json,nil);
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
    }];
    
    NSDictionary *dict = @{@"userID":[[ConfigManage getLoginUser].keyId stringValue],@"shopID":[[ConfigManage getLoginUser].shopId stringValue],@"startTime":[startTime dateFormateDate:nil] ,@"endTime":[endTime dateFormateDate:nil],@"page":[NSNumber numberWithInt:pageNum].stringValue};
    [nwh requestGET:dict];
    
}
/**
 添加支出信息
 */
- (void) addExpenseForItems:(NSArray*) items extraInfo:(NSString*) extraInfo Success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@?userID=%@&shopID=%@",BASEURL,URL_EXPENSE_ADD,[[ConfigManage getLoginUser].keyId stringValue],[[ConfigManage getLoginUser].shopId stringValue]];
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
    
    float totalCost = 0.0f;
    for (NSDictionary *item in items) {
        NSNumber *itemValue = [item valueForKey:@"itemValue"];
        totalCost += itemValue.floatValue;
    }
    
    NSDictionary *dict = @{
                           @"shopID":[[ConfigManage getLoginUser].shopId stringValue],
                           @"customer":@{@"id":[[ConfigManage getLoginUser].keyId stringValue]
                                         },
                           @"deliverTime":[[NSDate new] dateFormateDate:@"yyyy-MM-dd HH:mm:ss:00"],
                           @"expenseItems":items,
                           @"totalCost":[NSNumber numberWithFloat:totalCost],
                           @"extraInfo":extraInfo == nil?@"":extraInfo
                           };
    [nwh requestPOST:dict];
}
/**
 添加支出信息
 */
- (void) cancelExpenseForOrderId:(NSString*) orderId Success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@?userID=%@&shopID=%@&expenseID=%@",BASEURL,URL_EXPENSE_CANCELED,[[ConfigManage getLoginUser].keyId stringValue],[[ConfigManage getLoginUser].shopId stringValue],orderId];
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
    
    [nwh requestPOST:nil];
}
/**
 查询支出信息
 */
- (void) getStatisExpenseForStartTime:(NSDate*) startTime endTime:(NSDate*) endTime Success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@?userID=%@&shopID=%@&startTime=%@&endTime=%@",BASEURL,URL_EXPENSE_GETSTATIS,[[ConfigManage getLoginUser].keyId stringValue],[[ConfigManage getLoginUser].shopId stringValue],[startTime dateFormateDate:@"yyyy-MM-dd HH:mm:ss"],[endTime dateFormateDate:@"yyyy-MM-dd HH:mm:ss"]];
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
    
    [nwh requestGET:nil];
}

@end
