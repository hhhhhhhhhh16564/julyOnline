//
//  JUCourseViewCell.m
//  algorithm
//
//  Created by pro on 16/7/6.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUCourseViewCell.h"

@interface JUCourseViewCell ()


@end
@implementation JUCourseViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(void)p_setupViews{
    
//    self.backgroundColor = HCanvasColor(1);

    
    
    
    JUCourseCellView *cellView = [[[NSBundle mainBundle]loadNibNamed:@"JUCourseCellView" owner:self options:nil]lastObject];
    self.cellView = cellView;
    [self.contentView addSubview:cellView];
    
    
    
    
    
    UIView *lineView = [[UIView alloc]init];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;

    self.lineView.backgroundColor = Kcolor16rgb(@"e7eaf1", 1);
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    self.cellView.frame = self.contentView.bounds;
    
    [self.cellView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        
    }];
    
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(12);
        make.bottom.and.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        
    }];
    
    
//    self.cellView.height_extension = 44;
    
}









@end
