//
//  MessageService.m
//  ShiShang
//
//  Created by wlpiaoyi on 15/1/11.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//


#define URL_MESSAGE_GetApplicaitons @"restful/news/get_applicants"
#define URL_MESSAGE_Search @"restful/news/search"
#define URL_MESSAGE_shopGroupAction @"restful/news/shopGroup_action"

#import "MessageService.h"
#import "Common+Expand.h"

@implementation MessageService
-(void) getApplicantsWithSuccess:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_MESSAGE_GetApplicaitons];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        if([self isSuccessResult:&result data:data]){
        }
        [self excuteMessageForsuccess:success data:result.data];
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
    }];
    [nwh requestGET:@{@"userID":[[ConfigManage getLoginUser].keyId stringValue],@"shopID":[[ConfigManage getLoginUser].shopId stringValue]}];

}
-(void) excuteMessageForsuccess:(CallBackHttpUtilRequest) success data:(id) data{
    if (success) {
        NSMutableArray *array = [NSMutableArray new];
        if ([data isKindOfClass:[NSArray class]]) {
            for (NSDictionary *json in (NSArray*)data) {
                EntityMessage *message = [EntityMessage instanceWithJson:json];
                [array addObject:message];
            }
        }else{
            EntityMessage *message = [EntityMessage instanceWithJson:data];
            [array addObject:message];
        }
        success(array,nil);
    }

}
-(void) searchWithItem:(NSString*) item success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_MESSAGE_Search];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        if([self isSuccessResult:&result data:data]){
        }
        [self excuteMessageForsuccess:success data:result.data];
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
    }];
    [nwh requestGET:@{@"userID":[[ConfigManage getLoginUser].keyId stringValue],@"shopID":[[ConfigManage getLoginUser].shopId stringValue],@"search_item":item}];
}

-(void) shopGroupActionWithMessage:(EntityMessage*) message success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
//    message.applicantId = @30;
//    message.shopId = @36;
//    message.name = @"name8";
    NSString *url = [NSString stringWithFormat:@"%@/%@?userID=%@&shopID=%@",BASEURL,URL_MESSAGE_shopGroupAction,[[ConfigManage getLoginUser].keyId stringValue],[[ConfigManage getLoginUser].shopId stringValue]];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        if([self isSuccessResult:&result data:data]){
        }
        if (success) {
            success(result.data,nil);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
    }];
    [nwh requestPOST:[message toInstanceJson]];
//    [nwh requestPOST:@{@"applyStatus":message.applyStatus,@"applicantID":[message.applicantId stringValue],@"name":message.name,@"shopID":[message.shopId stringValue]}];
}

@end
