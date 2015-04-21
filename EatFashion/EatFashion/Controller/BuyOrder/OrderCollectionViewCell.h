//
//  OrderCollectionViewCell.h
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-13.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityFood.h"

@interface OrderCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) EntityFood *food;
@property (nonatomic) int orderNum;
@end
