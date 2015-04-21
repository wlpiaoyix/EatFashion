//
//  EntityMessage.h
//  ShiShang
//
//  Created by wlpiaoyi on 15/1/17.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "Common.h"

@interface EntityMessage : NSObject<ProtocolObjectJson>

@property(nonatomic,strong) NSNumber *applicantId;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSNumber *shopId;
@property(nonatomic,strong) NSString *applyStatus;
@end
