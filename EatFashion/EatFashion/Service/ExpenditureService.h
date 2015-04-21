//
//  ExpenditureService.h
//  EatFashion
//
//  Created by wlpiaoyi on 15/4/12.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "BaseService.h"

@interface ExpenditureService : BaseService
/**
 查询支出信息
 */
- (void)queryExpenseForStartTime:(NSDate*) startTime endTime:(NSDate*) endTime pageNum:(int) pageNum Success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
/**
 添加支出信息
 */
- (void) addExpenseForItems:(NSArray*) items extraInfo:(NSString*) extraInfo Success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
/**
 删除支出信息
 */
- (void) cancelExpenseForOrderId:(NSString*) orderId Success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
/**
 查询支出信息
 */
- (void) getStatisExpenseForStartTime:(NSDate*) startTime endTime:(NSDate*) endTime Success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
@end
