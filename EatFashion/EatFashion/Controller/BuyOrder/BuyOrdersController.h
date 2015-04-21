//
//  BuyOrdersController.h
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-14.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ShiShangController.h"

extern NSString *const KeyBuyOrderDeskNum;
extern NSString *const KeyOrderHeadImage;

extern NSString *const KeyDatas;

@interface BuyOrdersController : ShiShangController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSMutableArray *arrayHead;
-(void) reloadData;
@end
