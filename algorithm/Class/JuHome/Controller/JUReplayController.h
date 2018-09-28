//
//  JUReplayController.h
//  algorithm
//
//  Created by 周磊 on 16/11/24.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUBaseViewController.h"
#import "JUCommentModel.h"

@interface JUReplayController : JUBaseViewController


//@property (nonatomic,assign) BOOL isReplyComment;

@property(nonatomic, strong) JUCommentModel *commentModel;

@property(nonatomic, strong) JULessonModel *lessonModel;

@end
