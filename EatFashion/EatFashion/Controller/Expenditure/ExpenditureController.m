//
//  ExpenditureController.m
//  EatFashion
//
//  Created by wlpiaoyi on 15/4/14.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "ExpenditureController.h"
#import "ExpendtureHeadCell.h"
#import "ExpendtureTailCell.h"
#import "ExpendtureProductCell.h"
#import "ExpenditureService.h"
#import "MJRefresh.h"
#import "MJRefreshConst.h"
#import "ExpendtureAddController.h"
#import "ShiShangDataPickerView.h"

static NSString *ExpendtureHeadCellIdentifier = @"ExpendtureHeadCell";
static NSString *ExpendtureProductIdentifier = @"ExpendtureProductCell";
static NSString *ExpendtureTailCellIdentifier = @"ExpendtureTailCell";

@interface ExpenditureController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *buttonAddExpenditure;
@property (weak, nonatomic) IBOutlet UILabel *lableExpendtureValue;
@property (weak, nonatomic) IBOutlet UILabel *lableStartDate;
@property (weak, nonatomic) IBOutlet UILabel *lableStartTime;
@property (weak, nonatomic) IBOutlet UILabel *lableEndDate;
@property (weak, nonatomic) IBOutlet UILabel *lableEndTime;
@property (weak, nonatomic) IBOutlet UITableView *tableViewExpendture;

@property (strong, nonatomic) ShiShangDataPickerView *dp;
@property (strong, nonatomic) PopUpMovableView *movableView;

@property (strong, nonatomic) ExpenditureService *eService;
@property (strong, nonatomic) NSArray *arryData;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (weak, nonatomic) IBOutlet UIButton *buttonStartDate;
@property (weak, nonatomic) IBOutlet UIButton *buttonEndDate;
@property (nonatomic) unsigned int pageNum;

@end

@implementation ExpenditureController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"记录支出"];
    [self.buttonAddExpenditure setCornerRadiusAndBorder:5 BorderWidth:1 BorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [self.buttonAddExpenditure addTarget:self action:@selector(onclickAddExpendture)];
    self.tableViewExpendture.delegate = self;
    self.tableViewExpendture.dataSource = self;
    self.tableViewExpendture.alwaysBounceHorizontal = NO;
    self.lableEndTime.hidden = YES;
    self.lableStartTime.hidden = YES;
    self.eService = [ExpenditureService new];
    self.startTime = [NSDate new];
    self.endTime = [NSDate new];
    [self.tableViewExpendture addHeaderWithCallback:^{
        [self reloadData];
    }];
    [self.tableViewExpendture addFooterWithCallback:^{
        [self reloadData:self.pageNum+1];
    }];
    self.endTime = [NSDate new];
    self.startTime = self.endTime;
    
    
    UINib *nib = [UINib nibWithNibName:ExpendtureHeadCellIdentifier bundle:nil];
    [self.tableViewExpendture registerNib:nib forCellReuseIdentifier:ExpendtureHeadCellIdentifier];
    nib = [UINib nibWithNibName:ExpendtureProductIdentifier bundle:nil];
    [self.tableViewExpendture registerNib:nib forCellReuseIdentifier:ExpendtureProductIdentifier];
    nib = [UINib nibWithNibName:ExpendtureTailCellIdentifier bundle:nil];
    [self.tableViewExpendture registerNib:nib forCellReuseIdentifier:ExpendtureTailCellIdentifier];
    [self.buttonStartDate addTarget:self action:@selector(onclickStartDate)];
    [self.buttonEndDate addTarget:self action:@selector(onclickEndDate)];
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadData];
}

