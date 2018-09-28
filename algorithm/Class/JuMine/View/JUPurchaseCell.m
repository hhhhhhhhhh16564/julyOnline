//
//  JUPurchaseCell.m
//  algorithm
//
//  Created by 周磊 on 16/9/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUPurchaseCell.h"

@interface JUPurchaseCell ()
@property(nonatomic, strong) UIImageView *imv;
@property(nonatomic, strong) UILabel *titlelab;

@property(nonatomic, strong) UILabel *descriptionLabel;

@property(nonatomic, strong) UILabel *qqLabel;

@end


@implementation JUPurchaseCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self p_setupSubViews];
    }
    
    return self;
    
    
}



-(void)p_setupSubViews{
    
    UIImageView *imv = [[UIImageView alloc]init];
    [self.contentView addSubview:imv];
    self.imv = imv;
    //    self.imv.backgroundColor = [UIColor redColor];
    
    
    UILabel *titlelab = [[UILabel alloc]init];
    [self.contentView addSubview:titlelab];
    titlelab.font = UIptfont(14);
    self.titlelab = titlelab;
    
    
    UILabel *descriptionLabel = [[UILabel alloc]init];
    [self.contentView addSubview:descriptionLabel];
    descriptionLabel.font = UIptfont(12);
    descriptionLabel.numberOfLines = 2;
    descriptionLabel.textColor = Hcgray(1);
    self.descriptionLabel = descriptionLabel;
    
    UILabel *qqLabel = [[UILabel alloc]init];
    qqLabel.font = UIptfont(12);
    qqLabel.textColor = Hmblue(1);
    [self.contentView addSubview:qqLabel];
    
    self.qqLabel = qqLabel;
    
    
    
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HCommomSeperatorline(1);
    
    [self.contentView addSubview:lineView];
    
    self.lineView = lineView;
    
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    [self.imv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(125, 90));
    }];
    
    [self.titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imv.mas_right).offset(15);
        make.top.equalTo(weakSelf.imv.mas_top);
        

        make.right.mas_equalTo(-12);

    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titlelab);

        make.top.equalTo(weakSelf.titlelab.mas_bottom).offset(15);

        make.right.mas_equalTo(-12);
        
        
    }];
    
    [self.qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titlelab);
        make.right.mas_equalTo(-12);
        make.bottom.equalTo(weakSelf.imv);
        
        
    }];
    
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];
    
    
}



-(void)setPurchaseModel:(JUPurchaseModel *)purchaseModel{
    
    _purchaseModel = purchaseModel;
    
    
    /**
     *  @property(nonatomic, strong) UIImageView *imv;
     @property(nonatomic, strong) UILabel *titlelab;
     
     @property(nonatomic, strong) UILabel *descriptionLabel;
     
     @property(nonatomic, strong) UILabel *qqLabel;
     */
    
    NSURL *url = [NSURL URLWithString:purchaseModel.image_name];
    [self.imv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"smallloading"]];
    self.titlelab.text = purchaseModel.course_title;
    self.descriptionLabel.text = purchaseModel.simpledescription;
    self.qqLabel.text = [NSString stringWithFormat:@"上课QQ群:  %@", purchaseModel.course_qq];
    


    
    
    
    
    
    
}












@end
