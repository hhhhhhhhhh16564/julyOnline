//
//  JURecommandCell.m
//  algorithm
//
//  Created by pro on 17/9/23.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JURecommandCell.h"
#import "JUDeletelineLabel.h"

@interface JURecommandCell ()


@property(nonatomic, strong) UIImageView *imv;
@property(nonatomic, strong) UILabel *titlelab;

@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UILabel *nowPriceLabel;

@property(nonatomic, strong) JUDeletelineLabel *previousLabel;


@end


@implementation JURecommandCell
//
//
//-(instancetype)initWithFrame:(CGRect)frame{
//    
//    self = [super initWithFrame:frame];
//    
//    if (self) {
//        
//        [self p_setupViews];
//        
//    }
//    return self;
//}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self p_setupViews];
        
    }
    return self;
    
    
}




-(void)p_setupViews{
    
    UIImageView *imv = [[UIImageView alloc]init];
    [self.contentView addSubview:imv];
    self.imv = imv;
    self.imv.backgroundColor = [UIColor redColor];
    
    
    UILabel *titlelab = [[UILabel alloc]init];
    [self.contentView addSubview:titlelab];
    titlelab.font = UIptfont(15);
    self.titlelab = titlelab;
    //    self.titlelab.backgroundColor = [UIColor greenColor];
    
    
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.numberOfLines = 2;
    detailLabel.font = UIptfont(13);
    detailLabel.textColor = Kcolor16rgb(@"#666666", 1);
    
    [self.contentView addSubview:detailLabel];
    self.detailLabel = detailLabel;
    
    
    
    
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.textColor = [UIColor redColor];
    
    priceLabel.font = UIptfont(18);
    [self.contentView addSubview:priceLabel];
    
    self.nowPriceLabel = priceLabel;
    
    
    
    
    JUDeletelineLabel *previousLabel = [[JUDeletelineLabel alloc]init];
    previousLabel.textColor = Hcgray(1);
    
    previousLabel.font = UIptfont(11);
    [self.contentView addSubview:previousLabel];
    
    self.previousLabel = previousLabel;
    
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HCommomSeperatorline(1);
    
    [self.contentView addSubview:lineView];
    
    self.lineView = lineView;
    
    self.lineView.hidden = YES;
    
 //   [self.contentView colorForSubviews];

    self.imv.backgroundColor = [UIColor redColor];
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
  
    CGFloat kItemHeitht = Kwidth*0.4*0.72;
    
    
    [self.imv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(kItemHeitht);
        make.width.mas_equalTo(Kwidth*0.4);
        
        
    }];
    
    
    
    [self.titlelab mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        
        make.left.equalTo(self.imv.mas_right).offset(12);
        
        make.right.mas_equalTo(-12);
        
        make.top.equalTo(self.imv.mas_top).offset(0);
        make.height.mas_equalTo(15);
        
        
        
    }];
    
    
    
    
    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titlelab);
        
        make.top.equalTo(self.titlelab.mas_bottom).and.offset(15);
        make.height.mas_equalTo(13);
        
        make.right.mas_equalTo(-12);
        
        
        
        
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
    
    
    
}

-(void)setLiveModel:(JULiveModel *)liveModel{
//        self.imv.backgroundColor = [UIColor greenColor];
//    
//        self.titlelab.text = @"撒旦飞洒";
//    
//    
//        self.detailLabel.text = @"开始的房价快速减肥了双方交流交流了解";
//        self.nowPriceLabel.text = @"1000￥";
//    
//        self.previousLabel.text = @"2345￥";
    
    
    _liveModel = liveModel;
    
    self.titlelab.text = liveModel.course_title;
    
    
    self.detailLabel.text = liveModel.simpledescription;
    self.nowPriceLabel.text = [NSString stringWithFormat:@"¥%@",liveModel.price1];
    self.previousLabel.text = [NSString stringWithFormat:@"¥%@",liveModel.price0];
    [self.imv sd_setImageWithURL:[NSURL URLWithString:liveModel.image_name] placeholderImage:[UIImage imageNamed:@"smallloading"]];
    
    
    
}










@end
