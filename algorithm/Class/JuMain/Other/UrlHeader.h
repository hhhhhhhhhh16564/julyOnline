//
//  UrlHeader.h
//  七月算法_iPad
//
//  Created by pro on 16/5/29.
//  Copyright © 2016年 zhl. All rights reserved.
//

#ifndef UrlHeader_h
#define UrlHeader_h


//#ifdef DEBUG
//#define aaaaaaa 0
//
//#else
//#define aaaaaaa 1
//
//#endif
#ifdef DEBUG
#define aaaaaaa 1
#else
#define aaaaaaa 1
#endif




#if aaaaaaa

//在线上环境下
//******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************//


//注册
#define registerURL @"https://api.julyedu.com/u/r"
//登录
#define loginURL @"https://api.julyedu.com/u/l"
//第三方登录
#define thirdLoginURL @"https://api.julyedu.com/u/3l"
//首页 get
#define homeURL @"https://api.julyedu.com/app/algorithm/home2"
//更多
#define moreURL @"https://api.julyedu.com/app/algorithm/home/more/"
//课程页
#define courseURL @"https://api.julyedu.com/app/algorithm/course/"
//增加用户学习记录  post
#define addCourseRecoder @"https://api.julyedu.com/app/algorithm/addLearnRecord"
//得到用户学习记录
#define getCourseRecoder @"https://api.julyedu.com/app/algorithm/learnRecord"
//退出登录 get
#define logoutURL @"https://api.julyedu.com/app/logout"
//视频播放接口 get
#define playVideoURL(ID) @"https://api.julyedu.com/app/algorithm/play/ID"
//获取用户信息
#define getUserInfomation @"https://api.julyedu.com/u/i"
//课程购买记录
#define buyRecord @"https://api.julyedu.com/app/algorithm/buyRecord"
//用户注册协议  ipad
#define registeredAgreement @"https://api.julyedu.com/app/algorithm/agr"

//用户注册协议网址
#define registeredAgreementWebURL @"https://www.julyedu.com/agreement/priv"


//轮播图图片
#define  HeaderImageURL @"https://www.julyedu.com/Public/Image/home/"
//课程图片
#define courseImageURL @"https://www.julyedu.com//Public/Image/"
//视频图片
#define videoURL @"https://www.julyedu.com//Public/Image/"
//教师图片
#define teacherURL @"https://www.julyedu.com/Public/Teacher/"

//是否显示课程  ipad
#define registeredAgreementiPad @"https://api.julyedu.com/ipad/algorithm/show"
#define registeredAgreementiPad2 @"https://api.julyedu.com/ipad/algorithm/show2"


//是否显示课程  iphone
#define registeredAgreementiphone @"https://api.julyedu.com/app/algorithm/show"

#define registeredAgreementiphone2 @"https://api.julyedu.com/app/algorithm/show2"

//******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************//

//*********  2.0/
#pragma mark 2.0版接口

//首页  接口
#define home2URL @"https://api.julyedu.com/app/algorithm/home"


// 首页 直播课程更多GET
#define liveCoursesMoreURL @"https://api.julyedu.com/app/algorithm/home/moreV2/0"


//直播课程页面， 分类
#define liveCourseCatetoryURL @"https://api.julyedu.com/app/algorithm/course/live/"

//首页视频更多

#define videosCoursesMoreURL @"https://api.julyedu.com/app/algorithm/videosMore"

//视频课程页面， 分类
#define VidoeCourseCatetoryURL @"https://api.julyedu.com/app/algorithm/video/c/"


//首页图片拼接地址
#define home2PictureAppendURL @"https://www.julyedu.com/Public/Image/"

//直播课程详情
//#define liveCourseDetailURL @"https://api.julyedu.com/app/algorithm/course2/"

#define liveCourseDetailURL @"https://api.julyedu.com/app/v26/course/"

//我要报名
#define applicantViewControllerURL @"https://api.julyedu.com/pay/apply/"

//保存用户信息  URL POST
#define saveUserInformationURL @"https://api.julyedu.com/pay/saveUserInfo"

//优惠信息
#define priceLevelInfoURL @"https://api.julyedu.com/app/algorithm/course/priceLevelInfo/"


//确认订单  POST
#define createOrderURL @"https://api.julyedu.com/pay/createOrder"



