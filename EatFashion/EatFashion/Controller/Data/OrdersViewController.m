//
//  OrdersViewController.m
//  Data
//
//  Created by torin on 14/11/15.
//  Copyright (c) 2014年 tt_lin. All rights reserved.
//

#import "OrdersViewController.h"
#import "OrdersViewCell.h"
#import "HeaderView.h"
#import "FooterView.h"
#import "BaseTableView.h"
#import "EntityOrder.h"
#import "OrdersService.h"
#import "Common+Expand.h"
#import "TTDatePicker.h"
#import "MJRefresh.h"
#import "MJRefreshConst.h"
#import "ShiShangDataPickerView.h"
#import "ViewAutolayoutCenter.h"

#define SectionHeaderHeight 0
#define SectionFooterHeight 0

@interface OrdersViewController () <UITableViewDataSource,UITableViewDelegate,FooterViewDelegate,TTDatePickerDelegate>
{
    NSMutableArray *_datas;
    BOOL flagIsEndLoad;
}
@property unsigned int currentpageNum;
@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic,strong) TTDatePicker *datePicker;
@property (strong, nonatomic) PopUpMovableView *movableView;
@end

@interface OrderCellBar : UITableViewCell

@end

@implementation OrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    flagIsEndLoad = true;
    //日期选择
    TTDatePicker *datePicker = [[TTDatePicker alloc] init];
    datePicker.delegate = self;
    
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    _datePicker = datePicker;
    [_datePicker setSelectedDate:[NSDate date]];
    [_datePicker addTarget:self action:@selector(onclickShowTime)];
    [self.view addSubview:_datePicker];
    _datePicker.frameX = (appWidth()-_datePicker.frameWidth)/2;
    _datePicker.frameY = 0;
    
    UITableView *tableView  = [[BaseTableView alloc] init];
    tableView.frame = CGRectMake(0, CGRectGetMaxY(datePicker.frame), self.view.frame.size.width, self.view.frame.size.height);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.allowsSelection = NO;
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    __weak typeof(self) weakself = self;
    [self.tableView addHeaderWithCallback:^{
        [weakself reloadData];
    }];
    [self.tableView addFooterWithCallback:^{
        [weakself queryOrders:weakself.datePicker.selectedDate];
    }];
    
    //监听
    [[ObserverListner getNewInstance] mergeWithTarget:self action:@selector(reloadData) arguments:nil key:NSStringFromClass([self class])];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.frameHeight = appHeight()-SSCON_TOP-SSCON_BUTTOM - SSCON_TIT;
    self.tableView.frameHeight = self.view.frameHeight-self.tableView.frameY;
    self.tableView.frameWidth = appWidth();
    [self reloadData];
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
    self.currentpageNum = 0;
    [self queryOrders:self.datePicker.selectedDate];
}

- (void)queryOrders:(NSDate *)date
{
    @synchronized(self){
        if (!flagIsEndLoad) {
            return;
        }
        flagIsEndLoad = false;
        
        if (!_datas) {
            _datas = [NSMutableArray new];
        }
        [Utils showLoading:@"正在加载订单..."];
        OrdersService *ordersService = [OrdersService new];
        [ordersService queryOrdersForDate:date pageNum:self.currentpageNum Success:^(id data, NSDictionary *userInfo) {
            NSArray *jsonarray;
            if (data && ![data isEqualToString:@""]) {
                jsonarray = [((NSString*)data) JSONValue];
                
                @synchronized(_datas){
                    if (self.currentpageNum<1) {
                        self.currentpageNum = 0;
                        [_datas removeAllObjects];
                    }
                    [_datas addObjectsFromArray:jsonarray];
                }
                [self.tableView reloadData];
            }
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            if ([jsonarray count]) {
                self.currentpageNum++;
            }
            flagIsEndLoad = true;
            [Utils hiddenLoading];
        } faild:^(id data, NSDictionary *userInfo) {
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            flagIsEndLoad = true;
            [Utils hiddenLoading];
        }];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    @synchronized(_datas){
        return _datas.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @synchronized(_datas){
        NSDictionary *dict = _datas[section];
        NSArray *array = dict[KeyOrderItems];
        return array.count+2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建一个ILSettingCell
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    UITableViewCell *cell;
    @synchronized(_datas){
        if (section<[_datas count]) {
            NSDictionary *dict = _datas[section];
            NSArray *rowArray = dict[KeyOrderItems];
            if (row==0) {
                
                HeaderView *headerView = [[HeaderView alloc] init];
                
                if (section<=[_datas count]) {
                    NSDictionary *dict = _datas[section];
                    headerView.dict = dict;
                }
                [headerView autoresizingMask_TBLRWH];
                cell = [[UITableViewCell alloc] init];
                [cell.contentView addSubview:headerView];
            }else if (row<=[rowArray count]) {
                cell = [OrdersViewCell settingCellWithTableView:tableView];
                NSDictionary *rowDict = rowArray[row-1];
                ((OrdersViewCell*)cell).dict = rowDict;
            }else{
                if (section<=[_datas count]) {
                    FooterView *footerView = [[FooterView alloc] init];
                    NSDictionary *dict = _datas[section];
                    footerView.delegate = self;
                    footerView.dict = dict;
                    footerView.section = section;
                    cell = [[OrderCellBar alloc] init];
                    [cell.contentView addSubview:footerView];
                }
            }
        }
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @synchronized(_datas){
        NSDictionary *dict = _datas[indexPath.section];
        NSArray *array = dict[KeyOrderItems];
        NSInteger row = indexPath.row;
        NSInteger section = indexPath.section;
        NSInteger count = array.count;
        float height;
        if (row==0) {
            height = 45;
        } else if(row >= 0 &&row <= count){
            height = 35;
        }else{
            height = 90;
        }
        return height;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SectionHeaderHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SectionFooterHeight;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


#pragma mark - FooterViewDelegate
-(void)cancelOrder:(NSInteger)section
{
    
    @synchronized(_datas){
        [[PopUpDialogVendorView alertWithMessage:@"确定要作废当前订单吗？" title:@"提示" onclickBlock:^BOOL(PopUpDialogVendorView *dialogView, NSInteger buttonIndex) {
            switch (buttonIndex) {
                case 0:
                {
                    NSDictionary *dict = _datas[section];
                    OrdersService *ordersService = [OrdersService new];
                    [ordersService cancelOrder:dict success:^(id data, NSDictionary *userInfo) {
                        [self reloadData];
                    } faild:^(id data, NSDictionary *userInfo) {
                        
                    }];
                }
                    break;
                    
                default:
                    break;
            }
            return true;
        } buttonNames:@"确定",@"取消",nil] show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TTDatePickerDelegate
- (void)switchToDay:(NSDate *)date
{
    self.currentpageNum = 0;
    [self queryOrders:date];
}

#pragma mark - dealloc
- (void)dealloc
{
    [[ObserverListner getNewInstance] removeWithKey:NSStringFromClass([self class])];
}

@end

@implementation OrderCellBar

-(void) layoutSubviews{
    [super layoutSubviews];
    CGRect r = self.frame;
    r.size.height = 90;
    self.frame = r;
}

@end
