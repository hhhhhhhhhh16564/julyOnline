//
//  JUCompendiumStageCell.m
//  algorithm
//
//  Created by yanbo on 17/10/20.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUCompendiumStageCell.h"



@implementation JUCompendiumStageCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = kColorRGB(244, 244, 244, 1);

        [self setUpViews];
        
    }
    
    return self;
    
}

-(void)setUpViews{
    
    self.contentLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel = self.contentLabel;
    self.contentLabel.font = UIptfont(14);
    self.contentLabel.textColor = [UIColor blackColor];
    
    
}

-(void)setCompentDiumModel:(JUCompentDiumModel *)CompentDiumModel{
    _CompentDiumModel = CompentDiumModel;
    
    self.contentLabel.text = CompentDiumModel.content;
    
}


-(void)layoutSubviews{
    
//    高度为 15+13+2+1
    [super layoutSubviews];
    
    self.contentLabel.frame = CGRectMake(12, 15, Kwidth, 14);
    
    
    
    
    
    
    
    
    
}






@end
