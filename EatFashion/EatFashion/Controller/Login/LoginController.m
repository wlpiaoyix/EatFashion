//
//  LoginController.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-4.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "LoginController.h"
#import "RegeditController.h"
#import "UserService.h"
#import "EditPasswordController.h"
#import "MainController.h"

@interface LoginController (){
    
}

@property (strong, nonatomic) IBOutlet UIView *viewField;
@property (strong, nonatomic) IBOutlet UITextField *textFieldAccount;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (strong, nonatomic) IBOutlet UIView *viewButton;
@property (strong, nonatomic) IBOutlet UIButton *buttonRegedit;
@property (strong, nonatomic) IBOutlet UIButton *buttonLogin;
@property (strong, nonatomic) IBOutlet UIButton *buttonEditPassword;

@property (strong, nonatomic) UserService *userService;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"登  录"];
    [self.navigationController setNavigationBarHidden:NO];
    _userService = [UserService new];
    
    
    [self.viewField setCornerRadiusAndBorder:5 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    [self.textFieldAccount setCornerRadiusAndBorder:0 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    [self.textFieldPassword setCornerRadiusAndBorder:0 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    self.viewField.backgroundColor = [[SkinDictionary getSingleInstance] getSkinColor:@"textfiledview_bg_color"];
    self.textFieldPassword.delegate = self;
    
    [_buttonLogin addTarget:self action:@selector(onclickLogin)];
    [_buttonRegedit addTarget:self action:@selector(onclickRegedit)];
    [_buttonEditPassword addTarget:self action:@selector(onclickEditPassword)];
    
    __weak typeof(self) weakself = self;
    [super setSELShowKeyBoardStart:^{
    } End:^(CGRect keyBoardFrame) {
        float offy = (weakself.view.frameHeight-keyBoardFrame.size.height)-(weakself.viewField.frameY+weakself.viewField.frameHeight);
        if (offy < 0) {
            weakself.view.frameY = navigationBarHeight+offy;
        }
    }];
    [super setSELHiddenKeyBoardBefore:^{
        
    } End:^(CGRect keyBoardFrame) {
        weakself.view.frameY = navigationBarHeight;
    }];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *userName = [ConfigManage getUserName];
    NSString *password = [ConfigManage getPassword];
    self.textFieldAccount.text = userName;
    self.textFieldPassword.text = password;
    if ([NSString isEnabled:userName]&&[NSString isEnabled:password]) {
        [self onclickLogin];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onclickRegedit{
    RegeditController *rc = [[RegeditController alloc] initWithNibName:@"RegeditController" bundle:nil];
    [super goNextController:rc];
}

-(void) onclickLogin{
    [self resignFirstResponder];
    
    NSString *userName = self.textFieldAccount.text;
    NSString *password = self.textFieldPassword.text;
    
    if (![NSString isEnabled:userName]) {
        [Utils showAlert:@"请输入手机号!" title:nil];
        return;
    }
    if (![NSString isEnabled:password]) {
        [Utils showAlert:@"请输入密码!" title:nil];
        return;
    }
    [Utils showLoading:nil];
    
    [ConfigManage setUserName:userName];
    [ConfigManage setPassword:password];
    [_userService loginWithUserName:userName password:password success:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        if (data) {
            [Utils setShiShangController:[[MainController alloc] initWithNibName:@"MainController" bundle:nil]];
        }else{
            [ConfigManage setPassword:nil];
            [self.textFieldPassword setText:@""];
        }
    } faild:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        [Utils showAlert:@"无法连接服务器" title:@""];
        
    }];
}
-(void) onclickEditPassword{
    EditPasswordController *epc = [[EditPasswordController alloc] initWithNibName:@"EditPasswordController" bundle:nil];
    [super goNextController:epc];
}
#pragma ==> <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_textFieldPassword) {
        [self onclickLogin];
    }
    return YES;
}
#pragma <==

//
//-(BOOL) resignFirstResponder{
//    [_textFieldAccount resignFirstResponder];
//    [_textFieldPassword resignFirstResponder];
//    return [super resignFirstResponder];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
