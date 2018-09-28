//
//  JUCompendiumController.h
//  algorithm
//
//  Created by yanbo on 17/10/20.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUBaseViewController.h"
#import "JULiveDetailModel.h"
#import "JUCompentDiumModel.h"

@class JUCompendiumController;
@protocol CompendiumControllerDelegate <NSObject>

-(void)CompendiumController:(JUCompendiumController *)controller DidClickPlayButton:(JUCompentDiumModel *)Model;


@end


@interface JUCompendiumController : JUBaseViewController

@property(nonatomic, strong) UITableView *mainTableView;

@property(nonatomic, strong) NSArray *sourceArray;


@property(nonatomic, strong) JULiveDetailModel *liveModel;

@property(nonatomic, weak)id<CompendiumControllerDelegate> delegate;


// 如果大纲中的第一个视频video_id 为0， 则下边所有视频的Video_id 都为0， 视频没有上传，不能观看， 则观看视频的按钮就没必要点击响应了

@property(nonatomic, assign)BOOL isWached;



@end
 
