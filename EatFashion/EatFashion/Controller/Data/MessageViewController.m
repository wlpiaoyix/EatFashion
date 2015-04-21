//
//  MessageViewController.m
//  Data
//
//  Created by torin on 14/11/27.
//  Copyright (c) 2014年 tt_lin. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageService.h"
#import "MessageCell.h"
#import "MJRefresh.h"
#import "MJRefreshConst.h"
static NSString *CellIdentifier = @"MessageCell";
@interface MessageViewController()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBae;
@property (nonatomic,strong) NSArray *arrayMessage;
@property (strong, nonatomic) UITableView *tableViewMessage;
@property (strong, nonatomic) MessageService *messageService;
@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"消 息"];
    [self setHiddenCloseButton:NO];
    [self.topView.buttonReback setTitle:@"查看" forState:UIControlStateNormal];
    [self.topView.buttonReback addTarget:self action:@selector(reloadData)];
    self.searchBae.delegate = self;
    _messageService = [MessageService new];
    _tableViewMessage = [[UITableView alloc] init];
    _tableViewMessage.delegate = self;
    _tableViewMessage.dataSource = self;
    __weak typeof(self) weakself = self;
    [_tableViewMessage addHeaderWithCallback:^{
        [weakself reloadData];
    }];
    [self.view addSubview:self.tableViewMessage];
    [super setSELShowKeyBoardStart:^{
        
    } End:^(CGRect keyBoardFrame) {
        
    }];
    [super setSELHiddenKeyBoardBefore:^{
        
    } End:^(CGRect keyBoardFrame) {
        
    }];
    
    [ViewAutolayoutCenter persistConstraintRelation:self.tableViewMessage margins:UIEdgeInsetsMake(0, 0, 0, 0) toItems:@{@"top":self.searchBae}];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar; {
    NSString *item = [searchBar text];
    __weak typeof(self) weakself = self;
    [Utils showLoading:nil];
    [_messageService searchWithItem:item success:^(id data, NSDictionary *userInfo) {
        [weakself excuteReloadData:data];
        [Utils hiddenLoading];
    } faild:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
    }];
    
}
-(void) excuteReloadData:(id) data{
    self.arrayMessage = data;
    [self.tableViewMessage reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.frameHeight = appHeight()-SSCON_BUTTOM;
    [self reloadData];
}
-(void) reloadData{
    __weak typeof(self) weakself = self;
    [Utils showLoading:nil];
    [_messageService getApplicantsWithSuccess:^(id data, NSDictionary *userInfo) {
        
        [weakself excuteReloadData:data];
        [Utils hiddenLoading];
        EntityUser *user = [ConfigManage getLoginUser];
        user.shopId = [ConfigManage getShopId];
        [weakself.tableViewMessage headerEndRefreshing];
        for (EntityMessage *message in (NSArray*)data) {
            if (message.applicantId.intValue == user.keyId.intValue&&[message.applyStatus isEqualToString:@"退出"]) {
                user.shopId = message.shopId;
                break;
            }
        }
        [ObserverListner getNewInstance].valueListner = @"ManagerController";
    } faild:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        [weakself.tableViewMessage headerEndRefreshing];
        
    }];
}

#pragma delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma dataresource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayMessage count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    EntityMessage *message = [self.arrayMessage objectAtIndex:[indexPath row]];
    
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) weakself = self;
        [cell setDispatchBlockMessageOpt:^(EntityMessage *message) {
            [Utils showLoading:nil];
            if (!message.applicantId||!message.applicantId.intValue) {
                message.applicantId = [ConfigManage getLoginUser].keyId;
            }
            [weakself.messageService shopGroupActionWithMessage:message success:^(id data, NSDictionary *userInfo) {
                [Utils hiddenLoading];
                [weakself reloadData];
            } faild:^(id data, NSDictionary *userInfo) {
                [Utils hiddenLoading];
            }];
        }];
    }
    [cell setMessage:message];
    return cell;
}
@end
