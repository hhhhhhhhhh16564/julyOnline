//
//  JUapplyCell.m
//  algorithm
//
//  Created by 周磊 on 17/1/24.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUapplyCell.h"
#import "JUapplicantCell.h"
#import "JUDeletelineLabel.h"

@interface JUapplyCell ()

@property(nonatomic, strong) UIImageView *imv;
@property(nonatomic, strong) UILabel *titlelab;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) JUDeletelineLabel *previousLabel;
@property(nonatomic, strong) JUapplicantCell *preferentialCell;

@property(nonatomic, strong) JUapplicantCell *couponCodeCell;

@property(nonatomic, strong) UIButton *resonsePriceButton;
@property(nonatomic, strong) UIButton *resonseCodeButton;


@end

@implementation JUapplyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_setupSubViews];
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
    
//    JUapplicantCell *preferentialCell = [[JUapplicantCell alloc]init];
//    [self.contentView addSubview:preferentialCell];
//    preferentialCell.textLabel.text = @"优惠价格";
//    preferentialCell.detailTextLabel.textColor = [UIColor redColor];
//    preferentialCell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"apply_sign_question"]];
//    self.preferentialCell = preferentialCell;
//    
//    
//    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
//        preferentialCell.accessoryView = nil;
//    }
//    //放在cell上响应事件
//    UIButton *resonsePriceButton = [UIButton createButton];
//    [resonsePriceButton addTarget:self action:@selector(resonsePriceButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
//    
//    [self.preferentialCell addSubview:resonsePriceButton];
//     self.resonsePriceButton = resonsePriceButton;
    
    
    
    
    JUapplicantCell *couponCodeCell = [[JUapplicantCell alloc]init];
    [self.contentView addSubview:couponCodeCell];
    couponCodeCell.textLabel.text = @"优惠券";
    couponCodeCell.detailTextLabel.textColor = [UIColor redColor];
    couponCodeCell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"apply_icon_arrow"]];
    self.couponCodeCell = couponCodeCell;
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        couponCodeCell.hidden = YES;
    }
    
    
    
    //放在cell上响应事件
    UIButton *resonseCodeButton = [UIButton createButton];
    [resonseCodeButton addTarget:self action:@selector(resonseCodeButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.couponCodeCell addSubview:resonseCodeButton];
    self.resonseCodeButton = resonseCodeButton;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat kItemHeitht = Kwidth*0.3334*0.72;
    
    
    [self.imv mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.top.mas_equalTo(12);
        make.height.mas_equalTo(kItemHeitht);
        make.width.mas_equalTo(Kwidth*0.3334);
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
    
    
//    
//    [self.preferentialCell mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.top.equalTo(self.imv.mas_bottom).offset(15);
//        make.height.mas_equalTo(44);
//        
//    }];
    
    [self.couponCodeCell mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(self.imv.mas_bottom).offset(15);

        make.height.mas_equalTo(44);
        
    }];
    
//    [self.resonsePriceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.and.right.and.top.and.bottom.mas_equalTo(0);
//    }];
    
    [self.resonseCodeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.and.top.and.bottom.mas_equalTo(0);
    }];
    
    
}




//控件赋值
-(void)setShoppingCarModel:(JUShoppingCarModel *)shoppingCarModel{
    _shoppingCarModel = shoppingCarModel;
    self.titlelab.text = shoppingCarModel.course_title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",shoppingCarModel.price1];
    self.previousLabel.text = [NSString stringWithFormat:@"¥%@",shoppingCarModel.price0];
    [self.imv sd_setImageWithURL:[NSURL URLWithString:shoppingCarModel.image_name] placeholderImage:[UIImage imageNamed:@"smallloading"]];
    self.preferentialCell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",shoppingCarModel.level_price];
    self.couponCodeCell.detailTextLabel.font = UIptfont(17);
    //无优惠码
    if ([_shoppingCarModel.coupon isEqualToString:@"0"]) {
        self.couponCodeCell.detailTextLabel.text = @"无";
        self.couponCodeCell.detailTextLabel.textColor = [UIColor grayColor];
        if ([_shoppingCarModel.coupon_num integerValue]) {
            self.couponCodeCell.detailTextLabel.font = UIptfont(13);
            self.couponCodeCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ 张可用",_shoppingCarModel.coupon_num];
        }
    //有优惠码
    }else{
        self.couponCodeCell.detailTextLabel.text = [NSString stringWithFormat:@"-¥%@",shoppingCarModel.coupon_amount];
        self.couponCodeCell.detailTextLabel.textColor = [UIColor redColor];
    }
}

//
//-(void)resonsePriceButtonClicked:(UIButton *)sender{
//    [JUUmengStaticTool event:JUUmengStaticCourseApplication key:JUUmengStaticCourseApplication value:@"UserPrivilege"];
//
//    if ([JuuserInfo.showstring isEqualToString:@"0"]) return;
//    if (self.disPriceBlock) {
//        
//        self.disPriceBlock(self.shoppingCarModel);
//    }
//
//}

-(void)resonseCodeButtonClicked:(UIButton *)sender{
    
    [JUUmengStaticTool event:JUUmengStaticCourseApplication key:JUUmengStaticCourseApplication value:@"Privilege"];
    if ([JuuserInfo.showstring isEqualToString:@"0"]) return;

    if (self.couponCodeBlock) {
        
        self.couponCodeBlock(self.shoppingCarModel);
    }
    
    
}

-(void)setFrame:(CGRect)frame{
    
    frame.size.height -= 8;
    
    [super setFrame:frame];
    
}




@end
