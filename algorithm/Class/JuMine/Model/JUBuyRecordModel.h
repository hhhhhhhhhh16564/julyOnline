//
//  JUBuyRecordModel.h
//  七月算法_iPad
//
//  Created by pro on 16/6/28.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUModel.h"

@interface JUBuyRecordModel : JUModel

//video_course_name = 4 月机器学习算法班,
//v_course_id = 35,
//img = http://www.julyedu.com/Public/Image/5707cde450dcc.jpg,
//description = 历时一年打磨、入门实战首选、实时答疑

@property(nonatomic, strong) NSString *video_course_name;
@property(nonatomic, strong) NSString *v_course_id;
@property(nonatomic, strong) NSString *img;
@property(nonatomic, strong) NSString *courseDescription;





@end
