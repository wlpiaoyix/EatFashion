//
//  FeedBackController.m
//  ShiShang
//
//  Created by wlpiaoyi on 15/1/27.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "FeedBackController.h"

@interface FeedBackController (){
}
@property (nonatomic) CGRect rectViewBase;
@property (nonatomic,strong) UIView *viewBase;
@property (nonatomic,strong) UITextView *textViewOpinion;
@property (nonatomic,strong) UIButton *buttonSubmit;
@end

@implementation FeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"意见反馈"];
    [self setHiddenCloseButton:NO];
    [self initRectViewBase];
    _viewBase = [[UIView alloc] init];
    [self.view addSubview:_viewBase];
    [ViewAutolayoutCenter persistConstraintRelation:_viewBase margins:UIEdgeInsetsMake(SSCON_TOP, 0, 0, 0) toItems:nil];
    _textViewOpinion = [[UITextView alloc]init];
    [_textViewOpinion setCornerRadiusAndBorder:5 BorderWidth:2 BorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [_viewBase addSubview:_textViewOpinion];
    [ViewAutolayoutCenter persistConstraintRelation:_textViewOpinion margins:UIEdgeInsetsMake(20, 20, 80, 20) toItems:nil];
    _buttonSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonSubmit setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [_buttonSubmit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_buttonSubmit addTarget:self action:@selector(onclickSubmit)];
    [_buttonSubmit setTitle:@"提 交" forState:UIControlStateNormal];
    [_buttonSubmit setCornerRadiusAndBorder:5 BorderWidth:0 BorderColor:nil];
    [_viewBase addSubview:_buttonSubmit];
    [_buttonSubmit setFrameSize:CGSizeMake(260, 44)];
    [_buttonSubmit setFrameOrigin:CGPointMake(0, DisableConstrainsValueMAX)];
    [ViewAutolayoutCenter persistConstraintSize:_buttonSubmit];
    [ViewAutolayoutCenter persistConstraintCenter:_buttonSubmit];
    [ViewAutolayoutCenter persistConstraintRelation:_buttonSubmit margins:UIEdgeInsetsMake(18, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX) toItems:@{@"top":_textViewOpinion}];
    __weak typeof(self) weakself = self;
    [self setSELShowKeyBoardStart:nil End:^(CGRect keyBoardFrame) {
        if (weakself.rectViewBase.size.width==0) {
            weakself.rectViewBase = weakself.view.frame;
        }
        weakself.view.frameHeight = weakself.rectViewBase.size.height - keyBoardFrame.size.height;
    }];
    [self setSELHiddenKeyBoardBefore:nil End:^(CGRect keyBoardFrame) {
        weakself.view.frame = weakself.rectViewBase;
        [weakself initRectViewBase];
    }];
    // Do any additional setup after loading the view from its nib.
}

-(void) onclickSubmit{
    [self resignFirstResponder];
    NSString *opinion = _textViewOpinion.text;
    if (![NSString isEnabled:opinion]) {
        [Utils showAlert:@"请输入您的宝贵意见！" title:nil];
        return;
    }
    [[PopUpDialogVendorView alertWithMessage:@"感谢您给我们的宝贵意见！" title:@"提示" onclickBlock:^BOOL(PopUpDialogVendorView *dialogView, NSInteger buttonIndex) {
        [self backPreviousController];
        return true;
    } buttonNames:@"确定",nil] show];
}
-(void) initRectViewBase{
    _rectViewBase = CGRectMake(0, 0, 0, 0);
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
