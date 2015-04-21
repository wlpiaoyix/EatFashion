//
//  BuyOrderCartView.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-15.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "BuyOrderCartView.h"
#import "BuyOrderMenuCell.h"
#import "BuyOrdersController.h"
#import "EntityFood.h"

@interface BuyOrderCartView()

@property (assign, nonatomic) id target;
@property (assign, nonatomic) SEL action;

@property (strong, nonatomic) IBOutlet UITableView *tableViewMenu;
@property (strong, nonatomic) IBOutlet UILabel *lableTotal;
@property (strong, nonatomic) IBOutlet UITextField *textFieldDesk;
@property (strong, nonatomic) IBOutlet UIButton *buttonClose;
@property (strong, nonatomic) IBOutlet UIButton *buttonOrderAdd;


@end

@implementation BuyOrderCartView


-(id) initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
    }
    return self;
}
-(void) addSubview:(UIView *)view{
    [super addSubview:view];
}

- (void)awakeFromNib {
    _tableViewMenu.delegate = self;
    _tableViewMenu.dataSource = self;
    [_textFieldDesk setCornerRadiusAndBorder:2 BorderWidth:1 BorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f]];
    UINib *nib = [UINib nibWithNibName:@"BuyOrderMenuCell" bundle:nil];
    [_tableViewMenu registerNib:nib forCellReuseIdentifier:@"BuyOrderMenuCell"];
    [_buttonClose addTarget:self action:@selector(close)];
}
-(void) setArrayData:(NSMutableArray *) arrayData{
    _arrayData = arrayData;
}

-(void) addOrderTarget:(id) target action:(SEL) action{
    if (self.target) {
        [self.buttonOrderAdd removeTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
    }
    self.target = target;
    self.action = action;
    [self.buttonOrderAdd addTarget:target action:action];
    
}
//==> UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 34.0f;
}
//<==
//==>UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrayData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EntityFood *food = [_arrayData objectAtIndex:indexPath.row];
    BuyOrderMenuCell *cell= [_tableViewMenu dequeueReusableCellWithIdentifier:@"BuyOrderMenuCell"];
    [cell setFood:food];
    __weak typeof(self) weakself = self;
    [cell setCallBackBuyOrderMenuCellOnclick:^(EntityFood *food) {
        [weakself reloadData];
    }];
    return cell;
}
//<==
-(void) reloadData{
    unsigned int totalPrice = 0;
    NSMutableArray *removearray = [NSMutableArray new];
    for (EntityFood *food in _arrayData) {
        if (food.amount.intValue<=0) {
            [removearray addObject:food];
            continue;
        }
        NSNumber *price = food.price;
        NSNumber *number =  food.amount;
        totalPrice += (price.floatValue*number.floatValue*100);
    }
    [_arrayData removeObjectsInArray:removearray];
    _totalPrice = [NSNumber numberWithFloat:(float)((totalPrice)/100.0f)];
    _lableTotal.text = [NSString stringWithFormat:@"￥%@",_totalPrice.stringValue];
    [self.tableViewMenu reloadData];
}
-(void) setDeskCode:(NSString *)deskCode{
    self.textFieldDesk.text = deskCode;
}
-(NSString*) deskCode{
    return self.textFieldDesk.text;
}
-(BOOL) resignFirstResponder{
    [_textFieldDesk resignFirstResponder];
    return [super resignFirstResponder];
}
@end
