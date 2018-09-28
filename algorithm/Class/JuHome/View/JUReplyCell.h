//
//  JUReplyCell.h
//  algorithm
//
//  Created by 周磊 on 16/11/25.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUBaseTableViewCell.h"
#import "JUCommentModel.h"

@interface JUReplyCell : JUBaseTableViewCell

@property(nonatomic, strong)  JUCommentModel *commentModel;



@property(nonatomic, copy)globalBlock replyBlock;

@end
