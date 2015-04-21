//
//  TTDatePicker.h
//  TTDatePicker
//
//  Created by torin on 15/1/4.
//  Copyright (c) 2015年 tt_lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTDatePickerDelegate <NSObject>

- (void)switchToDay:(NSDate *)date;

@end

@interface TTDatePicker : UIView
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic ,assign) id<TTDatePickerDelegate> delegate;
-(void) addTarget:(id) target action:(SEL)action;
@end
