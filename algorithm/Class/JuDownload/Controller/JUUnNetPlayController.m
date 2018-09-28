//
//  JUUnNetPlayController.m
//  algorithm
//
//  Created by 周磊 on 17/2/17.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUUnNetPlayController.h"
#import "JUMediaPlayerTool.h"

@interface JUUnNetPlayController ()



@end

@implementation JUUnNetPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(0, 64, Kwidth, Kwidth*2/3);
    [self.view addSubview:contentView];
    
    self.navigationItem.title = self.course_title;

    
    
    JUMediaPlayerTool *playTool = [JUMediaPlayerTool shareInstance];
    playTool.mediaPlayer.frame = contentView.bounds;
    [contentView addSubview:playTool.mediaPlayer];

    
    [playTool playVideoWithLessonModel:self.lessonModel];
    
    
    
    

//    JUPlayerTool *playertool = [JUPlayerTool shareInstance];
//    [playertool playVedioWithurl:self.lessonModel.play_url vedioName:_lessonModel.name lessonModel:self.lessonModel];
//    
//    [player changeToFull:nil];
    
    

}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    JUMediaPlayerTool *playTool = [JUMediaPlayerTool shareInstance];

    [playTool stop];
    
}



- (void)dealloc

{
    
//    JUPlayerTool *playertool = [JUPlayerTool shareInstance];
//    
//    [playertool stop];
//    
    JUMediaPlayerTool *playTool = [JUMediaPlayerTool shareInstance];
    
    [playTool stop];
    
    JUlogFunction
    
    
}






@end
