//
//  JUTeacherListCell.m
//  七月算法_iPad
//
//  Created by pro on 16/6/2.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUTeacherListCell.h"
#import "JUTeacherModel.h"

@interface JUTeacherListCell ()

@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UILabel *nameLab;
@property(nonatomic, strong) UILabel *detailLab;
@property(nonatomic, strong) UIImageView *iconImv;

@end

@implementation JUTeacherListCell

-(void)p_setupViews{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = HCommomSeperatorline(1);
    [self.contentView addSubview:line];
    self.lineView = line;
    
    
    UILabel *namelab = [[UILabel alloc]init];
    namelab.font = UIptfont(12);
    namelab.textColor = Hmblack(1);
    namelab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:namelab];
    self.nameLab = namelab;
    
    
    UIImageView *iconImv = [[UIImageView alloc]init];
    iconImv.layer.cornerRadius = 4;
    iconImv.layer.masksToBounds = YES;
    [self.contentView addSubview:iconImv];
    self.iconImv = iconImv;
    
    
    
    
    UILabel *detailLab = [[UILabel alloc]init];
    detailLab.font = UIptfont(14);
    detailLab.textColor = Hmblack(1);
    detailLab.numberOfLines = 0;
    [self.contentView addSubview:detailLab];
    self.detailLab = detailLab;
    

}




-(void)layoutSubviews{
    
    [super layoutSubviews];
     __weak typeof(self) weakSelf = self;

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
        
    }];
    

    [self.iconImv mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.top.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        
    }];
    
    [self.detailLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.left.equalTo(weakSelf.iconImv.mas_right).offset(12);
        
    }];
    
    [self.nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(weakSelf.iconImv.mas_bottom).offset(12);
        
        
    }];

    
    
}

#pragma 等待改进


+(CGFloat)calculateHeightwithString:(JUTeacherModel *)teacherModel{

    CGFloat detaiLabelWidth = Kwidth-24-50-12;
    
    NSAttributedString *attributedString = [teacherModel.desc getAttributedStringWithString:teacherModel.desc lineSpace:6 fontsize:14];

    
   CGFloat detailLabelHeight = [attributedString boundingRectWithSize:CGSizeMake(detaiLabelWidth, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    
//    CGFloat detailLabelHeight = [teacherModel.desc sizeWithFont:UIptfont(14) maxW:detaiLabelWidth].height;
    
    CGFloat cellHeight = detailLabelHeight > 50+12+12 ? detailLabelHeight : 74;
    
    return cellHeight+24.5;
    
    
    
}


-(void)setTeacherModel:(JUTeacherModel *)teacherModel
{
    _teacherModel = teacherModel;
    
//    self.detailLab.text = teacherModel.desc;
    self.nameLab.text = teacherModel.teacher_name;
//    NSString *urlstring = [NSString stringWithFormat:@"%@%@",teacherURL ,teacherModel.thumb_img];
    NSURL *url = [NSURL URLWithString:teacherModel.img];
    [self.iconImv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"smallloading"]];
    NSAttributedString *attributedString = [teacherModel.desc getAttributedStringWithString:teacherModel.desc lineSpace:6 fontsize:14];
    self.detailLab.attributedText = attributedString;
    
}





@end
