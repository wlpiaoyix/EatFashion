//
//  ExpendtureAddController.m
//  EatFashion
//
//  Created by wlpiaoyi on 15/4/18.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "ExpendtureAddController.h"
#import "ExpendtureAddProductCell.h"
#import "ExpendtureConfirmProductCell.h"
#import "ExpenditureService.h"


static NSString *ExpendtureAddProductCellIdentifier = @"ExpendtureAddProductCell";
static NSString *ExpendtureConfirmProductCellIdentifier = @"ExpendtureConfirmProductCell";


@interface ExpendtureAddController ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property CGRect rectTableView;

@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;
@property (weak, nonatomic) IBOutlet UITableView *tableViewProduct;
@property (strong, nonatomic) ExpenditureService *eService;
@property NSString *externInfo;

@end

@implementation ExpendtureAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"添加支出"];
    [self setHiddenCloseButton:NO];
    self.tableViewProduct.delegate = self;
    self.tableViewProduct.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:ExpendtureAddProductCellIdentifier bundle:nil];
    [self.tableViewProduct registerNib:nib forCellReuseIdentifier:ExpendtureAddProductCellIdentifier];
    nib = [UINib nibWithNibName:ExpendtureConfirmProductCellIdentifier bundle:nil];
    [self.tableViewProduct registerNib:nib forCellReuseIdentifier:ExpendtureConfirmProductCellIdentifier];
    [self.buttonAdd addTarget:self action:@selector(onclickAdd)];
    [self onclickAdd];
    self.eService = [ExpenditureService new];
    
    __weak typeof(self) weakself = self;
    [self setSELShowKeyBoardStart:^{
        
    } End:^(CGRect keyBoardFrame) {
        weakself.tableViewProduct.frame = weakself.rectTableView;
        CGRect r = weakself.rectTableView;
        r.size.height -= keyBoardFrame.size.height;
        weakself.tableViewProduct.frame = r;
    }];
    [self setSELHiddenKeyBoardBefore:^{
        
    } End:^(CGRect keyBoardFrame) {
        weakself.tableViewProduct.frame = weakself.rectTableView;
    }];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGRect rectTableView = self.tableViewProduct.frame;
    self.rectTableView = rectTableView;
}


#pragma delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height = 0.0f;
    if(indexPath.row == [self.arrayData count]){
        height = [ExpendtureConfirmProductCell getHeight];
    }else{
        height = [ExpendtureAddProductCell getHeight];
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma dataresource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayData count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id json = nil;
    if(indexPath.row < [self.arrayData count]){
        json = [self.arrayData objectAtIndex:indexPath.row];
    }
    UITableViewCell *cell = nil;
    if (json){
        ExpendtureAddProductCell *_cell = [tableView dequeueReusableCellWithIdentifier:ExpendtureAddProductCellIdentifier];
        [_cell setParams:json];
        cell = _cell;
    }else{
        ExpendtureConfirmProductCell *_cell = [tableView dequeueReusableCellWithIdentifier:ExpendtureConfirmProductCellIdentifier];
        [_cell setTarget:self action:@selector(onclickConfrim)];
        [_cell setExternInfoPoint:&_externInfo];
        cell = _cell;
    }
    return cell;
}
- (void) onclickAdd{
    if(self.arrayData == nil || [self.arrayData count]==0){
        self.arrayData = [NSMutableArray new];
    }
    [self.arrayData addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"itemName":@"",@"itemValue":@""}]];
    [self.tableViewProduct reloadData];
}
- (void) onclickConfrim{
    [self resignFirstResponder];
    NSMutableArray *removeArray = [NSMutableArray new];
    float total = 0.0f;
    for (id json in self.arrayData) {
        NSString *name = [json objectForKey:@"itemName"];
        NSString *value = [json objectForKey:@"itemValue"];
        if (![NSString isEnabled:name] || ![NSString isEnabled:value]) {
            [removeArray addObject:json];
        }else{
            total += value.floatValue;
        }
    }
    [self.arrayData removeObjectsInArray:removeArray];
    if ([self.arrayData count] == 0) {
        [self.arrayData addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"itemName":@"",@"itemValue":@""}]];
    }
    [self.tableViewProduct reloadData];
    if (total <= 0.0f) {
        [PYToast showWithText:@"请输入添加类容!"];
        return;
    }
    
    PopUpDialogVendorView *pdvv = [PopUpDialogVendorView alertWithMessage:[[NSNumber numberWithFloat:total] stringValueWithPrecision:2] title:@"确认开支" onclickBlock:^BOOL(PopUpDialogVendorView *dialogView, NSInteger buttonIndex) {
        if (buttonIndex==0) {
            [Utils showLoading:@"保存支出信息..."];
            __weak typeof(self) weakself = self;
            [self.eService addExpenseForItems:self.arrayData extraInfo:self.externInfo Success:^(id data, NSDictionary *userInfo) {
                [PYToast showWithText:@"保存成功!"];
                [weakself backPreviousController];
                [Utils hiddenLoading];
            } faild:^(id data, NSDictionary *userInfo) {
                [Utils hiddenLoading];
                [PYToast showWithText:@"网络异常"];
            }];
        }
        return true;
    } buttonNames:@"确认",@"取消",nil];
    [pdvv show];
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
