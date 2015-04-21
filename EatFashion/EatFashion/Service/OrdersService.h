//
//  OrdersService.h
//  ShiShang
//
//  Created by torin on 14/12/27.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "BaseService.h"
#import "EntityOrder.h"

@interface OrdersService : BaseService
- (void)queryOrdersForDate:(NSDate *)date pageNum:(int) pageNum Success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
-(void) persistOrder:(EntityOrder*) order success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;

//订单作废
- (void)cancelOrder:(NSDictionary *)dict success:(CallBackHttpUtilRequest)success faild:(CallBackHttpUtilRequest)faild;
@end
