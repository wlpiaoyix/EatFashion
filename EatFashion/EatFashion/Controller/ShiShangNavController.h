//
//  ShiShangNavController.h
//  ShiShang
//
//  Created by wlpiaoyi on 14/12/27.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "SkinDictionary.h"
#import "VertivalController.h"
#import "Common+Expand.h"


extern float navigationBarHeight;

@interface ShiShangNavController : VertivalController
@property (nonatomic,assign,readonly) SkinDictionary *dicskin;

@end
