//
//  StatisticViewController.m
//  Data
//
//  Created by torin on 14/11/15.
//  Copyright (c) 2014年 tt_lin. All rights reserved.
//
#import "Common+Expand.h"
#import "StatisticViewController.h"
#import "StatisticService.h"
#import "TTDatePicker.h"
#import "ShiShangDataPickerView.h"
#import "MJRefresh.h"
#import "MJRefreshConst.h"

static NSString *const KeyStatisCharSet = @"charSet";
static NSString *const KeyStatisPrice = @"price";
static NSString *const KeyStatisFlag = @"flag";

static NSString *const KeyStatisHeader = @"StatisHeader";
static NSString *const KeyStatisDetail = @"StatisDetail";

#define SectionHeaderHeight 30

@interface StatisticViewController ()<UITableViewDataSource,UITableViewDelegate,TTDatePickerDelegate>
{
    NSMutableArray *_datas;
    BOOL flagIsEndLoad;
}

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic,strong) TTDatePicker *datePicker;
@property (nonatomic, copy) NSString *time;
@property (strong, nonatomic) PopUpMovableView *movableView;
@property (strong, nonatomic) ShiShangDataPickerView *dp;
@end


@implementation StatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    flagIsEndLoad = true;
    //日期选择
    _datePicker = [[TTDatePicker alloc] init];
    _datePicker.delegate = self;
    [_datePicker setBackgroundColor:[UIColor whiteColor]];
    [_datePicker addTarget:self action:@selector(onclickShowTime)];
    [self.view addSubview:_datePicker];
    [_datePicker setSelectedDate:[NSDate date]];
    _datePicker.frameX = (appWidth()-_datePicker.frameWidth)/2;
    _datePicker.frameY = 0;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, CGRectGetMaxY(_datePicker.frame), self.view.frame.size.width, self.view.frame.size.height);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionHeaderHeight = SectionHeaderHeight;
    tableView.allowsSelection = NO;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    _datas = [NSMutableArray array];
    self.tableView = tableView;
    
    __weak typeof(self) weakself = self;
    [self.tableView addHeaderWithCallback:^{
        [weakself reloadData];
    }];
    [[ObserverListner getNewInstance] mergeWithTarget:self action:@selector(reloadData) arguments:nil key:NSStringFromClass([self class])];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.frameHeight = appHeight()-SSCON_TOP-SSCON_BUTTOM - SSCON_TIT;
    self.tableView.frameHeight = self.view.frameHeight-self.tableView.frameY;
    [self queryStatis:_datePicker.selectedDate];
}
-(void) onclickShowTime{
    _movableView = [PopUpMovableView new];
    ShiShangDataPickerView *dp = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ShiShangDataPickerView class]) owner:self options:nil].firstObject;
    [dp addTarget:self action:@selector(closePopUp)];
    [dp setDate:_datePicker.selectedDate];
    [_movableView setBackgroundColor:[UIColor clearColor]];
    [_movableView addSubview:dp];
    [_movableView setFlagTouchHidden:NO];
    __weak typeof(self) weaklself = self;
    [_movableView setBeforeClose:^(PopUpMovableView *vmv) {
        [weaklself.datePicker setSelectedDate:((ShiShangDataPickerView*)vmv.viewShow).date];
        [weaklself reloadData];
    }];
    [_movableView show];
}
-(void) closePopUp{
    [_movableView close];
}
-(void) reloadData{
    [self queryStatis:_datePicker.selectedDate];
}
- (void)queryStatis:(NSDate *)date
{
    @synchronized(self){
        if (!flagIsEndLoad) {
            return;
        }
        flagIsEndLoad = false;
        StatisticService *statisService = [StatisticService new];
        [Utils showLoading:@"正在加载统计信息..."];
        [statisService queryStatisForDate:date Success:^(id data, NSDictionary *userInfo) {
            [_datas removeAllObjects];
            if (data && ![data isEqualToString:@""]) {
                id json = [((NSString*)data) JSONValue];
                [self settingDatas:json];
            }
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            flagIsEndLoad = true;
            [Utils hiddenLoading];
        } faild:^(id data, NSDictionary *userInfo) {
            [self.tableView headerEndRefreshing];
            flagIsEndLoad = true;
            [Utils hiddenLoading];
        }];
    }
}

//拼接数据
- (void)settingDatas:(NSMutableArray *)data
{
    self.time = data[0][KeyStatisCharSet];
    [data insertObject:@{@"flag":@"title"} atIndex:data.count];
    NSUInteger count = data.count;
    NSMutableArray *tempArray;
    NSMutableDictionary *dict ;
    for (int i = 1; i < count; i++) {
        if ([@"title" isEqualToString:data[i][KeyStatisFlag]]) {
            if ( i != 1) {
                NSDictionary *childDict = @{KeyStatisDetail:tempArray};
                [dict addEntriesFromDictionary:childDict];
                [_datas addObject:dict];
            }
            if (data[i][KeyStatisCharSet]) {
                tempArray = [NSMutableArray array];
                dict = [NSMutableDictionary dictionaryWithObject:data[i][KeyStatisCharSet] forKey:KeyStatisHeader];
            }
        }else{
            [tempArray addObject:data[i]];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = _datas[section];
    NSArray *array = dict[KeyStatisDetail];
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = _datas[indexPath.section];
    NSArray *rowArray = dict[KeyStatisDetail];
    cell.textLabel.text = rowArray[indexPath.row][KeyStatisCharSet];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",rowArray[indexPath.row][KeyStatisPrice]];
    return cell;
}

//headerView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = _datas[section];
    if (section == 0) {
        UIView *contentView = [[UIView alloc] initWithFrame:tableView.frame];
        CGRect rect = contentView.frame;
        rect.size.height = SectionHeaderHeight;
        contentView.frame = rect;
        contentView.backgroundColor = [UIColor clearColor];
        
        UILabel *firstLabel = [[UILabel alloc] init];
        firstLabel.textAlignment = NSTextAlignmentCenter;
        firstLabel.font = [UIFont systemFontOfSize:13.];
        firstLabel.frame = CGRectMake(0, 5, contentView.frame.size.width, 15);
        firstLabel.text = self.time;
        [firstLabel setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *secondLabel = [[UILabel alloc] init];
        secondLabel.font = [UIFont systemFontOfSize:13.];
        secondLabel.frame = CGRectMake(0, CGRectGetMaxY(firstLabel.frame)+3, contentView.frame.size.width, 15);
        secondLabel.textAlignment = NSTextAlignmentCenter;
        secondLabel.text = dict[KeyStatisHeader];
        [secondLabel setBackgroundColor:[UIColor whiteColor]];
        
        [contentView addSubview:firstLabel];
        [contentView addSubview:secondLabel];
        return contentView;
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = dict[KeyStatisHeader];
    [titleLabel setBackgroundColor:[UIColor whiteColor]];
    return titleLabel;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = SectionHeaderHeight;
        if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TTDatePickerDelegate
- (void)switchToDay:(NSDate *)date
{
    [self queryStatis:date];
}

-(void) dealloc{
    [[ObserverListner getNewInstance] removeWithKey:NSStringFromClass([self class])];
}


@end