- (void)reloadData{
    self.arryData = nil;
//    NSDate *today = [NSDate new];
//    if(today.day == _endTime.day && today.year == _endTime.year){
//        self.endTime = [today offsetDay:1];
//    }
    [self reloadData:0];
}
- (void)reloadData:(int) pageNum{
    self.pageNum = pageNum;
    self.lableExpendtureValue.text = @"0.0";
    [self.eService getStatisExpenseForStartTime:self.startTime endTime:self.endTime Success:^(id data, NSDictionary *userInfo) {
        NSArray *json = [data JSONValue];
        NSString *price = @"0.0";
        if(json && json.count > 0){
            price = [json.firstObject objectForKey:@"price"];
        }
        if(price){
            self.lableExpendtureValue.text = price;
            [self.lableExpendtureValue automorphismHeight];
        }
        
    } faild:^(id data, NSDictionary *userInfo) {
    }];
    [Utils showLoading:nil];
    [self.eService queryExpenseForStartTime:self.startTime endTime:self.endTime pageNum:self.pageNum Success:^(id data, NSDictionary *userInfo) {
        NSMutableArray *array = [NSMutableArray new];
        NSUInteger count = 0;
        if(self.arryData != nil){
            count = [self.arryData count];
            [array addObjectsFromArray:self.arryData];
            self.arryData = nil;
        }
        self.arryData = data;
        if(self.arryData != nil){
            [array addObjectsFromArray:self.arryData];
            self.arryData = nil;
        }
        _arryData = [NSArray arrayWithArray:array];
        [self.tableViewExpendture reloadData];
        [self.tableViewExpendture headerEndRefreshing];
        [self.tableViewExpendture footerEndRefreshing];
        if([_arryData count] == count && self.pageNum > 0){
            self.pageNum--;
        }
        [self.view viewWithTag:333].hidden = !(_arryData == nil || [_arryData count] == 0);
        self.tableViewExpendture.scrollEnabled = !(_arryData == nil || [_arryData count] == 0);
        [Utils hiddenLoading];
    } faild:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        [self.tableViewExpendture headerEndRefreshing];
        [self.tableViewExpendture footerEndRefreshing];
    }];
}

- (void)onclickAddExpendture{
    ExpendtureAddController *c = [[ExpendtureAddController alloc] initWithNibName:@"ExpendtureAddController" bundle:nil];
    [self goNextController:c];
}

-(void) setEndTime:(NSDate *)endTime{
    _endTime = endTime;
    _endTime = [_endTime offsetHours:23-_endTime.hour];
    _endTime = [_endTime offsetMinutes:59-_endTime.minute];
    _endTime = [_endTime offsetSecond:59-_endTime.second];
    self.lableEndDate.text = [self.endTime dateFormateDate:@"yyyy-MM-dd"];
    self.lableEndTime.text = [self.endTime dateFormateDate:@"HH:mm:ss"];
    if(![self ifMaxDate:_endTime minDate:_startTime]){
        NSDate *startTime = self.endTime;
        self.startTime = startTime;
    }
}

-(void) setStartTime:(NSDate *)startTime{
    _startTime = startTime;
    _startTime = [_startTime offsetHours:-_startTime.hour];
    _startTime = [_startTime offsetMinutes:-_startTime.minute];
    _startTime = [_startTime offsetSecond:-_startTime.second];
    self.lableStartDate.text = [self.startTime dateFormateDate:@"yyyy-MM-dd"];
    self.lableStartTime.text = [self.startTime dateFormateDate:@"HH:mm:ss"];
    if(![self ifMaxDate:_endTime minDate:_startTime]){
        NSDate *endTime = self.startTime;
        self.endTime = endTime;
    }
}

-(BOOL) ifMaxDate:(NSDate*) maxDate minDate:(NSDate*) minDate {
    int maxValue = maxDate.year;
    int minValue = minDate.year;
    if(maxValue < minValue){
        return false;
    }else if(maxValue > minValue){
        return true;
    }
    maxValue = maxDate.month;
    minValue = minDate.month;
    if(maxValue < minValue){
        return false;
    }else if(maxValue > minValue){
        return true;
    }
    maxValue = maxDate.day;
    minValue = minDate.day;
    if(maxValue < minValue){
        return false;
    }else if(maxValue > minValue){
        return true;
    }
    maxValue = maxDate.hour;
    minValue = minDate.hour;
    if(maxValue < minValue){
        return false;
    }else if(maxValue > minValue){
        return true;
    }
    maxValue = maxDate.minute;
    minValue = minDate.minute;
    if(maxValue < minValue){
        return false;
    }else if(maxValue > minValue){
        return true;
    }
    return false;
}



