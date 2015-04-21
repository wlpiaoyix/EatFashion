//
//  EntityOrder.m
//  ShiShang
//
//  Created by torin on 14/12/27.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "EntityOrder.h"

NSString *const KeyOrderId = @"id";
NSString *const KeyOrderDeliverTime = @"deliverTime";
NSString *const KeyOrderType = @"type";
NSString *const KeyOrderOrderStatus = @"orderStatus";
NSString *const KeyOrderNeedPay = @"needPay";
NSString *const KeyOrderTotalPay = @"totalPay";
NSString *const KeyOrderExtranInfo = @"extraInfo";

NSString *const KeyOrderCustomers = @"customer";
NSString *const KeyOrderCustomerId = @"id";



NSString *const KeyOrderShopId = @"shopID";

NSString *const KeyOrderItems = @"orderItems";
NSString *const KeyOrderProductName = @"productName";
NSString *const KeyOrderProductid = @"productid";
NSString *const KeyOrderProductPrice = @"productPrice";
NSString *const KeyOrderAmount = @"amount";

NSString *const KeyOrderUseVoucher = @"useVoucher";

NSString *const KeyOrder = @"order";

@implementation EntityOrder
+(EntityOrder*) entityWithJson:(NSDictionary*) json{
    EntityOrder *entity = [EntityOrder new];
    entity.entityId = [json objectForKey:KeyOrderId];
    NSDictionary *order = [json objectForKey:KeyOrder];
    if (order) {
        entity.customer = [json objectForKey:KeyOrderCustomers];
        entity.shopId = [order objectForKey:KeyOrderShopId];
        entity.deliverTime = [order objectForKey:KeyOrderDeliverTime];
        entity.orderItems =  [order objectForKey:KeyOrderItems];
        entity.useVoucher = [order objectForKey:KeyOrderUseVoucher];
        entity.totalPay = [order objectForKey:KeyOrderTotalPay];
        entity.needPay = [order objectForKey:KeyOrderNeedPay];
        entity.extraInfo = [order objectForKey:KeyOrderExtranInfo];
    }
    return entity;
}
-(NSDictionary*) toJson{
    NSMutableDictionary *json = [NSMutableDictionary new];
    if (self.entityId) {
        [json setObject:self.entityId forKey:KeyOrderId];
    }
    NSMutableDictionary *orderJson = [NSMutableDictionary new];
    [json setObject:orderJson forKey:KeyOrder];
    
    [orderJson setObject:self.customer forKey:KeyOrderCustomers];
    
    if (self.shopId) {
        [orderJson setObject:self.shopId forKey:KeyOrderShopId];
    }
    if (self.deliverTime) {
        [orderJson setObject:self.deliverTime forKey:KeyOrderDeliverTime];
    }
    if (self.orderItems) {
        [orderJson setObject:self.orderItems forKey:KeyOrderItems];
    }
    if (self.useVoucher) {
        [orderJson setObject:self.useVoucher forKey:KeyOrderUseVoucher];
    }
    if (self.totalPay) {
        [orderJson setObject:self.totalPay forKey:KeyOrderTotalPay];
    }
    if (self.needPay) {
        [orderJson setObject:self.needPay forKey:KeyOrderNeedPay];
    }
    if (self.extraInfo) {
        [orderJson setObject:self.extraInfo forKey:KeyOrderExtranInfo];
    }
    return json;
}

@end
