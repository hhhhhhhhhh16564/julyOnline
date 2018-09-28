//
//  JUCompentDiumModel.h
//  algorithm
//
//  Created by yanbo on 17/10/20.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUModel.h"

typedef enum {
compentDiumModelTypeNotKnow,
compentDiumModelTypeStage,
compentDiumModelTypeTitle,
compentDiumModelTypeContent,

}CompentDiumModelType ;


@interface JUCompentDiumModel : JUModel

@property (nonatomic,assign) CompentDiumModelType type;
@property(nonatomic, strong) NSString *content;
@property (nonatomic,assign) CGFloat contentHeigth;


@property(nonatomic, strong) NSString *video_id;

//实战项目
@property(nonatomic, strong) NSString *redContent;


//当类型是标题的时候 显示内容的最大宽度 compentDiumModelTypeTitle
@property (nonatomic,assign) CGFloat MaxWidth;

@end
