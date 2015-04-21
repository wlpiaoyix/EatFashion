//
//  ShiShangDataPickerView.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/12/27.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ShiShangDataPickerView.h"
#import "UIView+Expand.h"
#import "NSDate+Expand.h"
#import "UIButton+Expand.h"

@interface ShiShangDataPickerView()
@property (strong, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (strong, nonatomic) IBOutlet UILabel *weekValue;
@property (strong, nonatomic) IBOutlet UILabel *monthValue;
@property (strong, nonatomic) IBOutlet UILabel *yearValue;
@property (strong, nonatomic) IBOutlet UILabel *dayValue;
@property (strong, nonatomic) IBOutlet UIButton *buttonConfirm;

@end

@implementation ShiShangDataPickerView
@synthesize date;
- (void)awakeFromNib {
    [_dataPicker addTarget:self action:@selector(onDataPickerChange:) forControlEvents:UIControlEventValueChanged ];
    [self setDate:[NSDate date]];
    [self setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
    [self.buttonConfirm setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [self.buttonConfirm setCornerRadiusAndBorder:5 BorderWidth:0 BorderColor:nil];
}

-(void) setDate:(NSDate *) _date_{
    date = _date_;
    _dataPicker.date = date;
    [self setDateShow:date];
}
-(NSDate*) date{
    date = _dataPicker.date;
    return date;
}

-(void) onDataPickerChange:(id) sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    [self setDateShow:control.date];
    
}

-(void) setDateShow:(NSDate*) date{
    _dayValue.text = [NSString stringWithFormat:@"%i",[date day]];
    _yearValue.text = [NSString stringWithFormat:@"%i",[date year]];
    switch ([date weekday]-1) {
        case 0:{
            _weekValue.text = @"星期日";
        }
            break;
        case 1:{
            _weekValue.text = @"星期一";
        }
            break;
        case 2:{
            _weekValue.text = @"星期二";
        }
            break;
        case 3:{
            _weekValue.text = @"星期三";
        }
            break;
        case 4:{
            _weekValue.text = @"星期四";
        }
            break;
        case 5:{
            _weekValue.text = @"星期五";
        }
            break;
            
        default:{
            _weekValue.text = @"星期六";
        }
            break;
    }
    
    switch ([date month]-1) {
        case 0:{
            _monthValue.text = @"一月";
        }
            break;
        case 1:{
            _monthValue.text = @"二月";
        }
            break;
        case 2:{
            _monthValue.text = @"三月";
        }
            break;
        case 3:{
            _monthValue.text = @"四月";
        }
            break;
        case 4:{
            _monthValue.text = @"五月";
        }
            break;
        case 5:{
            _monthValue.text = @"六月";
        }
            break;
        case 6:{
            _monthValue.text = @"七月";
        }
            break;
        case 7:{
            _monthValue.text = @"八月";
        }
            break;
        case 8:{
            _monthValue.text = @"九月";
        }
            break;
        case 9:{
            _monthValue.text = @"十月";
        }
            break;
        case 10:{
            _monthValue.text = @"十一月";
        }
            break;
            
        default:{
            _monthValue.text = @"十二月";
        }
            break;
    }
}
-(void) addTarget:(id) target action:(SEL)action{
    [self.buttonConfirm addTarget:target action:action];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
