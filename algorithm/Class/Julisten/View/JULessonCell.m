//
//  JULessonCell.m
//  algorithm
//
//  Created by 周磊 on 16/12/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JULessonCell.h"
#import "JUMusicTool.h"

@interface JULessonCell()

@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIView *seperatorView;

@property(nonatomic, strong) UILabel *sizeLabel;

@property(nonatomic, strong) UILabel *teacherLabel;

@property(nonatomic, strong) UIButton *button;

@end


@implementation JULessonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self p_setupSubViews];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
    
    
}


-(void)p_setupSubViews{
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = UIptfont(14);
    nameLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    
    UILabel *sizeLabel = [[UILabel alloc]init];
    sizeLabel.textColor = Hcgray(1);
    sizeLabel.font = UIptfont(12);
    [self.contentView addSubview:sizeLabel];
    self.sizeLabel = sizeLabel;
    
    
    
    UILabel *teacherLabel = [[UILabel alloc]init];
    teacherLabel.textColor = [UIColor whiteColor];
    teacherLabel.alpha = 0.8;
    teacherLabel.font = UIptfont(12);
    [self.contentView addSubview:teacherLabel];
    self.teacherLabel = teacherLabel;
    
    
//    
//    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
//    
//    [button setBackgroundImage:[UIImage imageNamed:@"jianPlay"] forState:(UIControlStateSelected)];
//    [button setBackgroundImage:[UIImage imageNamed:@"jianPause"] forState:(UIControlStateNormal)];
//    
//    
//    
//    [self.contentView addSubview:button];
//    self.button = button;
//
    
    

    UIView *seperatorView = [[UIView alloc]init];
    seperatorView.backgroundColor = Hcgray(0.4);
    [self.contentView addSubview:seperatorView];
    self.seperatorView = seperatorView;
    
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.nameLabel.frame = CGRectMake(20, 10, 220, 20);
 
    
    self.teacherLabel.frame = CGRectMake(self.nameLabel.x_extension, self.nameLabel.bottom_extension+5, 50, 15);
    self.sizeLabel.frame = CGRectMake(self.teacherLabel.right_extension, self.teacherLabel.y_extension, 80, 15);

//    self.button.frame = CGRectMake(Kwidth-60, 0, 40, 40);
//    [self.button Y_centerInSuperView];

    self.seperatorView.frame = CGRectMake(10, self.height_extension-0.8, Kwidth-10, 0.8);
    
    
    
    
}

-(void)setLessonModel:(JUListenLessonModel *)lessonModel{

    _lessonModel = lessonModel;
    self.nameLabel.text = lessonModel.name;
    self.sizeLabel.text = [NSString stringWithFormat:@"%@",lessonModel.duration];
    self.teacherLabel.text = lessonModel.teacher;
    
//     JUMusicTool *tool = [JUMusicTool shareInstance];
    
    
    
        JUMusicTool *tool = [JUMusicTool shareInstance];
    
        if (tool.playingLessonModel == self.lessonModel) {
    
            UIColor *selectedColor = [UIColor greenColor];
            self.nameLabel.textColor = selectedColor;
            self.sizeLabel.textColor = selectedColor;
            self.teacherLabel.textColor = selectedColor;
            
    
        }else{
            
            self.nameLabel.textColor = [UIColor whiteColor];
            self.sizeLabel.textColor = Hcgray(1);
            self.teacherLabel.textColor = [UIColor whiteColor];
      
            
            
        }
    
    
    
    
    
}












@end
