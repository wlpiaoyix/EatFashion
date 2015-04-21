//
//  BuyOrderMenuCell.h
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-16.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityFood.h"

typedef void (^CallBackBuyOrderMenuCellOnclick) (EntityFood *params);
@interface BuyOrderMenuCell : UITableViewCell
@property (nonatomic,strong) EntityFood *food;
-(void) setCallBackBuyOrderMenuCellOnclick:(CallBackBuyOrderMenuCellOnclick) callBack;
@end
