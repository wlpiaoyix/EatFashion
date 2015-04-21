//
//  ManagerOptCell.h
//  ShiShang
//
//  Created by wlpiaoyi on 14/12/10.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBackManagerOptReturn)(NSString *foodType);

@interface ManagerOptCell : UICollectionViewCell
@property (nonatomic,strong) NSString *foodType;
-(void) setCallBackManagerOptReturn:(CallBackManagerOptReturn) callback;

@end
