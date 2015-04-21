//
//  EntityUser.h
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/22.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDObject.h"


extern NSString *const KeyUserId;
extern NSString *const KeyUserShopId;
extern NSString *const KeyUserShopName;
extern NSString *const KeyUserName;
extern NSString *const KeyUserLoginName;
extern NSString *const KeyUserPlainPassword;
extern NSString *const KeyUserPassword;
extern NSString *const KeyUserSalt;
extern NSString *const KeyUserRoles;
extern NSString *const KeyUserRegisterDate;
extern NSString *const KeyUserPhoneNumber;
extern NSString *const KeyUserVoucher;
extern NSString *const KeyUserBalance;
extern NSString *const KeyUserTotalConsumed;


@interface EntityUser : NSObject<ProtocolEntity>
@property NSNumber *keyId;
@property NSNumber *shopId;
@property NSString *shopName;
@property NSString *name;
@property NSString *loginName;
@property NSString *plainPassword;
@property NSString *password;
@property NSString *salt;//密钥
@property NSString *roles;//角色
@property NSString *registerDate;//注册时间
@property NSString *phoneNumber;//电话号码
@property NSNumber *voucher;//代金券
@property NSNumber *balance;//余额
@property NSNumber *totalConsumed;//总消费金额
+(instancetype) entityWithJson:(NSDictionary*) json;
-(NSMutableDictionary*) toJson;
@end
