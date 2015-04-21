//
//  RegeditController.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-7.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "RegeditController.h"
#import "UserService.h"
#import "EntityUser.h"

@interface RegeditController (){
    CGRect rectLogin;
    int smsRandom;
}

@property (nonatomic) CGRect rectKeyBorde;
@property (strong, nonatomic) UserService *userService;

@property (strong, nonatomic) IBOutlet UIView *viewBaseInfo;
@property (strong, nonatomic) IBOutlet UIView *viewValidate;
@property (strong, nonatomic) IBOutlet UIView *viewInfo;
@property (strong, nonatomic) IBOutlet UIView *viewLogin;


@property (strong, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword2;
@property (strong, nonatomic) IBOutlet UITextField *textFieldValidate;
@property (strong, nonatomic) IBOutlet UITextField *textFieldNikeName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;



@property (strong, nonatomic) IBOutlet UIButton *buttonValidate;
@property (strong, nonatomic) IBOutlet UIButton *buttonRegedit;
@property (strong, nonatomic) IBOutlet UIButton *buttonInfo;
@property (strong, nonatomic) IBOutlet UIButton *buttonShowTreaty;

@end

@implementation RegeditController

- (void)viewDidLoad {
    smsRandom = -1;
    [super viewDidLoad];
    [super setTitle:@"注 册"];
    [super setRightButtonName:@"完成" action:@selector(onclickRegedit)];
    _userService = [UserService new];
    [_viewBaseInfo setCornerRadiusAndBorder:5 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    [_viewValidate setCornerRadiusAndBorder:5 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    [_viewInfo setCornerRadiusAndBorder:5 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    [_textFieldPassword setCornerRadiusAndBorder:0 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    [_textFieldNikeName setCornerRadiusAndBorder:0 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    
    
    _viewValidate.backgroundColor = [[SkinDictionary getSingleInstance] getSkinColor:@"textfiledview_bg_color"];
    _viewBaseInfo.backgroundColor = [[SkinDictionary getSingleInstance] getSkinColor:@"textfiledview_bg_color"];
    _viewInfo.backgroundColor = [[SkinDictionary getSingleInstance] getSkinColor:@"textfiledview_bg_color"];
    
    [_buttonRegedit addTarget:self action:@selector(onclickRegedit)];
    [_buttonInfo addTarget:self action:@selector(onclickInfo)];
    [_buttonValidate addTarget:self action:@selector(onclickSmsVerification)];
    
    _textFieldEmail.delegate =
    _textFieldNikeName.delegate =
    _textFieldPassword.delegate =
    _textFieldPassword2.delegate =
    _textFieldUserName.delegate =
    _textFieldValidate.delegate = self;
    
    __weak typeof(self) weakself = self;
    [super setSELShowKeyBoardStart:^{
        
    } End:^(CGRect keyBoardFrame) {
        weakself.rectKeyBorde = keyBoardFrame;
        UITextField *tf = [weakself getResonderTextField];
        if (!tf) {
            return ;
        }
        CGPoint p = [tf getAbsoluteOrigin:weakself.view];
        float offy = p.y+tf.frame.size.height+keyBoardFrame.size.height-weakself.view.frame.size.height;
        if (offy>0) {
            CGRect r = weakself.view.frame;
            r.origin.y = navigationBarHeight-offy;
            weakself.view.frame = r;
        }
    }];
    [super setSELHiddenKeyBoardBefore:^{
        
    } End:^(CGRect keyBoardFrame) {
        CGRect r = weakself.view.frame;
        r.origin.y = navigationBarHeight;
        weakself.view.frame = r;
    }];
    
    rectLogin.origin.x = rectLogin.origin.y = 0;
    // Do any additional setup after loading the view from its nib.
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (rectLogin.origin.x==0&&rectLogin.origin.y == 0) {
        rectLogin = self.viewLogin.frame;
        [self onclickInfo];
    }
    
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void) onclickInfo{
    [_textFieldEmail resignFirstResponder];
    [_textFieldNikeName resignFirstResponder];
    [UIView animateWithDuration:0.2f animations:^{
        CGRect r;
        if (self.viewInfo.hidden) {
            r = rectLogin;
            self.viewInfo.hidden = NO;
            self.viewInfo.alpha = 1;
            self.viewLogin.frame = r;
        }else{
            r = self.viewInfo.frame;
            r.size = self.viewLogin.frame.size;
            self.viewInfo.hidden = YES;
            self.viewInfo.alpha = 0;
            self.viewLogin.frame = r;
        }
        
    }];
}

-(void) onclickRegedit{
    [self resignFirstResponder];
    EntityUser *user;
    int verification = [self regesitVerification:&user];
    if (verification!=1) {
        if (verification==0) {
            [Utils showAlert:@"验证码不对!" title:nil];
        }
        return;
    }
    [Utils showLoading:nil];
    [_userService regesiterWithUser:user success:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        [[PopUpDialogVendorView alertWithMessage:@"操作成功！" title:@"提示" onclickBlock:^BOOL(PopUpDialogVendorView *dialogView, NSInteger buttonIndex) {
            [self backPreviousController];
            return true;
        } buttonNames:@"确定",nil] show];
    } faild:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
    }];
    
}
-(int) regesitVerification:(EntityUser**) _user{
    
    [self resignFirstResponder];
    EntityUser *user = [EntityUser new];
    user.loginName = _textFieldUserName.text;
    user.phoneNumber = user.loginName;
    user.plainPassword =  _textFieldPassword.text;
    NSString *passowrd2 = _textFieldPassword2.text;
    if ([NSString isEnabled:_textFieldNikeName.text]) {
        user.name = _textFieldNikeName.text;
    }
    user.name = user.loginName;
    if (![NSString isEnabled:user.phoneNumber]) {
        [Utils showAlert:@"请输入手机号!" title:nil];
        return -1;
    }
    if (![NSString isEnabled:user.plainPassword]) {
        [Utils showAlert:@"请输入密码!" title:nil];
        return -1;
    }
    if (![NSString isEnabled:passowrd2]) {
        [Utils showAlert:@"请确认密码!" title:nil];
        return -1;
    }
    if(![user.plainPassword isEqualToString:passowrd2]){
        [Utils showAlert:@"两次密码出入不一致!" title:nil];
        return -1;
    }
    *_user = user;
    NSString* smsValue = _textFieldValidate.text;
    if (![NSString isEnabled:smsValue]||smsValue.intValue!=smsRandom) {
        return  0;
    }
    return 1;
}
-(void) onclickSmsVerification{
    _textFieldValidate.text = @"";
    EntityUser *user;
    if ([self regesitVerification:&user]==-1) {
        return;
    }
    smsRandom =  [self.userService smsVerificationRegesiterWithPhone:user.phoneNumber success:^(id data, NSDictionary *userInfo) {
        [Utils showAlert:@"已发送" title:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma ==> <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_textFieldEmail.isFirstResponder) {
        [self onclickRegedit];
    }else if (_textFieldUserName.isFirstResponder) {
        [_textFieldPassword becomeFirstResponder];
    }else if (_textFieldPassword.isFirstResponder) {
        [_textFieldPassword2 becomeFirstResponder];
    }else if (_textFieldPassword2.isFirstResponder) {
        [_textFieldValidate becomeFirstResponder];
    }else if (_textFieldValidate.isFirstResponder) {
        if (self.viewInfo.hidden) {
            [self onclickRegedit];
        }else{
            [_textFieldNikeName becomeFirstResponder];
        }
    }else if (_textFieldNikeName.isFirstResponder) {
        [_textFieldEmail becomeFirstResponder];
    }
    [UIView animateWithDuration:0.3f animations:^{
        self->showEnd(self.rectKeyBorde);
    }];
    return YES;
}
#pragma <==

-(UITextField*) getResonderTextField{
    if (_textFieldEmail.isFirstResponder) {
        return _textFieldEmail;
    }
    if (_textFieldUserName.isFirstResponder) {
        return _textFieldUserName;
    }
    if (_textFieldPassword.isFirstResponder) {
        return _textFieldPassword;
    }
    if (_textFieldPassword2.isFirstResponder) {
        return _textFieldPassword2;
    }
    if (_textFieldValidate.isFirstResponder) {
        return _textFieldValidate;
    }
    if (_textFieldNikeName.isFirstResponder) {
        return _textFieldNikeName;
    }
    return nil;
}
-(BOOL) resignFirstResponder{
    [_textFieldUserName resignFirstResponder];
    [_textFieldPassword resignFirstResponder];
    [_textFieldPassword2 resignFirstResponder];
    [_textFieldValidate resignFirstResponder];
    [_textFieldNikeName resignFirstResponder];
    [_textFieldEmail resignFirstResponder];
    return [super resignFirstResponder];
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
