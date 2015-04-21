//
//  FoodService.h
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/25.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "BaseService.h"
#import "Common+Expand.h"
#import "EntityFood.h"


extern NSString *const KeyFoodProductVersion;

@interface FoodService : BaseService

@property (nonatomic,readonly) FDEntityManager *em;

-(void) queryAllFoodForSuccess:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
-(NSArray*) queryAllFoodFromDataBase;

-(void) presistType:(NSString*) type success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
-(void) mergeType:(NSString*) type oldType:(NSString*) oldType  success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
-(void) removeType:(NSString*) type success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;

-(void) presistFood:(EntityFood*) food success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
-(void) mergeFood:(EntityFood*) type success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
-(void) removeFood:(EntityFood*) food success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;






@end
