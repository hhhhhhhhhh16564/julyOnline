//
//  JULiveDetailModel.h
//  algorithm
//
//  Created by 周磊 on 16/9/9.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUModel.h"

@interface JULiveDetailModel : JUModel

@property (nonatomic, strong) NSString *catalog;

@property (nonatomic, strong) NSString *price0;

@property (nonatomic, strong) NSString *price1;

@property (nonatomic, strong) NSString *is_buy;

@property (nonatomic, strong) NSString *start_time;

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSString *intro;

@property (nonatomic, strong) NSString *course_title;

@property (nonatomic, strong) NSString *course_id;



@property (nonatomic, strong) NSString *simpledescription;

//课程时长
@property(nonatomic, strong) NSString *course_hour;

// v_id

@property(nonatomic, strong) NSString *v_id;

// 报名状态
@property(nonatomic, strong) NSString *status;


//优惠价格
@property(nonatomic, strong) NSString *level_price;

//优惠等级
@property(nonatomic, strong) NSString *level;

@property(nonatomic, strong) NSString *coupon_amount;


//分享
@property(nonatomic, strong) NSString *share_url;
@property(nonatomic, strong) NSString *share_img;






// 课程详情更改


//"course_hour": "8\u6b21\u8bfe [\u6bcf\u6b21\u8bfe\u81f3\u5c112\u5c0f\u65f6\uff0c\u8bfe\u4e0a\u8bfe\u540e\u7b54\u7591]",
//"course_title": "\u81ea\u7136\u8bed\u8a00\u5904\u7406\u73ed [NLP\u5de5\u7a0b\u5e08\u7684\u6700\u4f73\u5165\u95e8\u8bfe\u7a0b]",
//"teacher_id": 0,
//"price0": 1000,
//"price1": 299,
//"image_name": "http:\/\/www.julyedu.com\/Public\/Image\/7629a96f3f.jpg",
//"isbaoming": 1,
//"course_qq": "595419496",
//"simpledescription": "NLP\u73ed\uff0c\u539f\u7406\u548c\u5b9e\u6218\u4e00\u5e94\u4ff1\u5168",
//"start": 0,
//"start_time": "8\u6b21\u76f4\u64ad\u8bfe\u5df2\u4e0a\u5b8c\uff0c\u73b0\u5728\u62a5\u540d\u770b\u89c6\u9891",
//"intro": ,
//"is_baoming": 0,
//"is_group": 1,
//"teacher_name": "\u4e03\u6708\u7b97\u6cd5",
//"in_cart": 0
//



@property (nonatomic, strong) NSString *start;

//@property (nonatomic, strong) NSString *price1;

//@property (nonatomic, strong) NSString *intro;

//@property (nonatomic, strong) NSString *course_hour;

@property (nonatomic, strong) NSString *in_cart;

//@property (nonatomic, strong) NSString *price0;

@property (nonatomic, strong) NSString *teacher_name;

@property (nonatomic, strong) NSString *isbaoming;

//@property (nonatomic, strong) NSString *start_time;

@property (nonatomic, strong) NSString *teacher_id;

//@property (nonatomic, strong) NSString *course_title;

@property (nonatomic, strong) NSString *course_qq;

//@property (nonatomic, strong) NSString *simpledescription;

@property (nonatomic, strong) NSString *is_baoming;

@property (nonatomic, strong) NSString *is_group;

@property(nonatomic, strong) NSString *image_name;

@property (nonatomic, strong) NSString *group_status;

@property (nonatomic, strong) NSString *amount;

@property (nonatomic, strong) NSString *is_vip;

@property (nonatomic, strong) NSArray *service;

@property(nonatomic, strong) NSString *customer;

@property(nonatomic, strong) NSString *teachers;

@property(nonatomic, strong) NSString *v_course_id;



@end
