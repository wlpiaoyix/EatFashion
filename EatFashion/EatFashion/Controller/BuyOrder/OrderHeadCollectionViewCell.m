//
//  OrderHeadCollectionViewCell.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-15.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "OrderHeadCollectionViewCell.h"
#import "EntityFood.h"
@interface OrderHeadCollectionViewCell()
@property (strong, nonatomic) IBOutlet UILabel *lableCategory;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *imageView02;
@end

@implementation OrderHeadCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void) addSubview:(UIView *)view{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_bg02.png"]];
        _imageView02 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_bg03.png"]];
        [_imageView setCornerRadiusAndBorder:5 BorderWidth:0 BorderColor:[UIColor clearColor]];
//        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        //        [_imageView02 setContentMode:UIViewContentModeScaleAspectFill];
        [super addSubview:_imageView];
        [super addSubview:_imageView02];
    }
    [super addSubview:view];
}
-(void) setParam:(id)value forKey:(NSString *)key{
    if (key&&[key isEqualToString:KeyFoodType]) {
        _lableCategory.text = value;
        
        CGSize size = _lableCategory.frameSize;
        size.width = 999;
        size.width = [Utils getBoundSizeWithTxt:_lableCategory.text font:_lableCategory.font size:size].width;
        size.width += _lableCategory.frameX*2;
        _imageView.frameX = 0;
        _imageView.frameY = _lableCategory.frameY;
        _imageView.frameSize = size;
        _imageView02.frameX = 0;
        _imageView02.frameHeight = 4;
        _imageView02.frameWidth = self.frameWidth;
        _imageView02.frameY = _imageView.frameY+_imageView.frameHeight-_imageView02.frameHeight;
        [_imageView02 autoresizingMask_BLR];
    }
}
-(void) setParams:(NSDictionary*) json{
    for (NSString *key in [json allKeys]) {
        id value = [json objectForKey:key];
        [self setParam:value forKey:key];
    }
}

@end
