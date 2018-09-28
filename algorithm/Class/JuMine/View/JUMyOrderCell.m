//
//  JUMyOrderCell.m
//  algorithm
//
//  Created by 周磊 on 16/9/2.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUMyOrderCell.h"
#import "JUDeletelineLabel.h"
#import "JUButton.h"
#import "JUBaseNavigationController.h"
#import "JUTabBarController.h"
#import "JUOnlinepaymentController.h"


@interface JUMyOrderCell ()
@property(nonatomic, strong) UILabel *waitTingPayLabel;

@property(nonatomic, strong) UIImageView *imv;
@property(nonatomic, strong) UILabel *titlelab;


@property(nonatomic, strong) UILabel *nowPriceLabel;

@property(nonatomic, strong) UIView *bottomLineView;
@property(nonatomic, strong) UIView *topLineView;
@property(nonatomic, strong) UIView *centerLineView;


@property(nonatomic, strong) JUDeletelineLabel *previousLabel;


@property(nonatomic, strong) UILabel *shouldPaylabel;

@property(nonatomic, strong) UILabel *actualPriceLabel;


@property(nonatomic, strong) JUButton *payButton;


@end





@implementation JUMyOrderCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self p_setupSubViews];
        
    }
    
    return self;
    
    
}


-(void)p_setupSubViews{

    UIColor *orangeColor = HCOrange(1);
    UILabel *waitTingPayLabel = [[UILabel alloc]init];
    waitTingPayLabel.font = UIptfont(14);
    waitTingPayLabel.textColor = orangeColor;
    waitTingPayLabel.text = @"等待支付";
    [self.contentView addSubview:waitTingPayLabel];
    self.waitTingPayLabel = waitTingPayLabel;

    
    
    
    
    UIView *topLineView = [[UIView alloc]init];
    topLineView.backgroundColor = HCommomSeperatorline(1);
    [self.contentView addSubview:topLineView];
    self.topLineView = topLineView;
    

    

    
    UIImageView *imv = [[UIImageView alloc]init];
    [self.contentView addSubview:imv];
    self.imv = imv;
    self.imv.backgroundColor = [UIColor redColor];
    
    
    
    UILabel *titlelab = [[UILabel alloc]init];
    [self.contentView addSubview:titlelab];
    titlelab.numberOfLines = 2;
//    titlelab.font = UIptfont(15);
    self.titlelab = titlelab;
    //    self.titlelab.backgroundColor = [UIColor greenColor];
    
    
    
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.textColor = [UIColor redColor];
    priceLabel.font = UIptfont(17);
    [self.contentView addSubview:priceLabel];
    self.nowPriceLabel = priceLabel;
    
    
    
    
    JUDeletelineLabel *previousLabel = [[JUDeletelineLabel alloc]init];
    previousLabel.textColor = HSpecialSeperatorline(1);
    previousLabel.font = UIptfont(13);
    [self.contentView addSubview:previousLabel];
    self.previousLabel = previousLabel;
    
    
    
    UIView *centerLineView = [[UIView alloc]init];
    centerLineView.backgroundColor = HCommomSeperatorline(1);
    [self.contentView addSubview:centerLineView];
    self.centerLineView = centerLineView;
    

    UILabel *shouldPaylabel = [[UILabel alloc]init];
    shouldPaylabel.font = UIptfont(16);
    shouldPaylabel.text = @"应付:    ";
    [self.contentView addSubview:shouldPaylabel];
    self.shouldPaylabel = shouldPaylabel;
    
    

    UILabel *actualPriceLabel = [[UILabel alloc]init];
    actualPriceLabel.textColor = [UIColor redColor];
    actualPriceLabel.font = UIptfont(16);
    [self.contentView addSubview:actualPriceLabel];
    self.actualPriceLabel = actualPriceLabel;
    
    
    
    
    JUButton *payButton = [JUButton buttonWithType:(UIButtonTypeCustom)];
    [payButton setTitle:@"去支付" forState:(UIControlStateNormal)];
    [payButton.titleLabel setFont:UIptfont(14)];
    [payButton setTitleColor:orangeColor forState:(UIControlStateNormal)];
    
    [payButton addTarget:self action:@selector(payingAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    payButton.layer.cornerRadius = 4;
    payButton.layer.borderColor = orangeColor.CGColor;
    payButton.layer.borderWidth = 1;
    [self.contentView addSubview:payButton];
    self.payButton = payButton;

    

    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = HCommomSeperatorline(1);
    [self.contentView addSubview:bottomLineView];
    self.bottomLineView = bottomLineView;
    
    
    
}


-(void)payingAction:(JUButton *)payButton{
    
    JUlogFunction
    
//    JUTabBarController.h  JUTabBarController  JUBaseNavigationController
    
    JUTabBarController *TabVC = (JUTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;

    
    JUBaseNavigationController *NaVC = (JUBaseNavigationController *)[TabVC.viewControllers lastObject];
    
    JUOnlinepaymentController *payVC = [[JUOnlinepaymentController alloc]init];
    
    payVC.orderModel = self.order;
    
    [NaVC pushViewController:payVC animated:NO];

    
    
}



-(void)layoutSubviews{
    [super layoutSubviews];

    [self.waitTingPayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    
    [self.topLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.top.and.left.and.right.mas_equalTo(0);
        
        make.height.mas_equalTo(0.5);
        
    }];
    

    CGFloat kItemHeitht = Kwidth*0.4*0.72;
    
    
    [self.imv mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.top.equalTo(self.waitTingPayLabel.mas_bottom);
        make.height.mas_equalTo(kItemHeitht);
        make.width.mas_equalTo(Kwidth*0.4);
    }];
    
    
    
    [self.titlelab mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        
        make.left.equalTo(self.imv.mas_right).offset(12);
        
        make.right.mas_equalTo(-12);
        
        make.top.mas_equalTo(self.imv.mas_top).offset(5);

    }];
    
   
    
    
    [self.nowPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titlelab);
        
        make.bottom.equalTo(self.imv);
        
    }];
    
    
    
    
    [self.previousLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nowPriceLabel.mas_right).and.offset(12);
        
        
        make.centerY.equalTo(self.nowPriceLabel);
        
        
    }];
    
    
    
    
    [self.centerLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.top.equalTo(self.imv.mas_bottom).offset(15);
        
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
   
        
    }];
    
    
    
    
    [self.shouldPaylabel mas_remakeConstraints:^(MASConstraintMaker *make) {
       
//        make.left.equalTo(self.imv);
//        make.bottom.equalTo(0);
//        make.top.equalTo(self.centerLineView.mas_bottom);

        
        make.left.equalTo(self.imv);
        make.bottom.mas_equalTo(0);
        make.top.equalTo(self.centerLineView.mas_bottom);

        
        
        
    }];
    
 
    [self.actualPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.shouldPaylabel.mas_right);
        
        make.bottom.mas_equalTo(0);
        
        make.top.equalTo(self.shouldPaylabel);
 
    }];
    
    
    
    [self.payButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self.shouldPaylabel);

    }];
    

    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.bottom.and.right.mas_equalTo(0);
        
        make.height.mas_equalTo(0.5);
        
    }];
    
   
    
}



-(void)setOrder:(JUOrderModel *)order{

    _order = order;
    
    
//    self.titlelab.text = @"点击发送开法拉利的发动机啦";
//    self.nowPriceLabel.text = @"￥1244";
//    self.previousLabel.text = @"￥542";
//    self.actualPriceLabel.text = @"¥880";
//    
    
    
    NSURL *url = [NSURL URLWithString:order.image_name];
    [self.imv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"smallloading"]];
    
    self.titlelab.text = order.course_title;
    self.nowPriceLabel.text = [NSString stringWithFormat:@"¥%@",order.price1];
    
    self.previousLabel.text = [NSString stringWithFormat:@"¥%@",order.price0];

    self.actualPriceLabel.text = [NSString stringWithFormat:@"¥%@",order.pay_amount];
    
    

    
    


}



@end
