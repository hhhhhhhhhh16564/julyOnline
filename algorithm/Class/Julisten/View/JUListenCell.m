//
//  JUListenCell.m
//  algorithm
//
//  Created by 周磊 on 16/11/30.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUListenCell.h"

@interface JUListenCell ()

@property(nonatomic, strong) UIImageView *iconImv;

@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UILabel *countLabel;

@property(nonatomic, strong) UILabel *descriptionLabel;

@property(nonatomic, strong) UIView *lineView;

@property(nonatomic, strong) UIImageView *imv;

@property(nonatomic, strong) UIView *bgView;


@end



@implementation JUListenCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
//        self.backgroundColor = Kcolor16rgb(@"#000000", 0.4);
        
//        self.backgroundColor = [UIColor grayColor];
        self.backgroundColor = [UIColor clearColor];
        
        [self setUpViews];
        
    }
    
    return self;
    
}

-(void)setUpViews{
    
    UIImageView *iconImv = [[UIImageView alloc]init];
    iconImv.layer.masksToBounds = YES;
    iconImv.layer.cornerRadius = 50;
    iconImv.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:iconImv];
    self.iconImv = iconImv;
    
    
    
    UIView *bgView = [[UIView alloc]init];
    bgView.layer.cornerRadius = 30;
    bgView.layer.masksToBounds = YES;
    bgView.alpha = 0.7;
    [self.iconImv addSubview:bgView];
    bgView.backgroundColor = [UIColor blackColor];
    self.bgView = bgView;
    
    UIImageView *imv = [[UIImageView alloc]init];
    imv.image = [UIImage imageNamed:@"playmusic"];
    [self.iconImv addSubview:imv];
    self.imv = imv;
    
    

    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = UIptfont(14);
    titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    
    
    UILabel *countLabel = [[UILabel alloc]init];
    countLabel.font = UIptfont(12);
    countLabel.textColor = Hcgray(1);
    [self.contentView addSubview:countLabel];
    self.countLabel = countLabel;
    
    
    UILabel *descriptionLabel = [[UILabel alloc]init];
    descriptionLabel.font = UIptfont(12);
    descriptionLabel.textColor = Hcgray(1);

    descriptionLabel.numberOfLines = 0;
    [self.contentView addSubview:descriptionLabel];
    self.descriptionLabel = descriptionLabel;

    
    
    UIView *lineViwe = [[UIView alloc]init];
    lineViwe.backgroundColor = Hcgray(0.4);
    [self.contentView addSubview:lineViwe];
    self.lineView = lineViwe;
    
    
//    self.iconImv.backgroundColor = [UIColor redColor];
//    self.titleLabel.backgroundColor = [UIColor greenColor];
//    self.countLabel.backgroundColor = [UIColor yellowColor];
//    self.descriptionLabel.backgroundColor = [UIColor orangeColor];
    
    
}



-(void)layoutSubviews{
    
  [super layoutSubviews];
    
    
    self.iconImv.frame = CGRectMake(10, 10, 100, 100);
    [self.iconImv Y_centerInSuperView];
    
    
    self.imv.frame = CGRectMake(0, 0, 60, 60);
//    self.imv.backgroundColor = [UIColor redColor];
    [self.imv XY_centerInSuperView];
    
    self.bgView.frame = self.iconImv.bounds;
    [self.bgView XY_centerInSuperView];
    
    
    self.titleLabel.frame = CGRectMake(self.iconImv.right_extension+20, self.iconImv.y_extension, 150, 20);
    
    self.descriptionLabel.frame = CGRectMake(self.titleLabel.x_extension, self.titleLabel.bottom_extension+10, 150, 35);
    
    self.countLabel.frame = CGRectMake(self.titleLabel.x_extension, self.descriptionLabel.bottom_extension+10, 150, 20);
    
    self.lineView.frame = CGRectMake(20, self.height_extension-1, Kwidth, 1);
    
    
}


-(void)setCourseModel:(JUListenCourseModel *)courseModel{
    
    _courseModel = courseModel;
    [self.iconImv sd_setImageWithURL:[NSURL URLWithString:courseModel.image_name]];
    
    self.titleLabel.text = courseModel.course_title;
    self.descriptionLabel.text = courseModel.simpledescription;
    self.countLabel.text = [NSString stringWithFormat:@"共%zd个", courseModel.lessons.count];
    
    
}



@end
