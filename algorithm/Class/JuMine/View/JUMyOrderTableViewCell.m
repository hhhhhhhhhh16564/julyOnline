//
//  JUMyOrderTableViewCell.m
//  algorithm
//
//  Created by 周磊 on 17/1/25.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUMyOrderTableViewCell.h"
#import "JUDeletelineLabel.h"
#import "JUButton.h"

static NSString * const myOrderTableViewSubCell = @"JUMyOrderTableViewSubCell";
#pragma mark 小cell， 大cell中tableview的cell
@interface JUMyOrderTableViewSubCell ()
@property(nonatomic, strong) UIImageView *imv;
@property(nonatomic, strong) UILabel *titlelab;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) JUDeletelineLabel *previousLabel;
@property(nonatomic, strong) UIView *bottomLineView;




@end


@implementation JUMyOrderTableViewSubCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self p_setupSubViews];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
    
    
}

-(void)p_setupSubViews{
    
    UIImageView *imv = [[UIImageView alloc]init];
    [self addSubview:imv];
    self.imv = imv;
    
    UILabel *titlelab = [[UILabel alloc]init];
    [self addSubview:titlelab];
    titlelab.textColor = Kcolor16rgb(@"#333333", 1);
    titlelab.numberOfLines = 2;
    titlelab.font = UIptfont(15);
    self.titlelab = titlelab;
    
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.textColor = [UIColor redColor];
    
    priceLabel.font = UIptfont(16);
    [self addSubview:priceLabel];
    
    self.priceLabel = priceLabel;
    
    JUDeletelineLabel *previousLabel = [[JUDeletelineLabel alloc]init];
    previousLabel.textColor = HSpecialSeperatorline(1);
    previousLabel.font = UIptfont(13);
    [self addSubview:previousLabel];
    self.previousLabel = previousLabel;
    
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = HSpecialSeperatorline(1);
    [self.contentView addSubview:bottomLineView];
    self.bottomLineView = bottomLineView;

    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat kItemHeitht = Kwidth*0.4*0.72;
 
    [self.imv mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(kItemHeitht);
        make.width.mas_equalTo(Kwidth*0.4);
    }];
    
    
    
    [self.titlelab mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        
        make.left.equalTo(self.imv.mas_right).offset(12);
        
        make.right.mas_equalTo(-12);
        
        make.top.equalTo(self.imv.mas_top).offset(3);
        
        
    }];
    
    
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.imv.mas_right).offset(12);
        
        make.bottom.equalTo(self.imv);
        
    }];
    
    
    
    [self.previousLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        
        make.left.equalTo(self.priceLabel.mas_right).and.offset(12);
        
        
        make.centerY.equalTo(self.priceLabel);
        
        
    }];
    
    
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.imv.mas_bottom).offset(5);
        
    }];
    
    
    
}


-(void)setOrderModel:(JUOrderModel *)orderModel{
    
    _orderModel = orderModel;
    
    self.titlelab.text = orderModel.course_title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",orderModel.pay_amount];
    self.previousLabel.text = [NSString stringWithFormat:@"¥%@",orderModel.amount];
    [self.imv sd_setImageWithURL:[NSURL URLWithString:orderModel.image_name] placeholderImage:[UIImage imageNamed:@"smallloading"]];
    

    
    
    
}


@end




#pragma mark 大cell

@interface JUMyOrderTableViewCell()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UILabel *orderIDLabel;

@property(nonatomic, strong) UILabel *waitTingPayLabel;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UILabel *totalLabel;

@property(nonatomic, strong) UILabel *oldStudentLabel;

@property(nonatomic, strong) UILabel *couponLabel;

@property(nonatomic, strong) UILabel *shouldPayLabel;


// 删除订单的分割线
@property(nonatomic, strong) UIView *seperatorView;
@property(nonatomic, strong) JUButton *deleteButton;
@property(nonatomic, strong) JUButton *payButton;

@end


