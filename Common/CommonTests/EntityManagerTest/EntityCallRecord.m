//
//  EntityCallRecord.m
//  TelSaleHelper
//
//  Created by wlpiaoyi on 15/1/7.
//  Copyright (c) 2015年 TelSaleHelper. All rights reserved.
//

#import "EntityCallRecord.h"

@implementation EntityCallRecord

+(NSString*) getKey{
    return @"keyId";
}
+ (NSArray*) getColums{
    return @[@"contentId",@"userId",@"shopId",@"shopName",@"status",@"remark",@"callTime",@"orderTime",@"isSyn"];
}
+(NSString*) getTable{
    return @"EntityCallRecord";
}
+ (NSArray*) getJsonKeys{
    return @[@"userId",@"status",@"remark",@"contentId",@"orderTime",@"shopName",@"isSyn",@"keyId"];
}
@end

NSString* getEnumEntityCallRecordStaus(EnumEntityRecordStatus _enum_){
    NSString *result;
    switch (_enum_) {
        case EnumEntityRecordStatusNormal:
        {
            result = @"一般";
        }
        case EnumEntityRecordStatusOrdered:
        {
            result = @"已下单";
        }
            break;
            break;
        case EnumEntityRecordStatusUrgency:
        {
            result = @"急";
        }
            break;
        case EnumEntityRecordStatusUrgencier:
        {
            result = @"紧急";
        }
            break;
            
        default:{
            result = @"无用";
        }
            break;
    }
    return result;
}
