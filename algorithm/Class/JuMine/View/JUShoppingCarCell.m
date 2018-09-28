//
//  JUShoppingCarCell.m
//  algorithm
//
//  Created by 周磊 on 17/1/18.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUShoppingCarCell.h"
#import "JUDeletelineLabel.h"
#import "JUapplicantCell.h"

@interface JUShoppingCarCell ()
@property(nonatomic, strong) UIButton *checkButton;
@property(nonatomic, strong) UIButton *deleteButton;
@property(nonatomic, strong) UIImageView *imv;

@property(nonatomic, strong) UIView *seperatorView;
@property(nonatomic, strong) UILabel *titlelab;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) JUDeletelineLabel *previousLabel;
@property(nonatomic, strong) JUapplicantCell *preferentialCell;

@property(nonatomic, strong) UIButton *resonsePriceButton;




@end

@implementation JUShoppingCarCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_setupSubViews];
    }
    
    return self;
}


-(void)p_setupSubViews{
    
    
    
    UIButton *checkButton = [UIButton createButton];
    [checkButton setImage:[UIImage imageNamed:@"daixuan@shop"] forState:(UIControlStateNormal)];
    [checkButton addTarget:self action:@selector(checkButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];

    [checkButton setImage:[UIImage imageNamed:@"duihao@icon"] forState:(UIControlStateSelected)];
    [self.contentView addSubview: checkButton];
    self.checkButton = checkButton;
    
    
    UIButton *deleteButton = [UIButton createButton];
    [deleteButton setImage:[UIImage imageNamed:@"shop@delete"] forState:(UIControlStateNormal)];
     [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview: deleteButton];
    self.deleteButton = deleteButton;
    

    UIView *seperatorView = [[UIView alloc]init];
    seperatorView.backgroundColor = Kcolor16rgb(@"#F1F1F1", 1);
    [self.contentView addSubview:seperatorView];
    self.seperatorView = seperatorView;
    


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
//
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
//        
//    }
//    
//    //放在cell上响应事件
//    UIButton *resonsePriceButton = [UIButton createButton];
//    [resonsePriceButton addTarget:self action:@selector(resonsePriceButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
//
//    [self.preferentialCell addSubview:resonsePriceButton];
//    self.resonsePriceButton = resonsePriceButton;
//    
    
}


-(void)layoutSubviews{
    [super layoutSubviews];


    
    [self.checkButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        
    }];
    
    [self.deleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerY.equalTo(self.checkButton);

        
    }];
    
    [self.seperatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(35);
        make.top.equalTo(self.checkButton.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        
    }];
    
    
    
    
    
    CGFloat kItemHeitht = Kwidth*0.3334*0.72;

    
    [self.imv mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(35);
        make.top.equalTo(self.seperatorView.mas_bottom).offset(5);
        make.height.mas_equalTo(kItemHeitht);
        make.width.mas_equalTo(Kwidth * 0.3334);
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
    
    

//    [self.preferentialCell mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.top.equalTo(self.imv.mas_bottom).offset(5);
//        make.height.mas_equalTo(44);
//        
//    }];
//    
//    [self.resonsePriceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.and.right.and.top.and.bottom.mas_equalTo(0);
//    }];
    
    
    
}




//控件赋值
-(void)setShoppingCarModel:(JUShoppingCarModel *)shoppingCarModel{

    
    _shoppingCarModel = shoppingCarModel;
    self.titlelab.text = shoppingCarModel.course_title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",shoppingCarModel.price1];
    self.previousLabel.text = [NSString stringWithFormat:@"¥%@",shoppingCarModel.price0];
    [self.imv sd_setImageWithURL:[NSURL URLWithString:shoppingCarModel.image_name] placeholderImage:[UIImage imageNamed:@"smallloading"]];
    self.preferentialCell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",shoppingCarModel.level_price];
    self.checkButton.selected = shoppingCarModel.isSelected;
    
}


//优惠价格的cell响应
//-(void)resonsePriceButtonClicked:(UIButton *)sender{
//    [JUUmengStaticTool event:JUUmengStaticShoppingCart key:JUUmengStaticShoppingCart value:@"UserPrivilege"];
//
//    if ([JuuserInfo.showstring isEqualToString:@"0"])return;
//    if (self.discountRuleBlock) {
//        self.discountRuleBlock(self.shoppingCarModel);
//    }
//    
//    JUlogFunction
//}

//对号选择的button
-(void)checkButtonClicked:(UIButton *)sender{
    
    [JUUmengStaticTool event:JUUmengStaticShoppingCart key:JUUmengStaticShoppingCart value:@"CheckBox"];

    self.shoppingCarModel.isSelected = !self.shoppingCarModel.isSelected;
    
    sender.selected = self.shoppingCarModel.isSelected;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JUShoppingCarSelectedNotification object:nil];
    

}

//删除
-(void)deleteButtonClicked:(UIButton *)sender{
    
    [JUUmengStaticTool event:JUUmengStaticShoppingCart key:JUUmengStaticShoppingCart value:@"delete"];

   
    if (self.deleteBlock) {
        self.deleteBlock(self.shoppingCarModel.course_id);
    }
   
    
    
}



-(void)setFrame:(CGRect)frame{

    frame.size.height -= 10;
    
    [super setFrame:frame];

}










@end
