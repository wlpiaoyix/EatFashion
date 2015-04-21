//
//  OrdersViewCell.h
//  Data
//
//  Created by torin on 14/11/15.
//  Copyright (c) 2014年 tt_lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersViewCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *dict;

+ (instancetype)settingCellWithTableView:(UITableView *)tableView;
@end
