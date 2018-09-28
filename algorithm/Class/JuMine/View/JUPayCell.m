//
//  JUPayCell.m
//  algorithm
//
//  Created by 周磊 on 17/2/6.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUPayCell.h"
#import "JUDeletelineLabel.h"

@interface JUPayCell ()
@property(nonatomic, strong) UIImageView *imv;
@property(nonatomic, strong) UILabel *titlelab;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) JUDeletelineLabel *previousLabel;
@property(nonatomic, strong) UIView *bottomLineView;

@end

@implementation JUPayCell

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
    
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = HCanvasColor(1);
    [self.contentView addSubview:bottomLineView];
    self.bottomLineView = bottomLineView;
}




-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat kItemHeitht = Kwidth*0.4*0.72;
    
    [self.imv mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.top.mas_equalTo(12);
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
        make.height.mas_equalTo(5);
        make.top.mas_equalTo(self.imv.mas_bottom).offset(15);
        
        
    }];

    
    
}


-(void)setShoppingCarModel:(JUShoppingCarModel *)shoppingCarModel{
    
    _shoppingCarModel = shoppingCarModel;
    
    self.titlelab.text = shoppingCarModel.course_title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",shoppingCarModel.pay_amount];
    self.previousLabel.text = [NSString stringWithFormat:@"¥%@",shoppingCarModel.amount];
    [self.imv sd_setImageWithURL:[NSURL URLWithString:shoppingCarModel.image_name] placeholderImage:[UIImage imageNamed:@"smallloading"]];

    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",shoppingCarModel.price1];
        self.previousLabel.text = [NSString stringWithFormat:@"¥%@",shoppingCarModel.price0];
     
    }
}








@end