//去支付  POST
#define payOrderURL @"https://api.julyedu.com/pay/payOrder"


//验证优惠码
#define validCouponURL @"https://api.julyedu.com/pay/validCoupon"



//我的订单
#define myOrdersURL @"https://api.julyedu.com/my/orders"


//我的课程
#define myCoursesURL @"https://api.julyedu.com/my/courses"


//*******************************************************************************************************//
#pragma mark 2.1版本接口

#define liveCourseCatetoryURL2_1 @"https://api.julyedu.com/app/algorithm/home/live/moreV2_1"

#define vedioCourseCatetoryURL2_1 @"https://api.julyedu.com/app/algorithm/home/video/moreV2_1"

#define applepayURL @"https://api.julyedu.com/app/applepay"


#define GetCommentURL @"https://api.julyedu.com/app/algorithm/comment/get"


#define SumminCommentURL @"https://api.julyedu.com/app/algorithm/comment/add"

#define ReplyCommentURL @"https://api.julyedu.com/app/algorithm/comment/reply/"


#define favourRUL @"https://api.julyedu.com/app/algorithm/comment/favour/"



//2.3版本接口
//购物车商品数量
#define shoppingCarNumURL @"https://api.julyedu.com/cart/num"

//加入购物车
#define addShoppingCarURL @"https://api.julyedu.com/cart/add/"

//从购物车中移除商品
#define removeFromShoppingCarURL @"https://api.julyedu.com/cart/remove/"

//购物车

#define getShoppingCarURL @"https://api.julyedu.com/cart/cart"

//修改购物车

#define changeShoppingCarURL @"https://api.julyedu.com/cart/change"


//是否在购物车
#define goodInShoppingCarURL @"https://api.julyedu.com/cart/inCart/"


//结算页
#define countShoppingCarURL @"https://api.julyedu.com/cart/check"

//我的优惠券【GET}

#define myCouponCodeURL @"https://api.julyedu.com/my/coupon"

//删除订单
#define deleteOrderURL @"https://api.julyedu.com/order/delete/"


//订单详情
#define orderDetailURL @"https://api.julyedu.com/order/detail/"

//提交订单
#define submitOrderURL @"https://api.julyedu.com/app/v26/cart/order"

//使用优惠券
#define useCouponCodeURL @"https://api.julyedu.com/cart/coupon"

//取消使用优惠券
#define cancelUseCouponCodeURL @"https://api.julyedu.com/cart/cancelCoupon"

// 我的订单
#define shoppingCarOrderURL @"https://api.julyedu.com/my/orders2"

//获得上次视频的播放位置
#define getLastVideoPlayPosition @"https://api.julyedu.com/app/video/lastTime/"


//获得用户的学习记录2
#define getUserLearnRecord2 @"https://api.julyedu.com/app/algorithm/learnRecord2"



//兑换优惠券 couponExchange
#define couponExchangeURL @"https://api.julyedu.com/app/coupon/exchange"


//我的优惠券
#define allMyCouponURL @"https://api.julyedu.com/app/coupon/all"


// 查看课程优惠券
#define checkCourseCouponURL @"https://api.julyedu.com/app/coupon/check/"


//选中使用优惠券
#define couponSelectURL @"https://api.julyedu.com/app/coupon/select"


//取消使用优惠券
#define couponCancelURL @"https://api.julyedu.com/app/v26/coupon/cancel/"

//分享领劵
#define shareCouponURL @"https://api.julyedu.com/app/v26/shareCoupon"


//确定订单页面
#define v26cartCheckURL @"https://api.julyedu.com/app/v26/cart/check"




#pragma mark  3.0版本接口

// 在学课程
#define V30StudyingCourse @"https://api.julyedu.com/app/home/v30/learning"


// 免费课程   
#define V30freeCourses @"https://api.julyedu.com/app/home/v30/freeCourses"

// 获取用户信息
#define V30getUserInfoMation @"https://api.julyedu.com/u/i/v30"

// 选课推荐
#define V30recommendCourse @"https://api.julyedu.com/app/algorithm/home/v30/recommend"

// 登录
#define V30LoginURL @"https://api.julyedu.com/u/l/v30"


// 数据请求

