//
//  MessageService.h
//  ShiShang
//
//  Created by wlpiaoyi on 15/1/11.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "BaseService.h"
#import "EntityMessage.h"

@interface MessageService : BaseService
-(void) getApplicantsWithSuccess:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
-(void) searchWithItem:(NSString*) item success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
-(void) shopGroupActionWithMessage:(EntityMessage*) message success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
@end
