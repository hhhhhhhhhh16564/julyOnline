//
//  JUCompendiumTitleCell.m
//  algorithm
//
//  Created by yanbo on 17/10/20.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUCompendiumTitleCell.h"

@interface JUCompendiumTitleCell ()
@property(nonatomic, strong) UILabel *whiteLabel;
@property(nonatomic, strong) UILabel *contentLabel;

@end

@implementation JUCompendiumTitleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = kColorRGB(244, 244, 244, 1);

        
        [self setUpViews];
        
    }
    
    return self;
    
}

-(void)setUpViews{
    
    
    self.whiteLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.whiteLabel];
    self.whiteLabel = self.whiteLabel;
    self.whiteLabel.backgroundColor = [UIColor whiteColor];
    
    
    self.contentLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel = self.contentLabel;
    self.contentLabel.font = UIptfont(13);
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = Kcolor16rgb(@"0099ff", 1);
    
    
    UIImageView *imv = [[UIImageView alloc]init];
    [self.contentView addSubview:imv];
    imv.image = [UIImage imageNamed:@"play_icon"];
    self.imv = imv;
    

    
}
-(void)setCompentDiumModel:(JUCompentDiumModel *)CompentDiumModel{
    _CompentDiumModel = CompentDiumModel;

    self.contentLabel.text = CompentDiumModel.content;
    
    if ([CompentDiumModel.video_id isEqualToString:@"0"]) {
        self.imv.hidden = YES;
    }else{
        
        self.imv.hidden = NO;
    }
    
}



-(void)layoutSubviews{
    

    // 高度为内容高度+12
    [super layoutSubviews];
    
    self.whiteLabel.frame = CGRectMake(12, 4, Kwidth-24, self.CompentDiumModel.contentHeigth);
//    [self.whiteLabel y_extension];
    
    self.contentLabel.frame = CGRectMake(self.whiteLabel.x_extension+10, self.whiteLabel.y_extension, self.CompentDiumModel.MaxWidth, self.CompentDiumModel.contentHeigth);
//    [self.contentLabel y_extension];
    
    self.contentLabel.centerY_extension = self.whiteLabel.centerY_extension;
    
    self.imv.frame = CGRectMake(0, 0, 15, 15);
    self.imv.right_extension = self.whiteLabel.right_extension-15;
    [self.imv Y_centerInSuperView];
    self.imv.y_extension -= 2;
    
    
}



























@end