#define V31CourseURL @"https://api.julyedu.com/app/algorithm/course/coursev31/"


// 完善信息

#define V31personinfo @"https://api.julyedu.com/app/personinfo"

// 拼团支付  api.julyedu.com/app/grouppay
#define V31Grouppay @"https://api.julyedu.com/app/grouppay"




#else




































//在线下边环境下
//******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************//




#define registerURL @"http://api.julyedu.com/u/r"
//登录
#define loginURL @"http://api.julyedu.com/u/l"
//第三方登录
#define thirdLoginURL @"http://api.julyedu.com/u/3l"
//首页 get
#define homeURL @"http://api.julyedu.com/app/algorithm/home2"
//更多
#define moreURL @"http://api.julyedu.com/app/algorithm/home/more/"
//课程页
#define courseURL @"http://api.julyedu.com/app/algorithm/course/"
//增加用户学习记录  post
#define addCourseRecoder @"http://api.julyedu.com/app/algorithm/addLearnRecord"
//得到用户学习记录
#define getCourseRecoder @"http://api.julyedu.com/app/algorithm/learnRecord"
//退出登录 get
#define logoutURL @"http://api.julyedu.com/app/logout"
//视频播放接口 get
#define playVideoURL(ID) @"http://api.julyedu.com/app/algorithm/play/ID"
//获取用户信息
#define getUserInfomation @"http://api.julyedu.com/u/i"
//课程购买记录
#define buyRecord @"http://api.julyedu.com/app/algorithm/buyRecord"
//用户注册协议  ipad
#define registeredAgreement @"http://api.julyedu.com/app/algorithm/agr"

//用户注册协议网址
#define registeredAgreementWebURL @"http://www.julyedu.com/agreement/priv"


//轮播图图片
#define  HeaderImageURL @"http://www.julyedu.com/Public/Image/home/"
//课程图片
#define courseImageURL @"http://www.julyedu.com//Public/Image/"
//视频图片
#define videoURL @"http://www.julyedu.com//Public/Image/"
//教师图片
#define teacherURL @"http://www.julyedu.com/Public/Teacher/"

//是否显示课程  ipad
#define registeredAgreementiPad @"http://api.julyedu.com/ipad/algorithm/show"
#define registeredAgreementiPad2 @"http://api.julyedu.com/ipad/algorithm/show2"


//是否显示课程  iphone
#define registeredAgreementiphone @"http://api.julyedu.com/app/algorithm/show"

#define registeredAgreementiphone2 @"http://api.julyedu.com/app/algorithm/show2"


//******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************//

//*********  2.0/
#pragma mark 2.0版接口

//首页  接口
#define home2URL @"http://api.julyedu.com/app/algorithm/home"


// 首页 直播课程更多GET
#define liveCoursesMoreURL @"http://api.julyedu.com/app/algorithm/home/moreV2/0"


//直播课程页面， 分类
#define liveCourseCatetoryURL @"http://api.julyedu.com/app/algorithm/course/live/"

//首页视频更多

#define videosCoursesMoreURL @"http://api.julyedu.com/app/algorithm/videosMore"

//视频课程页面， 分类
#define VidoeCourseCatetoryURL @"http://api.julyedu.com/app/algorithm/video/c/"


//首页图片拼接地址
#define home2PictureAppendURL @"http://www.julyedu.com/Public/Image/"

//直播课程详情
//#define liveCourseDetailURL @"http://api.julyedu.com/app/algorithm/course2/"
#define liveCourseDetailURL @"http://api.julyedu.com/app/v26/course/"




//我要报名
#define applicantViewControllerURL @"http://api.julyedu.com/pay/apply/"

//保存用户信息  URL POST
#define saveUserInformationURL @"http://api.julyedu.com/pay/saveUserInfo"

//优惠信息
#define priceLevelInfoURL @"http://api.julyedu.com/app/algorithm/course/priceLevelInfo/"


//确认订单  POST
#define createOrderURL @"http://api.julyedu.com/pay/createOrder"



//去支付  POST
#define payOrderURL @"http://api.julyedu.com/pay/payOrder"


//验证优惠码
#define validCouponURL @"http://api.julyedu.com/pay/validCoupon"



//我的订单
#define myOrdersURL @"http://api.julyedu.com/my/orders"


