//
//  Button+Param.m
//  wanxuefoursix
//
//  Created by wlpiaoyi on 14-10-31.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "Common.h"
#import "GraphicsContext.h"
#import "Utils.h"

@implementation UIButton(Expand)
-(void) addTarget:(id) target action:(SEL) action{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
-(void) setTitleImage:(NSString *)title forState:(UIControlState)state{
    NSString *fontName = self.titleLabel.font.fontName;
    int pxv = 2;
    float size = self.titleLabel.font.pointSize*pxv;
    UIFont *font = [UIFont fontWithName:fontName size:size];
    float width = [Utils getBoundSizeWithTxt:title font:font size:CGSizeMake(999, size)].width;
    CGContextRef cxt =  [GraphicsContext drawImageStart:CGRectMake(0, 0, self.frame.size.width*pxv, self.frame.size.height*pxv) fillColor:[[UIColor clearColor] CGColor]];
    [GraphicsContext drawText:cxt Text:title Font:font Point:CGPointMake((self.frame.size.width*pxv-width)/2, (self.frame.size.height*pxv-size*1.25)/2) TextColor:[self titleColorForState:state]];
    UIImage*image = [GraphicsContext drawImgeEnd:cxt];
    [self setContentMode:UIViewContentModeScaleAspectFit];
    [self setImage:image forState:state];
}
-(void) setTitle:(NSString*) title image:(UIImage*) image forState:(UIControlState)state {
    [self setTitle:title image:image forState:state offset:UIButtonImageTextOffsetMake(0, 0, 0)];
}

/**
 图片文字纵向显示
 */
-(void) setTitle:(NSString*) title image:(UIImage*) image forState:(UIControlState)state offset:(UIButtonImageTextOffset) offset{
    
    [self setImage:image forState:state];
    [self setTitle:title forState:state];
    
    CGSize sizeimage = image.size;
    CGSize sizetitle = [Utils getBoundSizeWithTxt:title font:self.titleLabel.font size:CGSizeMake(999, sizeimage.height)];
    sizetitle.height = [Utils getBoundSizeWithTxt:title font:self.titleLabel.font size:CGSizeMake(sizetitle.width, 999)].height;
    CGSize sizeimagetitle = CGSizeMake(sizeimage.width+sizetitle.width, sizeimage.height);
    
    CGPoint pointimage;
    pointimage.x = (sizeimagetitle.width-sizeimage.width)/2;
    pointimage.y = -sizetitle.height/2;
    CGPoint pointtitle;
    pointtitle.x = (sizeimagetitle.width-sizetitle.width)/2 - sizeimage.width;
    pointtitle.y = sizeimage.height+pointimage.y-(sizeimagetitle.height-sizetitle.height)/2;
    
    pointimage.x += offset.x;
    pointimage.y += offset.y;
    pointtitle.x += offset.x;
    pointtitle.y += offset.y;
    pointtitle.y += offset.h;
    
    pointimage.x *=2;
    pointimage.y *=2;
    pointtitle.x *=2;
    pointtitle.y *=2;
    [self setImageEdgeInsets:UIEdgeInsetsMake(pointimage.y, pointimage.x, 0, 0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(pointtitle.y, pointtitle.x, 0, 0)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
