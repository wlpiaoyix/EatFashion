//
//  MainController.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-8.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "MainController.h"
#import "ExpenditureController.h"
#import "ScrollButtonOpt.h"
#import "NavigationScrollView.h"
#import "BuyOrdersController.h"
#import "ManagerController.h"
#import "MessageViewController.h"
#import "DataController.h"
#import "HttpUtilRequest.h"



@interface MainController (){
    BOOL flagLoad;
}
@property (strong, nonatomic) IBOutlet UIView *viewMain;
@property (strong, nonatomic) NavigationScrollView *viewOpt;
@property (nonatomic,strong) ScrollButtonOpt *viewButtom;
@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewMain = [UIView new];
    [self.view addSubview:self.viewMain];
    [ViewAutolayoutCenter persistConstraintRelation:self.viewMain margins:UIEdgeInsetsMake(0, 0, 0, 0) toItems:nil];
    _viewButtom = [ScrollButtonOpt new];
    _viewButtom.frame = CGRectMake(0, 0, appWidth(), 44);
    _viewButtom.values = @[@{@"normal":@"button_menu_un.png",@"selected":@"button_menu.png",@"title":@"下单"},@{@"normal":@"button_manager_un.png",@"selected":@"button_manager.png",@"title":@"管理"},@{@"normal":@"button_expenditure_un.png",@"selected":@"button_expenditure.png",@"title":@"支出"},@{@"normal":@"button_message_un.png",@"selected":@"button_message.png",@"title":@"群组"},@{@"normal":@"button_data_un.png",@"selected":@"button_data.png",@"title":@"数据"}];
    _viewButtom.imageBg = [UIImage imageWithColor:[UIColor clearColor]];
    _viewButtom.backgroundColor = [UIColor clearColor];
    [_viewButtom autoresizingMask_TLR];
    [self.viewMain addSubview:_viewButtom];
    _viewOpt = [NavigationScrollView new];
    _viewOpt.backgroundColor = [UIColor clearColor];
    _viewOpt.frame = CGRectMake(0, 0, appWidth(), appHeight()-SSCON_BUTTOM);
    [self.viewMain addSubview:_viewOpt];
    // Do any additional setup after loading the view from its nib.
    
    BuyOrdersController *epc = [[BuyOrdersController alloc] initWithNibName:@"BuyOrdersController" bundle:nil];
    ManagerController *mc = [[ManagerController alloc] initWithNibName:@"ManagerController" bundle:nil];
    MessageViewController *msg = [[MessageViewController alloc] init];
    DataController *data = [[DataController alloc] init];
    
    _viewOpt.parsentController = self;
    _viewOpt.arrayControllers = [NSArray arrayWithObjects:epc,mc,[[ExpenditureController alloc] initWithNibName:@"ExpenditureController" bundle:nil],msg,data,nil];
    
    __weak typeof(self) weakself =self;
    [_viewOpt setCallBackScrollEnd:^int(int showIndex, id userInfo) {
        weakself.viewButtom.showIndex = showIndex;
        return 1;
    }];
    [_viewButtom setCallBackScrollEnd:^int(int showIndex, id userInfo) {
        [weakself.viewOpt setShowIndex:showIndex];
        return 1;
    }];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (flagLoad) {
        return;
    }
    flagLoad = true;
    CGRect r = _viewButtom.frame;
    r.origin.y = self.viewMain.frame.size.height - r.size.height;
    _viewButtom.frame = r;
    _viewButtom.showIndex = 0;

}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Utils checkAppVersion];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setArrayControllers:(NSMutableArray *)arrayControllers{
    _arrayControllers = arrayControllers;
    for (id target in _arrayControllers) {
        if ([target isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = target;
            UIView *view = vc.view;
            CGRect r = _viewOpt.frame;
            view.frame = r;
            [_viewOpt addSubview:view];
        }
    }
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