#pragma delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *json = [self.arryData objectAtIndex:indexPath.row];
    NSNumber *cellFlag = [json objectForKey:@"cellFlag"];
    float height = 0.0f;
    if(cellFlag == nil){
        height = [ExpendtureProductCell getHeight];
    }else if(cellFlag.intValue == 1){
        height = [ExpendtureHeadCell getHeight];
    }else if(cellFlag.intValue == 2){
        height = [ExpendtureTailCell getHeight];
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma dataresource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arryData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    NSDictionary *json = [self.arryData objectAtIndex:indexPath.row];
    NSNumber *cellFlag = [json objectForKey:@"cellFlag"];
    if(cellFlag == nil){
        ExpendtureProductCell *cellP = [tableView dequeueReusableCellWithIdentifier:ExpendtureProductIdentifier];
        [cellP setParams:json];
        cell = cellP;
    }else if(cellFlag.intValue == 1){
        ExpendtureHeadCell *cellH = [tableView dequeueReusableCellWithIdentifier:ExpendtureHeadCellIdentifier];
        [cellH setParams:json];
        cell = cellH;
    }else if(cellFlag.intValue == 2){
        ExpendtureTailCell *cellT = [tableView dequeueReusableCellWithIdentifier:ExpendtureTailCellIdentifier];
        [cellT setParams:json];
        [cellT setBlockCancel:^(NSDictionary *json) {
            NSNumber *keyId = [json objectForKey:@"id"];
            [Utils showLoading:nil];
            [self.eService cancelExpenseForOrderId:[keyId stringValue] Success:^(id data, NSDictionary *userInfo) {
                [Utils hiddenLoading];
                [self reloadData];
            } faild:^(id data, NSDictionary *userInfo) {
                [Utils hiddenLoading];
            }];
        }];
        cell = cellT;
    }
    return cell;
}
- (void) setArryData:(NSArray *)arryData{
    if(arryData == nil){
        _arryData = nil;
        return;
    }
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *json in arryData) {
        NSArray *expenseItems = [json objectForKey:@"expenseItems"];
        if(expenseItems != nil && [expenseItems count] > 0){
            NSMutableDictionary *head = [NSMutableDictionary dictionaryWithDictionary:json];
            [head removeObjectForKey:@"expenseItems"];
            [head setObject:@1 forKey:@"cellFlag"];
            [array addObject:head];
            [array addObjectsFromArray:expenseItems];
            NSMutableDictionary *taile = [NSMutableDictionary dictionaryWithDictionary:head];
            [taile setObject:@2 forKey:@"cellFlag"];
            [array addObject:taile];
        }
    }
    _arryData = [NSArray arrayWithArray:array];
}
-(void) onclickStartDate{
    
    PopUpMovableView *movableView = [PopUpMovableView new];
    ShiShangDataPickerView *dp = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ShiShangDataPickerView class]) owner:self options:nil].firstObject;
    [dp addTarget:self action:@selector(closePopUp)];
    [dp setDate:self.startTime];
    [movableView setBackgroundColor:[UIColor clearColor]];
    [movableView addSubview:dp];
    [movableView setFlagTouchHidden:NO];
    __weak typeof(self) weaklself = self;
    [movableView setBeforeClose:^(PopUpMovableView *vmv) {
        weaklself.startTime = ((ShiShangDataPickerView*)vmv.viewShow).date;
        [weaklself reloadData];
    }];
    [movableView show];
    self.movableView = movableView;
    

}

-(void) closePopUp{
    [_movableView close];
}
-(void) onclickEndDate{
    
    PopUpMovableView *movableView = [PopUpMovableView new];
    ShiShangDataPickerView *dp = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ShiShangDataPickerView class]) owner:self options:nil].firstObject;
    [dp addTarget:self action:@selector(closePopUp)];
    [dp setDate:self.endTime];
    [movableView setBackgroundColor:[UIColor clearColor]];
    [movableView addSubview:dp];
    [movableView setFlagTouchHidden:NO];
    __weak typeof(self) weaklself = self;
    [movableView setBeforeClose:^(PopUpMovableView *vmv) {
        weaklself.endTime = ((ShiShangDataPickerView*)vmv.viewShow).date;
        [weaklself reloadData];
    }];
    [movableView show];
    self.movableView = movableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
