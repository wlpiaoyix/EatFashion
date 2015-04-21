//
//  EditPasswordController.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-7.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "EditPasswordController.h"
#import "UserService.h"
#import "EntityUser.h"

@interface EditPasswordController (){
    int smsVerification;
}

@property (nonatomic) CGRect rectKeyBorde;
@property (strong, nonatomic) UserService *userService;
@property (strong, nonatomic) IBOutlet UIView *viewValidate;
@property (strong, nonatomic) IBOutlet UITextField *textFiledPhone;
@property (strong, nonatomic) IBOutlet UITextField *textFiledValidate;
@property (strong, nonatomic) IBOutlet UIButton *buttonValidate;
@property (strong, nonatomic) IBOutlet UIView *viewPassowrd;
@property (strong, nonatomic) IBOutlet UITextField *textFiledPassword;
@property (strong, nonatomic) IBOutlet UITextField *textFiledPassword2;
@property (strong, nonatomic) IBOutlet UIButton *buttonConfirm;

@end

@implementation EditPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setTitle:@"重置/修改密码"];
    [self.navigationController setNavigationBarHidden:NO];
    _userService = [UserService new];
    smsVerification = -1;
    [_viewValidate setCornerRadiusAndBorder:5 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    [_textFiledValidate setCornerRadiusAndBorder:0 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    [_textFiledPhone setCornerRadiusAndBorder:5 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    
    [_viewPassowrd setCornerRadiusAndBorder:5 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    [_textFiledPassword setCornerRadiusAndBorder:0 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    
    
    _textFiledPhone.backgroundColor = [[SkinDictionary getSingleInstance] getSkinColor:@"textfiledview_bg_color"];
    _viewPassowrd.backgroundColor = [[SkinDictionary getSingleInstance] getSkinColor:@"textfiledview_bg_color"];
    _viewValidate.backgroundColor = [[SkinDictionary getSingleInstance] getSkinColor:@"textfiledview_bg_color"];
    
    [super setRightButtonName:@"完成" action:@selector(onclickEdit)];
    [_buttonConfirm addTarget:self action:@selector(onclickEdit)];
    [_buttonValidate addTarget:self action:@selector(onclickVerification)];
    
    _textFiledPassword.delegate =
    _textFiledPassword2.delegate =
    _textFiledPhone.delegate =
    _textFiledValidate.delegate = self;
    
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
    // Do any additional setup after loading the view from its nib.
}

-(void) onclickEdit{
    [self resignFirstResponder];
    NSString *password;
    NSString *phone;
    if ([self verificationUpdatePassword:&password phone:&phone]==1) {
        [Utils showLoading:nil];
        [_userService updatePassword:password phone:phone success:^(id data, NSDictionary *userInfo) {
            [Utils hiddenLoading];
            [[PopUpDialogVendorView alertWithMessage:@"操作成功！" title:@"提示" onclickBlock:^BOOL(PopUpDialogVendorView *dialogView, NSInteger buttonIndex) {
                [self backPreviousController];
                return true;
            } buttonNames:@"确定",nil] show];
        } faild:^(id data, NSDictionary *userInfo) {
            [Utils hiddenLoading];
        }];
    }
}
-(void) onclickVerification{
    [self resignFirstResponder];
    NSString* _phone = _textFiledPhone.text;
    if (![NSString isEnabled:_phone]) {
        [Utils showAlert:@"请输入手机号！" title:nil];
        return;
    }
    smsVerification = [_userService smsVerificationUpadatePasswordWithPhone:_phone success:^(id data, NSDictionary *userInfo) {
        [Utils showAlert:@"已发送" title:nil];
    }];
}
-(int) verificationUpdatePassword:(NSString**) password phone:(NSString**) phone{
    NSString* _phone = _textFiledPhone.text;
    NSString *_password1 = _textFiledPassword.text;
    NSString *_password2 = _textFiledPassword2.text;
    if (![NSString isEnabled:_phone]) {
        [Utils showAlert:@"请输入手机号！" title:nil];
        return -1;
    }
    if (![NSString isEnabled:_password1]) {
        [Utils showAlert:@"请输入密码！" title:nil];
        return -1;
    }
    if (![NSString isEnabled:_password2]) {
        [Utils showAlert:@"请确认密码！" title:nil];
        return -1;
    }
    if (![_password1 isEqualToString:_password1]) {
        [Utils showAlert:@"两次密码出入不一致!" title:nil];
        return -1;
    }
    if (smsVerification!=[_textFiledValidate.text intValue]) {
        [Utils showAlert:@"验证码不对!" title:nil];
        return -1;
    }
    return 1;
}

#pragma ==> <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_textFiledPhone.isFirstResponder) {
        [_textFiledValidate becomeFirstResponder];
    }else if (_textFiledValidate.isFirstResponder) {
        [_textFiledPassword becomeFirstResponder];
    }else if (_textFiledPassword.isFirstResponder) {
        [_textFiledPassword2 becomeFirstResponder];
    }else if (_textFiledPassword2.isFirstResponder) {
        [self onclickEdit];
    }
    [UIView animateWithDuration:0.3f animations:^{
        self->showEnd(self.rectKeyBorde);
    }];
    return YES;
}
#pragma <==


-(UITextField*) getResonderTextField{
    if (_textFiledPhone.isFirstResponder) {
        return _textFiledPhone;
    }
    if (_textFiledValidate.isFirstResponder) {
        return _textFiledValidate;
    }
    if (_textFiledPassword.isFirstResponder) {
        return _textFiledPassword;
    }
    if (_textFiledPassword2.isFirstResponder) {
        return _textFiledPassword2;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [self resignFirstResponder];
}

-(BOOL) resignFirstResponder{
    [_textFiledPhone resignFirstResponder];
    [_textFiledValidate resignFirstResponder];
    [_textFiledPassword resignFirstResponder];
    [_textFiledPassword2 resignFirstResponder];
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
