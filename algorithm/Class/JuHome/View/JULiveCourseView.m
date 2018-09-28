//
//  JULiveCourseView.m
//  algorithm
//
//  Created by 周磊 on 16/8/22.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JULiveCourseView.h"
#import "JUDeletelineLabel.h"
#import "JULiveDetailModel.h"
#import "JUOrderModel.h"
#import "NSMutableAttributedString+Extension.h"

@interface JULiveCourseView ()


@property(nonatomic, strong) UIImageView *imv;
@property(nonatomic, strong) UILabel *titlelab;


@property(nonatomic, strong) UILabel *nowPriceLabel;

@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) JUDeletelineLabel *previousLabel;

@property(nonatomic, strong) UILabel *qqLabel;
@property(nonatomic, strong) UILabel *UIDLabel;

@property(nonatomic, strong) UILabel *descLabel;

@end


@implementation JULiveCourseView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        [self setupViews];
        
        
    }
    return self;
}

-(void)setupViews{
    
    
    
    
    
    UIImageView *imv = [[UIImageView alloc]init];
    [self addSubview:imv];
    self.imv = imv;

    
    
    UILabel *titlelab = [[UILabel alloc]init];
    [self addSubview:titlelab];
    titlelab.numberOfLines = 2;
    titlelab.font = UIptfont(16);
    self.titlelab = titlelab;
    //    self.titlelab.backgroundColor = [UIColor greenColor];
    
    
    
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.textColor = [UIColor redColor];
    
    priceLabel.font = UIptfont(17);
    [self addSubview:priceLabel];
    
    self.nowPriceLabel = priceLabel;
    
    
    
    
    JUDeletelineLabel *previousLabel = [[JUDeletelineLabel alloc]init];
    previousLabel.textColor = HSpecialSeperatorline(1);
    
    previousLabel.font = UIptfont(13);
    [self addSubview:previousLabel];
    
    self.previousLabel = previousLabel;
    
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HCommomSeperatorline(1);
    
    [self addSubview:lineView];
    
    self.lineView = lineView;
    
    
    
    UILabel *qqLabel = [[UILabel alloc]init];
    [self addSubview:qqLabel];
    self.qqLabel = qqLabel;
    
    
    UILabel *uidLabel = [[UILabel alloc]init];
    [self addSubview:uidLabel];
    self.UIDLabel = uidLabel;
    
  
    UILabel *descLabel = [[UILabel alloc]init];
    descLabel.font = UIptfont(12);
    descLabel.textColor = Kcolor16rgb(@"#666666", 1);
    [self addSubview:descLabel];
    self.descLabel = descLabel;
    
}


-(void)layoutSubviews{
    [super layoutSubviews];

    CGFloat kItemHeitht = Kwidth*0.4*0.72;
    
    
    [self.imv mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(12);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(kItemHeitht);
        make.width.mas_equalTo(Kwidth*0.4);
    }];
    
    
    
    [self.titlelab mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        
        make.left.equalTo(self.imv.mas_right).offset(12);
        
        make.right.mas_equalTo(-12);
        
        make.top.mas_equalTo(20);
        
        
        
    }];
    
    
    [self.nowPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.imv.mas_right).offset(12);
        
        make.bottom.equalTo(self.imv);
        
    }];
    
    
    
    [self.previousLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        
        make.left.equalTo(self.nowPriceLabel.mas_right).and.offset(12);
        
        
        make.centerY.equalTo(self.nowPriceLabel);
        
        
    }];
    
    
    
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.bottom.mas_equalTo(0);
        
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(Kwidth);
        
        
    }];
    
    
    [self.qqLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titlelab);
        
        make.top.equalTo(self.titlelab.mas_bottom).offset(15);
        make.height.mas_equalTo(12);
        
        
    }];
    
    [self.UIDLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titlelab);
        make.height.mas_equalTo(12);
        make.top.equalTo(self.qqLabel.mas_bottom).offset(10);
        
    }];
    
    
    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titlelab);
        make.top.equalTo(self.titlelab.mas_bottom).offset(15);
        
    }];
    
}


-(void)setLiveDetailModel:(JULiveDetailModel *)liveDetailModel{
    
    _liveDetailModel = liveDetailModel;
    
    self.titlelab.text = liveDetailModel.course_title;
    
    self.nowPriceLabel.text = [NSString stringWithFormat:@"¥%@",liveDetailModel.price1];
    self.previousLabel.text = [NSString stringWithFormat:@"¥%@",liveDetailModel.price0];
    
    
    NSString *imagePath = [NSString stringWithFormat:@"%@%@",home2PictureAppendURL,liveDetailModel.image];
    
    NSURL *url = [NSURL URLWithString:imagePath];
    
    [self.imv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"smallloading"]];

    self.qqLabel.hidden = YES;
    self.UIDLabel.hidden = YES;
    
}

-(void)setNewliveDetailModel:(JULiveDetailModel *)newliveDetailModel{
    
    _newliveDetailModel = newliveDetailModel;
    
    self.nowPriceLabel.hidden = NO;
    self.previousLabel.hidden = NO;
    self.descLabel.hidden = NO;
    self.qqLabel.hidden = NO;
    self.UIDLabel.hidden = NO;
    
    
    self.titlelab.text = newliveDetailModel.course_title;
    

    NSURL *url = [NSURL URLWithString:newliveDetailModel.image_name];
    
    [self.imv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"smallloading"]];
    
    if ([newliveDetailModel.is_baoming boolValue]) {
        
        self.nowPriceLabel.hidden = YES;
        self.previousLabel.hidden = YES;
        self.descLabel.hidden = YES;
        
        NSString *qqContent = [NSString stringWithFormat:@"%@%@",@"请加课程qq群:  ", newliveDetailModel.course_qq];
        NSString *UIDContent = [NSString stringWithFormat:@"%@%@",@"加群请备注你的UID:  ", JuuserInfo.uid];

        NSMutableAttributedString *qq = qqContent.mutableAttributedString;
        NSMutableAttributedString *UID = UIDContent.mutableAttributedString;
        UIColor *normalColor = Kcolor16rgb(@"#666666", 1);
        UIColor *selectColor = Kcolor16rgb(@"#fa952f", 1);
        
        
        [qq font:12 color:normalColor];
        [qq font:12 color:selectColor str:newliveDetailModel.course_qq];
        
        
        [UID font:12 color:normalColor];
        [UID font:12 color:selectColor str:JuuserInfo.uid];
     
        
        self.qqLabel.attributedText = qq;
        self.UIDLabel.attributedText = UID;
        
    }else{
        
        self.nowPriceLabel.text = [NSString stringWithFormat:@"¥%@",newliveDetailModel.price1];
        self.previousLabel.text = [NSString stringWithFormat:@"¥%@",newliveDetailModel.price0];
        self.descLabel.text = newliveDetailModel.simpledescription;
        self.qqLabel.hidden = YES;
        self.UIDLabel.hidden = YES;

    }
    
    
    
    
    
    
}



-(void)setOrderModel:(JUOrderModel *)orderModel{
    
    _orderModel = orderModel;
    
    
    self.titlelab.text = orderModel.course_title;
    
    self.nowPriceLabel.text = [NSString stringWithFormat:@"¥%@",orderModel.price1];
    self.previousLabel.text = [NSString stringWithFormat:@"¥%@",orderModel.price0];
    
    
    
    NSURL *url = [NSURL URLWithString:orderModel.image_name];
    
    [self.imv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"smallloading"]];
    
    
    
    self.qqLabel.hidden = YES;
    self.UIDLabel.hidden = YES;
    
    
}






@end
