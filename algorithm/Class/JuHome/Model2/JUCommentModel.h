//
//  JUCommentModel.h
//  algorithm
//
//  Created by 周磊 on 16/11/25.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUModel.h"

@interface JUCommentModel : JUModel


@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *fav_num;

@property (nonatomic, strong) NSMutableArray *reply;

@property (nonatomic, strong) NSString *user_id;

@property (nonatomic, strong) NSString *name;



@property (nonatomic, strong) NSString *add_time;

@property(nonatomic, strong) NSMutableArray<JUCommentModel *> *sortArray;

//改model所属cell的下标
@property (nonatomic,assign) NSInteger index;

//回复人拼接回复内容
@property(nonatomic, strong) NSString *replyjoinContent;


//回复给某人
@property(nonatomic, strong) NSString *replyToName;


//artibutedString

@property(nonatomic, strong) NSMutableAttributedString *artibutedString;


//计算高度
@property (nonatomic,assign) CGFloat replyHeight;
@property (nonatomic,assign) CGFloat CommentHeight;

//tableViewHeight
@property(nonatomic, assign) CGFloat tableViewHeight;


@property(nonatomic, assign) BOOL tableViewIsOpend;





@end
