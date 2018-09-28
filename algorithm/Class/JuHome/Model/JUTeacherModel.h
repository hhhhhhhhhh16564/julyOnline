//
//  JUTeacherModel.h
//  七月算法_iPad
//
//  Created by 周磊 on 16/6/1.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUModel.h"

@interface JUTeacherModel : JUModel

//专注数据领域的在线教育，目前所开课程包括：求职、算法、机器学习、深度学习、数据挖掘等等，即将新开CV、NLP班。

@property(nonatomic, strong) NSString *desc;

//2
@property(nonatomic, strong) NSString *ID;


//574570e99511b.jpg
@property(nonatomic, strong) NSString *thumb_img;

@property(nonatomic, strong) NSString *img;

//七月算法
@property(nonatomic, strong) NSString *teacher_name;

@end
