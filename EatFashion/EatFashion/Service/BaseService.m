//
//  BaseService.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "BaseService.h"
#import "Common+Expand.h"

 NSString *KEY_STATUS = @"status";
 NSString *KEY_DATA = @"data";

 NSString *KEY_CODE = @"errorNo";
 NSString *KEY_MESSAGE = @"errorMessage";

@implementation BaseService

-(void) showMsgIfNeed:(NSDataResult*) resulte{
    if (resulte&&resulte.code!=200) {
        [Utils showAlert:(NSString*)resulte.data title:nil];
    }else if (!resulte){
//        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
    }
}

-(BOOL) isSuccessResult:(NSDataResult**) result data:(NSObject*) data{
    @try {
        id json = [((NSString*)data) JSONValue];
        if (json) {
            NSNumber *erroNo;
            if ([json isKindOfClass:[NSArray class]]) {
                erroNo = nil;
            }else{
                erroNo = [json valueForKey:KEY_CODE];
            }
            *result = [[NSDataResult alloc] init];
            int code;
            NSObject *data;
            if (erroNo&&erroNo!=NULL) {
                code = erroNo.intValue;
                data = [json valueForKey:KEY_MESSAGE];
            }else{
                code = 200;
                data = json;
            }
            [*result setCode:code];
            [*result setData:data];
            if (code==200) {
                return true;
            }
        }
        return false;
    }
    @finally {
        [self showMsgIfNeed:*result];
    }
}

@end