@implementation JUMyOrderTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self p_setupSubViews];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
    
    
}
-(void)p_setupSubViews{
    

    UILabel *orderIDLabel = [[UILabel alloc]init];
    orderIDLabel.font = UIptfont(15);
    orderIDLabel.textColor = Kcolor16rgb(@"#666666", 1);
    [self.contentView addSubview:orderIDLabel];
    self.orderIDLabel = orderIDLabel;
    
    
    
    UIColor *orangeColor = HCOrange(1);
    UILabel *waitTingPayLabel = [[UILabel alloc]init];
    waitTingPayLabel.font = UIptfont(14);
    waitTingPayLabel.textColor = orangeColor;
    waitTingPayLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:waitTingPayLabel];
    self.waitTingPayLabel = waitTingPayLabel;
    
    
    
#pragma mark tableview
    CGRect tableViewFrame =  CGRectZero;
    self.tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HCanvasColor(1);
    self.tableView.contentInset = UIEdgeInsetsMake(1, 0, 0, 0);
    self.tableView.scrollEnabled = NO;
    [self.contentView addSubview:self.tableView];
    [self.tableView registerClass:[JUMyOrderTableViewSubCell class] forCellReuseIdentifier:myOrderTableViewSubCell];

 
    
    //合计
    UILabel *totalLabel = [[UILabel alloc]init];
    totalLabel.font = UIptfont(13);
    [self.contentView addSubview:totalLabel];
    self.totalLabel = totalLabel;
    
    
    //老学员
    UILabel *oldStudentLabel = [[UILabel alloc]init];
    oldStudentLabel.font = UIptfont(13);
    [self.contentView addSubview:oldStudentLabel];
    self.oldStudentLabel = oldStudentLabel;

    
    //优惠券
    UILabel *couponLabel = [[UILabel alloc]init];
    couponLabel.font = UIptfont(13);
    [self.contentView addSubview:couponLabel];
    self.couponLabel = couponLabel;
    
    
    //应付
    UILabel *shouldPayLabel = [[UILabel alloc]init];
    shouldPayLabel.font = UIptfont(16);
    [self.contentView addSubview:shouldPayLabel];
    self.shouldPayLabel = shouldPayLabel;
    
    
    // 删除订单上边的分割线
    
    UIView *seperatorView = [[UIView alloc]init];
    seperatorView.backgroundColor = HSpecialSeperatorline(1);
    [self.contentView addSubview:seperatorView];
    self.seperatorView = seperatorView;
    

    
    JUButton *deleteButton = [JUButton createButton];
    [deleteButton setImage:[UIImage imageNamed:@"dingdan@del"] forState:(UIControlStateNormal)];
    [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];

    [self.contentView addSubview:deleteButton];
    self.deleteButton = deleteButton;
    
    
    
    JUButton *payButton = [JUButton createButton];
    [payButton setImage:[UIImage imageNamed:@"gopay"] forState:(UIControlStateNormal)];
    [payButton addTarget:self action:@selector(payButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];

    [self.contentView addSubview:payButton];
    self.payButton = payButton;
    
//    [self.contentView colorForSubviews];
    

}





-(void)layoutSubviews{
    [super layoutSubviews];
    
 
    [self.orderIDLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(44);
    }];
    
    
    
    [self.waitTingPayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(44);
        
    }];
    
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.mas_equalTo(0);
        make.top.equalTo(self.orderIDLabel.mas_bottom);
        
        make.height.mas_equalTo(self.shoppingCarOrderModel.tableViewHeight);
        
    }];
    
  
    [self.totalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        

        make.top.equalTo(self.tableView.mas_bottom).offset(10);
        make.height.mas_equalTo(18);
        make.left.mas_equalTo(12);
        
        
        
    }];
    
    
    [self.oldStudentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.totalLabel.mas_bottom);
        make.height.mas_equalTo(18);
        make.left.mas_equalTo(12);
        
        
        
    }];
    

    
    [self.couponLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.oldStudentLabel.mas_bottom);
        make.height.mas_equalTo(18);
        make.left.mas_equalTo(12);
        
        
        
    }];
    
    
    [self.shouldPayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(18);
        make.right.mas_equalTo(-12);
        make.centerY.equalTo(self.couponLabel.mas_centerY);

    }];
    
    
    [self.seperatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.couponLabel.mas_bottom).offset(10);
        
    }];
    
    
    CGFloat PayButtonWidth = 0;
    
    if ([self.shoppingCarOrderModel.pay_time isEqualToString:@"0"]) {
        
        PayButtonWidth = 90;
    }
    
    
    
    [self.payButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(PayButtonWidth);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.seperatorView.mas_bottom).offset(7);
        
    }];
    
    
    [self.deleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.payButton.mas_left).offset(-12);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.seperatorView.mas_bottom).offset(7);
        
    }];
    
}

