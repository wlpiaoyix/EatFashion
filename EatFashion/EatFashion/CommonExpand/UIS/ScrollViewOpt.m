//
//  ScrollViewOpt.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-7.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ScrollViewOpt.h"
#import "Common+Expand.h"

@implementation ScrollViewOpt{
    id synaddviews;
    CallBackScrollEnd  callBackScrollEnd;
}
-(id) init{
    if (self=[super init]) {
        [self initParams];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self initParams];
    }
    return self;

}

-(id) initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initParams];
    }
    return self;

}

-(void) initParams{
    views = [NSMutableArray new];
    self.contentSize = CGSizeMake(0, 0);
    self.pagingEnabled = YES;
    self.scrollEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.alwaysBounceHorizontal = NO;
    self.alwaysBounceVertical = NO;
    synaddviews = [NSObject new];
    self.delegate = self;
//    self.frame = CGRectMake(0, 0, APP_W, APP_H);
}

-(void) addSubview:(UIView *)view{
    @synchronized(synaddviews){
        if (view.tag==VIEWTAGSET) {
            [super addSubview:view];
            return;
        }
        _totalCount = (int)[views count];
        [view removeFromSuperview];
        CGRect r = view.frame;
        r.size = view.frame.size;
        r.origin.y = 0;
        r.origin.x = r.size.width*_totalCount;
        view.frame = r;
        [view autoresizingMask_TBLRWH];
        _totalCount ++;
        [views addObject:view];
        CGSize s = self.frame.size;
        s.width = 0;
        for (UIView *view in views) {
            s.width+=view.frame.size.width;
        }
        self.contentSize = s;
        [super addSubview:view];
    }
}

-(void) removeAllViews{
    self.contentOffset = CGPointMake(0, 0);
    self.contentSize = self.frame.size;
    _totalCount = 0;
    _showIndex = 0;
    for (UIView *view in self.subviews) {
        if (view.tag==VIEWTAGSET) {
            continue;
        }
        [view removeFromSuperview];
    }
    [views removeAllObjects];
}
-(void) addSubviews:(NSArray*) _views{
    [self removeAllViews];
    self.userInteractionEnabled = YES;
    for (UIView *subview in self.subviews) {
        if (subview.tag==VIEWTAGSET) {
            continue;
        }
        [subview removeFromSuperview];
    }
    for (UIView *view in _views) {
        [self addSubview:view];
    }
    
}
-(void) setCallBackScrollEnd:(CallBackScrollEnd) callBack{
    callBackScrollEnd = callBack;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _showIndex = scrollView.contentOffset.x/self.frame.size.width;
    if (callBackScrollEnd)callBackScrollEnd(_showIndex,_userInfo);
}
-(void) setShowIndex:(int)showIndex{
    _showIndex = (int)MIN(showIndex, [views count]-1);
    UIView *view = [views objectAtIndex:_showIndex];
    //如果view在显示范围之内就返回了
    if (view.frame.origin.x>=self.contentOffset.x&&view.frame.origin.x<self.contentOffset.x+self.frame.size.width) {
        return;
    }
    
    CGPoint contentOffset = CGPointMake(_showIndex*((UIView*)[views firstObject]).frame.size.width, 0);
    if (contentOffset.x>=self.frame.size.width) {
        contentOffset.x -= self.frame.size.width;
        contentOffset.x += ((UIView*)[views firstObject]).frame.size.width;
    }
    [self setContentOffset:contentOffset animated:YES];
}
-(void) setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated{
    [super setContentOffset:contentOffset animated:animated];
}
-(void) setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
