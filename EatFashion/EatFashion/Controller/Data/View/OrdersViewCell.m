//
//  OrdersViewCell.m
//  Data
//
//  Created by torin on 14/11/15.
//  Copyright (c) 2014年 tt_lin. All rights reserved.
//

#import "OrdersViewCell.h"
#import "EntityOrder.h"

@interface OrdersViewCell()
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *quantity;

@end


@implementation OrdersViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (instancetype)settingCellWithTableView:(UITableView *)tableView
{
    
    static NSString *ID = @"orderCell";
    
    OrdersViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrdersViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat margin = 15;
    CGFloat w = [UIScreen mainScreen].applicationFrame.size.width;
    CGRect rect = self.frame;
    rect.origin.x = margin;
    rect.size.width = w - margin * 2;
    self.frame = rect;
}

-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.goodsName.text = dict[KeyOrderProductName];
    NSString *price = [NSString stringWithFormat:@"¥ %@/份",dict[KeyOrderProductPrice]];
    self.price.text = price;
    self.quantity.text = [NSString stringWithFormat:@"%@",dict[KeyOrderAmount]];
}
@end
