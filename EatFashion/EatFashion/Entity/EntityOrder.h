//
//  EntityOrder.h
//  ShiShang
//
//  Created by torin on 14/12/27.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const KeyOrderId;
extern NSString *const KeyOrderDeliverTime;
extern NSString *const KeyOrderType;
extern NSString *const KeyOrderOrderStatus;
extern NSString *const KeyOrderNeedPay;
extern NSString *const KeyOrderTotalPay;
extern NSString *const KeyOrderExtranInfo;

extern NSString *const KeyOrderCustomers;
extern NSString *const KeyOrderCustomerId;

extern NSString *const KeyOrderShopId;

extern NSString *const KeyOrderItems;
extern NSString *const KeyOrderAmount;
extern NSString *const KeyOrderProductid;
extern NSString *const KeyOrderProductName;
extern NSString *const KeyOrderProductPrice;

extern NSString *const KeyOrderUseVoucher;

extern NSString *const KeyOrder;

@interface EntityOrder : NSObject
@property (nonatomic,strong) NSNumber *entityId;
@property (nonatomic,strong) NSDictionary *customer;
@property (nonatomic,strong) NSNumber *shopId;
@property (nonatomic,strong) NSString *deliverTime;
@property (nonatomic,strong) NSArray *orderItems;
@property (nonatomic,strong) NSNumber *useVoucher;
@property (nonatomic,strong) NSNumber *totalPay;
@property (nonatomic,strong) NSNumber *needPay;
@property (nonatomic,strong) NSString *extraInfo;
+(EntityOrder*) entityWithJson:(NSDictionary*) json;
-(NSDictionary*) toJson;
@end
