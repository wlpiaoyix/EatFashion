//
//  ManagerController.h
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/21.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ShiShangController.h"

extern NSString *const KeyManagerId;
extern NSString *const KeyManagerCategory;
extern NSString *const KeyManagerName;

@interface ManagerController : ShiShangController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray *arrayData;
-(void) reloadData;
@end
