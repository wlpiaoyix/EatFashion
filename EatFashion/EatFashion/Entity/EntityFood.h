//
//  EntityFood.h
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/24.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common+Expand.h"

extern NSString *const KeyFoodId;
extern NSString *const KeyFoodEntityId;
extern NSString *const KeyFoodUserId;
extern NSString *const KeyFoodShopId;
extern NSString *const KeyFoodName;
extern NSString *const KeyFoodType;
extern NSString *const KeyFoodPrice;
extern NSString *const KeyFoodPicturePath;
extern NSString *const KeyFoodStatus;
extern NSString *const KeyFoodGeneratedTime;
extern NSString *const KeyFoodDescriptionInfo;
extern NSString *const KeyFoodAmount;
extern NSString *const KeyFoodRemaining;

extern NSString *const SALE_PREPARED;

@interface EntityFood : NSObject<ProtocolEntity>
@property NSNumber *keyId;
@property NSNumber *entityId;
@property NSNumber *userId;
@property NSNumber *shopId;
@property NSString *name;//菜品名称
@property NSString *type;//类型
@property NSNumber *price;//价格
@property NSString *pricturePath;//图片相对地址
@property NSString *status;//菜品状态
@property NSString *generatedTime;//更新时间
@property NSString *descriptionInfo;//描述
@property NSNumber *amount;//数量
@property NSNumber *remaining;
+(instancetype) entityWithJson:(NSDictionary*) json;
-(NSMutableDictionary*) toJson;
@end
