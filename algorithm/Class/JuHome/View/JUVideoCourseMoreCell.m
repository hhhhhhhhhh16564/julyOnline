//
//  JUVideoCourseMoreCell.m
//  algorithm
//
//  Created by 周磊 on 16/9/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUVideoCourseMoreCell.h"

@interface JUVideoCourseMoreCell ()

@property(nonatomic, strong) UIImageView *imv;
@property(nonatomic, strong) UILabel *titlelab;

@property(nonatomic, strong) UILabel *descriptionLabel;



@end


@implementation JUVideoCourseMoreCell


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
    titlelab.font = UIptfont(16);
    self.titlelab = titlelab;
    
    
    UILabel *descriptionLabel = [[UILabel alloc]init];
    [self.contentView addSubview:descriptionLabel];
    descriptionLabel.font = UIptfont(14);
    descriptionLabel.numberOfLines = 2;
    descriptionLabel.textColor = Hcgray(1);
    self.descriptionLabel = descriptionLabel;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HCommomSeperatorline(1);
    
    [self.contentView addSubview:lineView];
    
    self.lineView = lineView;
    
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    [self.imv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(125, 90));
    }];
    
    [self.titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imv.mas_right).offset(15);
        make.top.equalTo(weakSelf.imv.mas_top);
        
        
        
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titlelab);
        make.top.equalTo(weakSelf.titlelab.mas_bottom).offset(18);
        make.right.mas_equalTo(-15);
        
        
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];
    
    
}



-(void)setVideoModel:(JUVideoModel *)videoModel{
    
    _videoModel = videoModel;
    
    NSURL *url = [NSURL URLWithString:videoModel.logo];
    [self.imv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"smallloading"]];
    self.titlelab.text = videoModel.video_course_name;
    self.descriptionLabel.text = videoModel.descp;
    
}


@end
