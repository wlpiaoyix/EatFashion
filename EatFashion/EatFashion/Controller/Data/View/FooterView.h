//
//  FooterView.h
//  Data
//
//  Created by torin on 14/11/20.
//  Copyright (c) 2014年 tt_lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FooterViewDelegate <NSObject>

- (void)cancelOrder:(NSInteger)section;

@end

@interface FooterView : UIView
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,assign) NSInteger section;

@property (nonatomic,weak) id<FooterViewDelegate> delegate;
@end