//我的课程
#define myCoursesURL @"http://api.julyedu.com/my/courses"






//*******************************************************************************************************//
#pragma mark 2.1版本接口

#define liveCourseCatetoryURL2_1 @"http://api.julyedu.com/app/algorithm/home/live/moreV2_1"

#define vedioCourseCatetoryURL2_1 @"http://api.julyedu.com/app/algorithm/home/video/moreV2_1"

#define applepayURL @"http://api.julyedu.com/app/applepay"


#define GetCommentURL @"http://api.julyedu.com/app/algorithm/comment/get"


#define SumminCommentURL @"http://api.julyedu.com/app/algorithm/comment/add"

#define ReplyCommentURL @"http://api.julyedu.com/app/algorithm/comment/reply/"


#define favourRUL @"http://api.julyedu.com/app/algorithm/comment/favour/"



//2.3版本接口
//购物车商品数量
#define shoppingCarNumURL @"http://api.julyedu.com/cart/num"

//加入购物车
#define addShoppingCarURL @"http://api.julyedu.com/cart/add/"

//从购物车中移除商品
#define removeFromShoppingCarURL @"http://api.julyedu.com/cart/remove/"

//购物车

#define getShoppingCarURL @"http://api.julyedu.com/cart/cart"



//修改购物车


#define changeShoppingCarURL @"http://api.julyedu.com/cart/change"

// 课程是否在购物车

#define goodInShoppingCarURL @"http://api.julyedu.com/cart/inCart/"



//结算页
#define countShoppingCarURL @"http://api.julyedu.com/cart/check"



//我的优惠券【GET}

#define myCouponCodeURL @"http://api.julyedu.com/my/coupon"

//删除订单
#define deleteOrderURL @"http://api.julyedu.com/order/delete/"


//订单详情
#define orderDetailURL @"http://api.julyedu.com/order/detail/"

//提交订单
#define submitOrderURL @"http://api.julyedu.com/app/v26/cart/order"

//使用优惠券
#define useCouponCodeURL @"http://api.julyedu.com/cart/coupon"

//取消使用优惠券
#define cancelUseCouponCodeURL @"http://api.julyedu.com/cart/cancelCoupon"


// 我的订单
#define shoppingCarOrderURL @"http://api.julyedu.com/my/orders2"


//获得上次视频的播放位置
#define getLastVideoPlayPosition @"http://api.julyedu.com/app/video/lastTime/"

//获得用户的学习记录2
#define getUserLearnRecord2 @"http://api.julyedu.com/app/algorithm/learnRecord2"


//兑换优惠券 couponExchange
#define couponExchangeURL @"http://api.julyedu.com/app/coupon/exchange"


//我的优惠券
#define allMyCouponURL @"http://api.julyedu.com/app/coupon/all"


// 查看课程优惠券
#define checkCourseCouponURL @"http://api.julyedu.com/app/coupon/check/"


//选中使用优惠券
#define couponSelectURL @"http://api.julyedu.com/app/coupon/select"


//取消使用优惠券
#define couponCancelURL @"http://api.julyedu.com/app/v26/coupon/cancel/"

//分享领劵
#define shareCouponURL @"http://api.julyedu.com/app/v26/shareCoupon"

//确定订单页面
#define v26cartCheckURL @"http://api.julyedu.com/app/v26/cart/check"





#pragma mark  3.0版本接口

// 在学课程
#define V30StudyingCourse @"http://api.julyedu.com/app/home/v30/learning"


// 免费课程
#define V30freeCourses @"http://api.julyedu.com/app/home/v30/freeCourses"

// 获取用户信息
#define V30getUserInfoMation @"http://api.julyedu.com/u/i/v30"


// 选课推荐
#define V30recommendCourse @"http://api.julyedu.com/app/algorithm/home/v30/recommend"


// 登录
#define V30LoginURL @"http://api.julyedu.com/u/l/v30"

// 数据请求

#define V31CourseURL @"http://api.julyedu.com/app/algorithm/course/coursev31/"

// 完善信息

#define V31personinfo @"http://api.julyedu.com/app/personinfo"

// 拼团支付  api.julyedu.com/app/grouppay
#define V31Grouppay @"http://api.julyedu.com/app/grouppay"


#endif















#endif
