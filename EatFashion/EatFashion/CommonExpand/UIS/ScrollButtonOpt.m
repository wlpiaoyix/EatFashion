//
//  ScrollButtonOpt.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-7.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "GraphicsContext.h"

#import "ScrollButtonOpt.h"
#import "Common+Expand.h"

@interface UIButtonTitleImage:UIButton{
}
@end
@implementation ScrollButtonOpt{
@private
    UIImageView *imageViewFloa;
    UIImageView *imagebg;
    CallBackScrollEnd callBackScrollEnd;
}

-(id) init{
    if (self = [super init]) {
        _normaltextColor = [UIColor whiteColor];
        _selectedtextColor = [UIColor yellowColor];
        imageViewFloa = [UIImageView new];
        imageViewFloa.image = [UIImage imageWithColor:[UIColor clearColor]];
        imageViewFloa.tag = VIEWTAGSET;
        imagebg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bar_bg.png"]];
        [imagebg setContentMode:UIViewContentModeScaleToFill];
        [imagebg autoresizingMask_TLR];
        self.pagingEnabled = NO;
    }
    return self;
}
-(void) addSubview:(UIView *)view{
    if ([view isKindOfClass:[UIButton class]]) {
        [super addSubview:view];
    }
}
-(void) addSubviews:(NSArray*) _views{
    NSMutableArray *arrayViews = [NSMutableArray arrayWithArray:_views];
    NSMutableArray *removeViews = [NSMutableArray new];
    for (UIView *view in arrayViews) {
        if (![view isKindOfClass:[UIButton class]]) {
            [removeViews addObject:view];
        }
    }
    [arrayViews removeObjectsInArray:removeViews];
    [super addSubviews:arrayViews];
}
-(void) setValues:(NSArray *)values{
    _values = values;
    if (!_values||![_values count]) {
        return;
    }
    CGRect r;
    r.origin = CGPointMake(0, 0);
    if ([_values count]>5) {
        r.size = CGSizeMake(self.frame.size.width/4.0f, self.frame.size.height);
    }else{
        r.size = CGSizeMake(self.frame.size.width/[_values count], self.frame.size.height);
    }
    imageViewFloa.frame = r;
    NSMutableArray *buttons = [NSMutableArray new];
    for (id value  in _values) {
        UIButton *b;
        UIImage *imagenormal;
        UIImage *imageSelected;
        NSString *title;
        if ([value isKindOfClass:[NSString class]]) {
            b = [UIButton new];
            b.frame = r;
            imagenormal = [self getButtonImageByTitle:value fontName:[UIFont systemFontOfSize:1].fontName fontSize:b.frame.size.height/2 color:_normaltextColor size:b.frame.size];
            imageSelected = [self getButtonImageByTitle:value fontName:[UIFont boldSystemFontOfSize:1].fontName  fontSize:b.frame.size.height/2 color:_selectedtextColor size:b.frame.size];
        }else if([value isKindOfClass:[NSDictionary class]]){
            b = [UIButtonTitleImage new];
            b.frame = r;
            imagenormal = [UIImage imageNamed:[value objectForKey:@"normal"]];
            imageSelected = [UIImage imageNamed:[value objectForKey:@"selected"]];
            title = [value objectForKey:@"title"];
            
            imagenormal = [UIImage imageWithCGImage:[imagenormal CGImage] scale:imagenormal.size.height/20 orientation: UIImageOrientationUp];
            imageSelected = [UIImage imageWithCGImage:[imageSelected CGImage] scale:imageSelected.size.height/20 orientation: UIImageOrientationUp];
        }
        [b.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [b setContentMode:UIViewContentModeCenter];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [b setTitle:title image:imagenormal forState:UIControlStateNormal offset:UIButtonImageTextOffsetMake(0, 2, 2)];
        [b setTitle:title image:imageSelected forState:UIControlStateSelected offset:UIButtonImageTextOffsetMake(0, 2, 2)];
        [b setContentMode:UIViewContentModeScaleAspectFit];
//        [b setCornerRadiusAndBorder:1 BorderWidth:1 BorderColor:[UIColor redColor]];
//        [b setImage:imagenormal forState:UIControlStateNormal];
//        [b setImage:imageSelected forState:UIControlStateSelected];
//        [b setTitle:title forState:UIControlStateNormal];
        [buttons addObject:b];
        b.selected = NO;
        b.backgroundColor = [UIColor clearColor];
        [b addTarget:self action:@selector(onclickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    [imageViewFloa removeFromSuperview];
    [super addSubview:imageViewFloa];
    [self addSubviews:buttons];
    [imagebg removeFromSuperview];
    imagebg.tag = VIEWTAGSET;
    [super addSubview:imagebg];
}
-(UIImage*) getButtonImageByTitle:(NSString*) title fontName:(NSString*) fontName fontSize:(float) fontSize color:(UIColor*) color size:(CGSize) size{
    int pxv = 2;
    float fs = fontSize*pxv;
    float fh = [Utils getFontHeightWithSize:fs fontName:fontName]*0.85;
    UIFont *font = [UIFont fontWithName:fontName size:fs];
    float width = [Utils getBoundSizeWithTxt:title font:font size:CGSizeMake(999, fh)].width;
    CGRect rectcxt = CGRectMake(0, 0, size.width*pxv, size.height*pxv);
    CGPoint pointg = CGPointMake((size.width*pxv-width)/2, (size.height*pxv-fh)/2);
    
    CGContextRef cxt =  [GraphicsContext drawImageStart:rectcxt fillColor:[[UIColor clearColor] CGColor]];
    [GraphicsContext drawText:cxt Text:title Font:font Point:pointg TextColor:color];
    UIImage*image = [GraphicsContext drawImgeEnd:cxt];
    return image;
}

- (void) onclickButton:(id) sender{
    int index = 0;
    for (UIButton *button in views) {
        if (button == sender) {
            break;
        }
        index++;
    }
    self.showIndex = index;
}
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [super scrollViewDidEndDecelerating:scrollView];
}
-(void) setShowIndex:(int)showIndex{
    [super setShowIndex:showIndex];
    UIButton *b = [views objectAtIndex:super.showIndex];
    for (UIButton *button in views) {
        button.selected = NO;
    }
    b.selected = YES;
    [UIView animateWithDuration:0.2 animations:^{
        float avg = (self.frame.size.width/MIN([_values count], 4));
        CGPoint p = CGPointMake(super.showIndex*avg, 0);
        CGRect r = imageViewFloa.frame;
        r.origin = p;
        imageViewFloa.frame = r;
        if (callBackScrollEnd) {
            callBackScrollEnd(super.showIndex,nil);
        }
    }];
}
-(void) setCallBackScrollEnd:(CallBackScrollEnd)callBack{
    callBackScrollEnd = callBack;
}

-(void) setImageBg:(UIImage *)imageBg{
    _imageBg = imageBg;
    imageViewFloa.image = imageBg;
    imageViewFloa.backgroundColor = [UIColor clearColor];
}
-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    frame.size.height *=0.1;
    frame.origin = CGPointMake(0, 0);
    imagebg.frame = frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation UIButtonTitleImage

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
-(CGRect) contentRectForBounds:(CGRect)bounds{
    CGRect rect = bounds;
    rect.size.width = bounds.size.width*2;
    rect.origin.x = -bounds.size.width/2;
    return rect;
}

@end
