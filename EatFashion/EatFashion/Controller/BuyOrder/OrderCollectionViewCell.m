//
//  OrderCollectionViewCell.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-13.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "OrderCollectionViewCell.h"
#import "Common+Expand.h"
#import "EntityFood.h"
UIColor *ColorCellBackground;




@interface OrderCollectionViewCell()
@property (strong, nonatomic) IBOutlet UILabel *lableName;
@property (strong, nonatomic) IBOutlet UILabel *lablePrice;
@property (strong, nonatomic) IBOutlet UILabel *lableOrderNum;
@property (strong, nonatomic) IBOutlet AsyncImageView *imageViewOrder;
@end
@implementation OrderCollectionViewCell
+(void) initialize{
    ColorCellBackground = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
}
- (void)awakeFromNib {
    [_lableOrderNum setCornerRadiusAndBorder:_lableOrderNum.frameHeight/2 BorderWidth:0 BorderColor:nil];
    self.backgroundColor = ColorCellBackground;
}
-(void) setFood:(EntityFood *)food{
    _food = food;
    _imageViewOrder.imageUrl = _food.pricturePath;
    _lableName.text = _food.name;
    _lablePrice.text = [NSString stringWithFormat:@"￥%@",_food.price.stringValue];
    
    _lablePrice.frameWidth = _lableName.frameWidth = self.frameWidth;
    _lableName.frameX = _lablePrice.frameX = 0;
    _lablePrice.frameY = self.frameHeight-_lablePrice.frameHeight;
    [_lableName automorphismHeight];
    CGRect r = _lableName.frame;
    r.origin.y = self.frame.size.height-r.size.height-_lablePrice.frame.size.height;
    _lableName.frame = r;
    [_lableName autoresizingMask_BLR];
    [_lablePrice autoresizingMask_BLR];
    
    
    
}
-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGRect r = _imageViewOrder.frame;
    r.origin.x = r.origin.y = 0;
    r.size = frame.size;
    _imageViewOrder.frame = r;
    
    r = _lablePrice.frame;
    r.size.width = frame.size.width;
    r.origin.y = frame.size.height-r.size.height;
    _lablePrice.frame = r;
    
    r = _lableName.frame;
    r.size.width = frame.size.width;
    r.origin.y = frame.size.height-r.size.height-_lablePrice.frame.size.height;
    _lableName.frame = r;
}
-(void) setOrderNum:(int)orderNum{
    _orderNum= orderNum;
    NSString *arg = @"";
    if (_orderNum>0) {
        [self.lableOrderNum setHidden:NO];
        arg = [NSString stringWithFormat:@"%d",_orderNum];
        self.lableOrderNum.text = arg;
    }else{
        [self.lableOrderNum setHidden:YES];
    }
}

@end
