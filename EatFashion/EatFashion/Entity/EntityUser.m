//
//  EntityUser.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/22.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "EntityUser.h"

NSString *const KeyUserId = @"id";
NSString *const KeyUserShopId = @"shopID";
NSString *const KeyUserShopName = @"shopName";
NSString *const KeyUserName = @"name";
NSString *const KeyUserLoginName  = @"loginName";
NSString *const KeyUserPlainPassword = @"plainPassword";
NSString *const KeyUserPassword = @"password";
NSString *const KeyUserSalt = @"salt";
NSString *const KeyUserRoles = @"roles";
NSString *const KeyUserRegisterDate = @"registerDate";
NSString *const KeyUserPhoneNumber = @"phoneNumber";
NSString *const KeyUserVoucher = @"voucher";
NSString *const KeyUserBalance = @"balance";
NSString *const KeyUserTotalConsumed = @"totalConsumed";

@implementation EntityUser
+(instancetype) entityWithJson:(NSDictionary*) json{
    EntityUser *user = [EntityUser new];
    user.keyId = [json objectForKey:KeyUserId];
    user.shopId = [json objectForKey:KeyUserShopId];
    user.shopName = [json objectForKey:KeyUserShopName];
    user.name = [json objectForKey:KeyUserName];
    user.loginName = [json objectForKey:KeyUserLoginName];
    user.plainPassword = [json objectForKey:KeyUserPlainPassword];
    user.password = [json objectForKey:KeyUserPassword];
    user.salt = [json objectForKey:KeyUserSalt];
    user.roles = [json objectForKey:KeyUserRoles];
    user.registerDate = [json objectForKey:KeyUserRegisterDate];
    user.phoneNumber = [json objectForKey:KeyUserPhoneNumber];
    user.voucher = [json objectForKey:KeyUserVoucher];
    user.balance = [json objectForKey:KeyUserBalance];
    user.totalConsumed = [json objectForKey:KeyUserTotalConsumed];
    return user;
}
-(NSMutableDictionary*) toJson{
    NSMutableDictionary *json = [NSMutableDictionary new];
    if(self.keyId)[json setObject:self.keyId forKey:KeyUserId];
    if(self.shopId)[json setObject:self.keyId forKey:KeyUserShopId];
    if(self.shopName)[json setObject:self.keyId forKey:KeyUserShopName];
    if(self.name)[json setObject:self.name forKey:KeyUserName];
    if(self.loginName)[json setObject:self.loginName forKey:KeyUserLoginName];
    if(self.plainPassword)[json setObject:self.plainPassword forKey:KeyUserPlainPassword];
    if(self.password)[json setObject:self.password forKey:KeyUserPassword];
    if(self.salt)[json setObject:self.salt forKey:KeyUserSalt];
    if(self.roles)[json setObject:self.roles forKey:KeyUserRoles];
    if(self.registerDate)[json setObject:self.registerDate forKey:KeyUserRegisterDate];
    if(self.phoneNumber)[json setObject:self.phoneNumber forKey:KeyUserPhoneNumber];
    if(self.voucher)[json setObject:self.voucher forKey:KeyUserVoucher];
    if(self.balance)[json setObject:self.balance forKey:KeyUserBalance];
    if(self.totalConsumed)[json setObject:self.totalConsumed forKey:KeyUserTotalConsumed];
    return json;
}
-(void) setShopId:(NSNumber *)shopId{
    _shopId = shopId;
}

+(NSString*) getKey{
    return @"keyId";
}
+ (NSArray*) getColums{
    return [NSArray arrayWithObjects:@"name",@"loginName",@"plainPassword",@"password",@"salt",@"roles",@"registerDate",@"phoneNumber",@"voucher",@"balance",@"totalConsumed",nil];
}
+(long long int) getTypes{
    return 133333333111;
}
+(NSString*) getTable{
    return @"EntityUser";
}

@end
