//
//  JUCompendiumContentCell.m
//  algorithm
//
//  Created by yanbo on 17/10/20.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUCompendiumContentCell.h"

#import "NSMutableAttributedString+Extension.h"
@implementation JUCompendiumContentCell



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
    self.contentLabel.font = UIptfont(13);
    
    UIColor *normalColor = Kcolor16rgb(@"#666666", 1);
    self.contentLabel.textColor = normalColor;
    
}


-(void)setCompentDiumModel:(JUCompentDiumModel *)CompentDiumModel{
    _CompentDiumModel = CompentDiumModel;
    self.contentLabel.text = nil;
    self.contentLabel.attributedText = nil;

    
    
    if (CompentDiumModel.redContent) {
        NSString *content = [NSString stringWithFormat:@"%@%@", CompentDiumModel.redContent,CompentDiumModel.content];
        NSMutableAttributedString *attributeContent = content.mutableAttributedString;
        UIColor *normalColor = Kcolor16rgb(@"#666666", 1);
        UIColor *redColor = Kcolor16rgb(@"#e81e1e", 1);
        
        [attributeContent font:13 color:normalColor];
        [attributeContent font:13 color:redColor str:CompentDiumModel.redContent];
        self.contentLabel.attributedText = attributeContent;
        
    }else{
        
        self.contentLabel.text = CompentDiumModel.content;

        
    }

    
}


-(void)layoutSubviews{
    
    //cell高度为 22
    
    [super layoutSubviews];
    
    self.contentLabel.frame = CGRectMake(22, 0, Kwidth-22-12, self.bounds.size.height);

 
    
}
@end
