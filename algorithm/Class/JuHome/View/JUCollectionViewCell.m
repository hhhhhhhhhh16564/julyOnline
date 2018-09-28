//
//  JUCollectionViewCell.m
//  七月算法_iPad
//
//  Created by 周磊 on 16/5/25.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUCollectionViewCell.h"
@interface JUCollectionViewCell ()


@property(nonatomic, strong) UIImageView *imv;
@property(nonatomic, strong) UILabel *titlelab;

@end



@implementation JUCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self p_setupViews];
        
    }
    return self;
}

-(void)p_setupViews{
    
    UIImageView *imv = [[UIImageView alloc]init];
    [self.contentView addSubview:imv];
    self.imv = imv;
//    self.imv.backgroundColor = [UIColor redColor];
    
    
    UILabel *titlelab = [[UILabel alloc]init];
    [self.contentView addSubview:titlelab];
    titlelab.font = UIptfont(15);
    self.titlelab = titlelab;
//    self.titlelab.backgroundColor = [UIColor greenColor];
}


-(void)layoutSubviews{
    [super layoutSubviews];

    
    
    CGFloat kItemWith = (Kwidth-15*3)/2;
    CGFloat kItemHeitht = kItemWith * 0.72;

    
    [self.imv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.and.and.right.mas_equalTo(0);
        make.height.mas_equalTo(kItemHeitht);
        
        
        
    }];
    
    
    
    [self.titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imv.mas_bottom).offset(10);
        make.height.mas_equalTo(15);
        make.left.and.right.mas_equalTo(0);
    }];
    
//    [self colorForSubviews];
    
}


-(void)setVideoModel:(JUVideoModel *)videoModel{

    
    _videoModel = videoModel;
    
    NSString *imagePath = [NSString stringWithFormat:@"%@%@",home2PictureAppendURL,videoModel.image];
    
    NSURL *url = [NSURL URLWithString:imagePath];
    [self.imv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"smallloading"]];
    self.titlelab.text = videoModel.video_name;
    
    
}




@end
