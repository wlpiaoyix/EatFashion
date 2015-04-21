//
//  ManagerHeadCell.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/21.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ManagerHeadCell.h"
#import "Common.h"

@interface ManagerHeadCell()

@property (strong, nonatomic) IBOutlet UILabel *lableFoodType;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ManagerHeadCell

- (void)awakeFromNib {
    // Initialization code
}
-(void) addSubview:(UIView *)view{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_bg01.png"]];
        [_imageView setCornerRadiusAndBorder:5 BorderWidth:0 BorderColor:[UIColor clearColor]];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [super addSubview:_imageView];
    }
    [super addSubview:view];
}

-(void) setFoodType:(NSString *)foodType{
    _foodType = foodType;
    _lableFoodType.text = _foodType;
    CGSize size = _lableFoodType.frameSize;
    size.width = 999;
    size.width = [Utils getBoundSizeWithTxt:_foodType font:_lableFoodType.font size:size].width;
    size.width += _lableFoodType.frameX*2;
    _imageView.frameX = 0;
    _imageView.frameY = _lableFoodType.frameY;
    _imageView.frameSize = size;
}

@end
