//
//  ViewController.m
//  Common
//
//  Created by wlpiaoyi on 14/12/25.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ViewController.h"
#import "HViewController.h"

@interface ViewController ()
@property (nonatomic) UIButton *button;
@property (nonatomic) UIButton *buttonx;
@property (nonatomic) SimplePickerView *spv;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ObserverListner getNewInstance] mergeWithTarget:self action:@selector(prefersStatusBarHidden) arguments:nil key:@"VertivalController"];
    self.supportInterfaceOrientation = UIInterfaceOrientationMaskAllButUpsideDown;
    _button = [UIButton new];
    _button.frame = CGRectMake(30, 60, 80, 80);
    [_button setTitle:@"横排" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(onclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    [_button setBackgroundColor:[UIColor redColor]];
    [self setTitle:@"横排"];
//    _spv = [SimplePickerView new];
//    _spv.frame = CGRectMake(30, 30, 300, 400);
//    [self.view addSubview:_spv];
//    [_spv setDelegate:self];
//    [_spv reloadData];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void) onclick{
    [self goNextController:[HViewController new]];
//    [self.refreshView setDirection:self.refreshView.direction==RefreshMessageViewDirectionButtom?RefreshMessageViewDirectionTop:RefreshMessageViewDirectionButtom];
}
-(void) onclickx{
    [self backPreviousController];
}

// Device oriented vertically, home button on the bottom
-(void) deviceOrientationPortrait{
}
// Device oriented vertically, home button on the top
-(void) deviceOrientationPortraitUpsideDown{
}
// Device oriented horizontally, home button on the right
-(void) deviceOrientationLandscapeLeft{
}
// Device oriented horizontally, home button on the left
-(void) deviceOrientationLandscapeRight{
}


-(UIView*) pickerGetCell:(SimplePickerView*) Picker{
    UILabel *lable = [UILabel new];
    lable.frame = CGRectMake(0, 0, 200, 20);
    [lable setTextAlignment:NSTextAlignmentCenter];
    return lable;
}
-(NSInteger) PickerNumberOfRows:(SimplePickerView*) Picker{
    return 20;
}
-(void) picker:(SimplePickerView*) Picker setCell:(UIView*) setcell row:(NSInteger) row{
    UILabel *lable = setcell;
    lable.text = [NSString stringWithFormat:@"%d",row];
}
-(CGFloat) picker:(SimplePickerView*) Picker heightForRowAtIndex:(NSInteger) row{
    return 40;
}
-(void) pickerCellDidSelected:(NSInteger) row{
}
-(void) pickerCellDidCheck:(UIView*) cell{
}
-(void) pickerCellDidUnCheck:(UIView*) cell{
}

-(void) dealloc{
    [[ObserverListner getNewInstance] removeWithKey:@"VertivalController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
