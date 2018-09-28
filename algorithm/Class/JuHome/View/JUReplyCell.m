//
//  JUReplyCell.m
//  algorithm
//
//  Created by 周磊 on 16/11/25.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUReplyCell.h"
#import "JUReplayController.h"
#import "JULoginViewController.h"

#import "AppDelegate.h"
#import "JUBaseNavigationController.h"

@interface JUReplyCell ()

@property(nonatomic, strong) UILabel *contentLabel;

@property(nonatomic, strong) UIButton *replayButton;

@property(nonatomic, strong) UIButton *seeMoreButton;


@end


@implementation JUReplyCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self p_setupViews];
        
         UIColor *color = Kcolor16rgb(@"F1F1F1", 1);
        
        self.backgroundColor = color;
        
        
    }
    
    return self;
    
}

-(void)p_setupViews{

    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = UIptfont(10);
    contentLabel.numberOfLines = 0;
    contentLabel.font = UIptfont(11);
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    
    UIButton *replyButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    [replyButton addTarget:self action:@selector(replyButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [replyButton setImage:[UIImage imageNamed:@"pinglun@copy"] forState:(UIControlStateNormal)];
    [self.contentView addSubview:replyButton];
    self.replayButton = replyButton;


//    UIButton *seeMoreButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [seeMoreButton setTitle:@"查看更多>>" forState:(UIControlStateNormal)];
//    [seeMoreButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
//    [seeMoreButton.titleLabel setFont: UIptfont(10)];
//    [self.contentView addSubview: seeMoreButton];
//    self.seeMoreButton = seeMoreButton;
    
    
    
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
   
//    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.mas_equalTo(5);
//        make.right.mas_equalTo(-49);
//        make.top.mas_equalTo(0);
//        
//    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-49);
        make.top.mas_equalTo(6);
        
    }];
    
    
    
    [self.replayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(-4);
        make.size.mas_equalTo(CGSizeMake(24, 20.5));
        make.right.mas_equalTo(0);
        
        
    }];

    
}


-(void)replyButtonAction:(UIButton *)button
{
    
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    JUBaseNavigationController *navc  = delegate.window.rootViewController.childViewControllers[0];
    
    if (!JuuserInfo.isLogin) {
 
        [navc pushViewController:[[JULoginViewController alloc]init] animated:NO];
        
        return;
        
    }

    
    
    JUReplayController *replyVC = [[JUReplayController alloc]init];
    replyVC.commentModel = self.commentModel;
    
    
    
    
    JUBaseNavigationController *replyNa = [[JUBaseNavigationController alloc]initWithRootViewController:replyVC];
    
    [navc presentViewController:replyNa animated:NO completion:nil];
    
    
    
}



-(void)setCommentModel:(JUCommentModel *)commentModel{
    
    
    _commentModel = commentModel;
    
    
    self.contentLabel.attributedText = commentModel.artibutedString;
    
}



@end
