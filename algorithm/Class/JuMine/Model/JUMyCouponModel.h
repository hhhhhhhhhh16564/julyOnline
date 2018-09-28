//
//  JUMyCouponModel.h
//  algorithm
//
//  Created by 周磊 on 17/1/24.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUModel.h"

@interface JUMyCouponModel : JUModel

////金额
//@property (nonatomic, strong) NSString *amount;
//
////过期时间
//@property (nonatomic, strong) NSString *expire_time;
//
////优惠码
//@property (nonatomic, strong) NSString *code;
//
//
//@property (nonatomic,assign) NSInteger category;
//
//@property (nonatomic,assign) NSInteger selected;





//"id": 36180,
//"amount": 100,
//"expire_time": 1497369600,
//"ctype": 1,
//"limit_course": 46,
//"course_title": "机器学习与量化交易项目班"

//
@property (nonatomic, strong) NSString *amount;

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *expire_time;

@property (nonatomic, strong) NSString *limit_course;

@property (nonatomic, strong) NSString *course_title;


@property(nonatomic, strong) NSString *ctype;


//标识已经选定使用的课程劵
@property (nonatomic,assign) BOOL selected;



//是否可以用的
@property (nonatomic,assign) BOOL isCanUsed;















@end