-(void)setFrame:(CGRect)frame{
    
    frame.size.height -= 10;
    
    [super setFrame:frame];
    
    
    
}

#pragma mark 按钮响应事件
-(void)deleteButtonClicked:(JUButton *)sender{
    
    if (self.deleteOrderBlock) {
        
        self.deleteOrderBlock(self.shoppingCarOrderModel);
    }
    
    
}

-(void)payButtonClicked:(JUButton *)sender{
    
    if (self.goPayBlock) {
        
        self.goPayBlock(self.shoppingCarOrderModel);
    }
    
    
}



#pragma mark 的代理


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JUMyOrderTableViewSubCell *cell = [tableView dequeueReusableCellWithIdentifier:myOrderTableViewSubCell forIndexPath:indexPath];
    
   
    cell.orderModel = self.shoppingCarOrderModel.course[indexPath.row];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    return [self.shoppingCarOrderModel.course[indexPath.row] orderHeight];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.shoppingCarOrderModel.course.count;
}



#pragma mark Model赋值
-(void)setShoppingCarOrderModel:(JUShoppingCarOrderModel *)shoppingCarOrderModel{
    
    
    [shoppingCarOrderModel logObjectExtension_YanBo];
    
    
    
    _shoppingCarOrderModel = shoppingCarOrderModel;
    self.orderIDLabel.text = [NSString stringWithFormat:@"订单号: %@", shoppingCarOrderModel.oid];
    [self richTextLabel];
    [self.tableView reloadData];
    
    if ([shoppingCarOrderModel.pay_time isEqualToString:@"0"]) {
        self.waitTingPayLabel.text = @"等待支付";
    }else{
        self.waitTingPayLabel.text = @"交易成功";
    }
    
    
//    if ([shoppingCarOrderModel.oid isEqualToString:@"1484667580775245"]) {
//        
//        JULog(@"hhhhhhh %zd", shoppingCarOrderModel.course.count);
//        
//    }
//    
    
    
}


-(void)richTextLabel{
    
    NSString * totalLabelText = [NSString stringWithFormat:@"合计:   %@元", _shoppingCarOrderModel.amount];
    NSMutableAttributedString *totalAttributedString = [totalLabelText mutableAttributedString];
    UIColor *grayColor = Kcolor16rgb(@"#666666", 1)
    
    [totalAttributedString font:13 color:grayColor];
    [totalAttributedString font:0 color:[UIColor redColor]str:_shoppingCarOrderModel.amount];
    
    
    NSString * oldStudentLabelText = [NSString stringWithFormat:@"老学员优惠:   %@元", _shoppingCarOrderModel.discount];
    NSMutableAttributedString *oldStudentAttributedString = [oldStudentLabelText mutableAttributedString];
    [oldStudentAttributedString font:13 color:grayColor];
    [oldStudentAttributedString font:0 color:[UIColor redColor]str:_shoppingCarOrderModel.discount];
    
    
    
    
    
    NSString * couponLabelText = [NSString stringWithFormat:@"优惠券优惠:   %@元", _shoppingCarOrderModel.coupon_amount];
    NSMutableAttributedString *couponAttributedString = [couponLabelText mutableAttributedString];
    [couponAttributedString font:13 color:grayColor];
    [couponAttributedString font:0 color:[UIColor redColor]str:_shoppingCarOrderModel.coupon_amount];
    

    
    
    
    
    
    
    
    NSString * shouldPayLabelText = [NSString stringWithFormat:@"应付: %@", _shoppingCarOrderModel.pay_amount];
    NSMutableAttributedString *shouldPayAttributedString = [shouldPayLabelText mutableAttributedString];
    [shouldPayAttributedString font:16 color:grayColor];
    [shouldPayAttributedString font:0 color:[UIColor redColor]str:_shoppingCarOrderModel.pay_amount];
    
  
    
    self.totalLabel.attributedText = totalAttributedString;
    self.oldStudentLabel.attributedText = oldStudentAttributedString;
    self.couponLabel.attributedText = couponAttributedString;
    self.shouldPayLabel.attributedText = shouldPayAttributedString;
    
}



@end
