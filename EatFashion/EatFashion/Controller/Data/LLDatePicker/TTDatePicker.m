//
//  TTDatePicker.m
//  TTDatePicker
//
//  Created by torin on 15/1/4.
//  Copyright (c) 2015年 tt_lin. All rights reserved.
//

#import "TTDatePicker.h"
#import "Common.h"
#define TEXT_COLOR [UIColor colorWithWhite:0.5 alpha:1.0]
#define BAR_SEL_COLOR [UIColor colorWithRed:76.0f/255.0f green:172.0f/255.0f blue:239.0f/255.0f alpha:0.8]

#define SrcName(file) [@"TTDatePicker.bundle" stringByAppendingPathComponent:file]

@interface TTDatePicker()

@property (nonatomic, strong) UIButton *dateButton;
@property (nonatomic, strong) UIButton *btPrev;
@property (nonatomic, strong) UIButton *btNext;
@property (nonatomic, assign) id target;
@property (nonatomic) SEL action;

@end

@implementation TTDatePicker

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dateButton.frame = CGRectMake(30., 0., 150., 44.0);
    [_dateButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [_dateButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_dateButton.titleLabel setFont:[UIFont systemFontOfSize:24.]];
    [self addSubview:_dateButton];
    [_dateButton addTarget:self action:@selector(onclickDateSelected) forControlEvents:UIControlEventTouchUpInside];
    
    _btPrev = [[UIButton alloc] initWithFrame:CGRectMake(0.,7.0, 30.0, 30.0)];
    [_btPrev setImage:[UIImage imageNamed:SrcName(@"left_date_arrow_blue")] forState:UIControlStateNormal];
    _btPrev.contentMode = UIViewContentModeCenter;
    [_btPrev setTitleColor:BAR_SEL_COLOR forState:UIControlStateNormal];
    [_btPrev addTarget:self action:@selector(switchToDayPrev) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btPrev];
     
    _btNext = [[UIButton alloc] initWithFrame:CGRectMake(_dateButton.frameWidth+30., 7.0, 30.0, 30.0)];
    [_btNext setImage:[UIImage imageNamed:SrcName(@"right_date_arrow_blue")] forState:UIControlStateNormal];
    _btNext.contentMode = UIViewContentModeCenter;
    [_btNext setTitleColor:BAR_SEL_COLOR forState:UIControlStateNormal];
    [_btNext addTarget:self action:@selector(switchToDayNext) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btNext];
    
    _selectedDate = [NSDate date];
    [self switchToDay:0];
    self.frameY = 0;
    
}
-(void) setFrame:(CGRect)frame{
    frame.size.width = _btNext.frameSize.width+_btNext.frameX;
    frame.size.height = _dateButton.frameHeight;
    [super setFrame:frame];
}

- (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}
-(void) onclickDateSelected{
    if (_target&&_action&&[_target respondsToSelector:_action]) {
        
        [_target performSelector:_action withObject:self];
    }
}
-(void) addTarget:(id) target action:(SEL)action{
    _target = target;
    _action = action;
}

- (void)switchToDay:(NSInteger)dayOffset {
    
//    NSCalendar *gregorian = [[NSCalendar alloc] init];
//    NSDateComponents *offsetComponents = [NSDateComponents new];
    NSDate *newDate = [self.selectedDate?self.selectedDate:[NSDate date] offsetDay:(int)dayOffset];
    self.selectedDate = newDate;
    if ([_delegate respondsToSelector:@selector(switchToDay:)]) {
        [_delegate switchToDay:_selectedDate];
    }
}

-(void) setSelectedDate:(NSDate *)selectedDate{
    _selectedDate = selectedDate;
    [_dateButton setTitle:[self stringFromDate:_selectedDate withFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
}

- (void)switchToDayPrev
{
    [self switchToDay:-1];
}

- (void)switchToDayNext
{
    [self switchToDay:1];
}

@end
