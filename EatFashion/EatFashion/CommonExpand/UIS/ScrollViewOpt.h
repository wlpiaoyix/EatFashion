//
//  ScrollViewOpt.h
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-7.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VIEWTAGSET 134123455

typedef int (^CallBackScrollEnd)(int showIndex,id userInfo);


@interface ScrollViewOpt : UIScrollView<UIScrollViewDelegate>{
@protected
    NSMutableArray *views;
}
@property (nonatomic) int showIndex;
@property (nonatomic,strong) id userInfo;
@property (nonatomic, readonly) int totalCount;
-(void) addSubviews:(NSArray*) views;
-(void) removeAllViews;
-(void) setCallBackScrollEnd:(CallBackScrollEnd) callBack;
@end
