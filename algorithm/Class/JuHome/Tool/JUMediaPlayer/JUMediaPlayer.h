//
//  JUMediaPlayer.h
//  algorithm
//
//  Created by 周磊 on 17/2/22.
//  Copyright © 2017年 Julyonline. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "JUMediaModel.h"
typedef void (^restartPlay_block_t)(id);

@class JUMediaPlayer;
@protocol  JUMediaPlayerDelegate <NSObject>
-(void)ju_MediaPlayer:(JUMediaPlayer *)mediaplayer currentPlayTime:(CGFloat)currentTime;
@end
@interface JUMediaPlayer : UIView

@property (nonatomic,copy) restartPlay_block_t restartPlay;

@property(nonatomic, strong) NSString *VideoID;


/**
 *  父控件的view
 */
//@property(nonatomic, strong) UIView *faterView;
@property(nonatomic, strong)  JUMediaModel *mediaModel;

//可选的 option，本项目需要
@property(nonatomic, strong) JULessonModel *lessonModel;

@property (nonatomic,assign) id<JUMediaPlayerDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame;
-(void)play;
-(void)pause;
//停止播放, 要重置播放器
-(void)stop;







@end
