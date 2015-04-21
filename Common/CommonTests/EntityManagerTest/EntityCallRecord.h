//
//  EntityCallRecord.h
//  TelSaleHelper
//
//  Created by wlpiaoyi on 15/1/7.
//  Copyright (c) 2015年 TelSaleHelper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

typedef NS_ENUM(NSInteger, EnumEntityRecordStatus) {
    EnumEntityRecordStatusNoUse = 0,
    EnumEntityRecordStatusOrdered = 1,
    EnumEntityRecordStatusNormal   = 2,
    EnumEntityRecordStatusUrgency  = 3,
    EnumEntityRecordStatusUrgencier   = 4
};

@interface EntityCallRecord : NSObject<ProtocolEntity,ProtocolObjectJson>
@property (nonatomic,strong) NSNumber *keyId;
@property (nonatomic,strong) NSNumber *contentId;
@property (nonatomic,strong) NSNumber *userId;
@property (nonatomic,strong) NSNumber *shopId;
@property (nonatomic,strong) NSString *shopName;
@property (nonatomic,strong) NSNumber *status;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSNumber *callTime;
@property (nonatomic,strong) NSString *orderTime;
@property (nonatomic,strong) NSNumber *isSyn;
@end

NSString* getEnumEntityCallRecordStaus(EnumEntityRecordStatus _enum_);