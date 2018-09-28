//
//  JULiveDetailController.m
//  algorithm
//
//  Created by yanbo on 17/10/16.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JULiveDetailController.h"
#import "TYSlidePageScrollView.h"
#import "TYTitlePageTabBar.h"
#import "TableViewController.h"
#import "JULiveCourseView.h"
#import "JUWebViewController.h"
#import "JULiveDetailModel.h"
@interface JUServerCommitmentView : UIView

@property(nonatomic, strong) NSArray *titleArray;

@property(nonatomic, strong) NSMutableArray *labelArray;

@property(nonatomic, strong) UILabel *serverLabel;

@property(nonatomic, strong) UIView *topLineView;
@property(nonatomic, strong) UIView *bottonLineView;


@end


@implementation JUServerCommitmentView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self set_subViews];
    return self;
}

-(void)setTitleArray:(NSArray *)titleArray{
    [self.labelArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _titleArray = titleArray;
    self.labelArray = [NSMutableArray array];
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor whiteColor];
        label.text = _titleArray[i];
        label.font = UIptfont(8);
        label.backgroundColor = Kcolor16rgb(@"86c8f8", 1);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [self.labelArray addObject:label];
        
    }
    
}



-(void)set_subViews{
    
    self.serverLabel = [[UILabel alloc]init];
    self.serverLabel.text = @"服务承诺:";
    self.serverLabel.textColor = Kcolor16rgb(@"333333", 1);
    self.serverLabel.font = UIptfont(12);
    [self addSubview:self.serverLabel];

//    self.topLineView = [[UIView alloc]init];
//    self.topLineView.backgroundColor = kColorRGB(221, 221, 221, 1);
//    [self addSubview:self.topLineView];

    self.bottonLineView = [[UIView alloc]init];
    self.bottonLineView.backgroundColor = kColorRGB(221, 221, 221, 1);
    [self addSubview:self.bottonLineView];

}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    self.serverLabel.frame = CGRectMake(12, 0, self.height_extension, self.height_extension);
    
    [self.serverLabel sizeToFit];
    
    self.serverLabel.frame = CGRectMake(12, 0, self.serverLabel.width_extension, self.height_extension);
    

    for (int i = 0; i < self.labelArray.count; i++) {
    
        UILabel *lable = self.labelArray[i];
        [lable sizeToFit];

        if (i == 0) {
            lable.frame = CGRectMake(self.serverLabel.right_extension+7, 0, lable.width_extension+5, lable.height_extension+5);
        }else{
            UILabel *lastLabel = self.labelArray[i-1];
            lable.frame = CGRectMake(lastLabel.right_extension+10, 0, lable.width_extension+8, lable.height_extension+5);
            
            
        }
        [lable Y_centerInSuperView];
    }
    
    
    
    
//    self.topLineView.frame = CGRectMake(0, 0, self.width_extension, 1);
    self.bottonLineView.frame = CGRectMake(0, self.height_extension-1, self.width_extension, 1);
    
}



@end


//课程简介View 讲师、课时开班时间


@interface JUCourseSimpleIntroduceView : UIView

@property(nonatomic, strong) JULiveDetailModel *liveDetailModel;

//讲师 课时 时间 label
@property(nonatomic, strong) NSMutableArray *categoryLabelArray;


//讲师 课时 时间 内容的Label
@property(nonatomic, strong) NSMutableArray *ContentLabelArray;


@property (nonatomic,assign) CGFloat contentHeight;;


@end

@implementation JUCourseSimpleIntroduceView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self setup_subViews];
    return self;
}

-(CGFloat)contentHeight{
    
    return 20+14*3+10*2;
    
}

-(void)setup_subViews{
    
    self.categoryLabelArray = [NSMutableArray array];
    self.ContentLabelArray = [NSMutableArray array];
    NSArray *array = @[@"讲师:", @"课时:", @"时间:"];
    
    for (int i= 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.font = UIptfont(14);
        label.textColor = Kcolor16rgb(@"#333333", 1);
        label.text = array[i];
        [self addSubview:label];
        [self.categoryLabelArray addObject:label];
    }
    
    
    for (int i= 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.font = UIptfont(13);
        label.textColor = Kcolor16rgb(@"#666666", 1);
        [self addSubview:label];
        [self.ContentLabelArray addObject:label];
    }

}
-(void)setLiveDetailModel:(JULiveDetailModel *)liveDetailModel{
    _liveDetailModel = liveDetailModel;
    
    for (int i = 0; i< self.ContentLabelArray.count; i++) {
        
        UILabel *label = self.ContentLabelArray[i];
        
        if (i==0) {
            
            label.text =liveDetailModel.teachers;
            
            if([label.text isEqualToString:@"0"]    ) {
                label.text = @"七月在线";
            }
            
        }else if (i==1){
            label.text =liveDetailModel.course_hour;
        }else if (i==2){
            label.text =liveDetailModel.start_time;
        }
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    for (int i = 0; i < self.categoryLabelArray.count; i++) {
        UILabel *label = self.categoryLabelArray[i];
        label.frame = CGRectMake(12, 10+(14+10)*i, 36, 14);
    
    }
    
    for (int i = 0; i < self.categoryLabelArray.count; i++) {
        UILabel *catogoryLabel = self.categoryLabelArray[i];
        UILabel *label = self.ContentLabelArray[i];

        label.frame = CGRectMake(catogoryLabel.right_extension, 0, self.width_extension-catogoryLabel.right_extension, 13);
        label.centerY_extension = catogoryLabel.centerY_extension;
        
    }
    
    
    
//    [self colorForSubviews];
 
    
}


@end

#import "NSTimer+YYAdd.h"
#import "NSMutableAttributedString+Extension.h"
@interface JUAddPartView : UIView

{
     NSInteger _nowTime;
     NSInteger _endTime;
    //红色view所占的百分比
    CGFloat _perCentage;

}

@property(nonatomic, strong) NSArray *titleArray;

@property(nonatomic, strong) UILabel *addParLabel;

@property (nonatomic,assign) CGFloat contentHeight;

@property(nonatomic, strong) UIView  *formView;

@property(nonatomic, strong) NSMutableArray *labelArray;

@property(nonatomic, strong) UILabel *reainningLabel;

@property(nonatomic, strong) UILabel *addNumLabel;

@property(nonatomic, strong) UIView *percenTaageView;
@property(nonatomic, strong) UIView *percenTaagesubView;



@property(nonatomic, strong) UILabel *totalCountLabel;


@property(nonatomic, strong) UIButton *addPartButton;

@property(nonatomic, strong) NSDictionary *dict;


@property(nonatomic, strong) NSMutableArray *numberArray;

@property (nonatomic,assign) NSInteger nowPersonNumber;

@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, strong) UILabel *tagLabel;


@end

@implementation JUAddPartView

-(UILabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc]init];
        _tagLabel.text = @"当前拼团价";
        _tagLabel.textColor = Kcolor16rgb(@"fc5c4c", 1);
        _tagLabel.font = UIptfont(10);
        
        [self addSubview:_tagLabel];
    }
    
    return _tagLabel;
}


-(NSTimer *)timer{
    if (!_timer) {
        

        _timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
            
            
            [self refreshTimeLabl];
            
        } repeats:YES];
        
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:( NSRunLoopCommonModes)];
        
    }
    
    return _timer;
}
- (void)dealloc
{
    [self.timer invalidate];
    
    self.timer = nil;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self setup_subViews];
    return self;
}


-(void)setup_subViews{
    
    
    UILabel *addParLabel = [[UILabel alloc]init];
    addParLabel.text = @"正在拼团";
    addParLabel.font = UIptfont(11);
    addParLabel.textColor = Kcolor16rgb(@"#FC5c4c", 1);
    [addParLabel sizeToFit];
    [self addSubview:addParLabel];
    
    self.addParLabel = addParLabel;
    
    UIView *formView = [[UIView alloc]init];
    [self addSubview:formView];
    self.formView = formView;
    
    
    UILabel *reainningLabel = [[UILabel alloc]init];
    [self addSubview:reainningLabel];
    self.reainningLabel = reainningLabel;
    
    
    
    UILabel *addNumLabel = [[UILabel alloc]init];
    addNumLabel.font = UIptfont(7);
    addNumLabel.textColor = Kcolor16rgb(@"#666666", 1);
    addNumLabel.textAlignment = NSTextAlignmentRight;
    addNumLabel.text = @"202已参团";
    [self addSubview:addNumLabel];
    self.addNumLabel = addNumLabel;
 

    UIView *percenTaageView = [[UIView alloc]init];
    percenTaageView.backgroundColor = kColorRGB(221, 221, 221, 1);
    percenTaageView.layer.cornerRadius = 4;
    [self addSubview:percenTaageView];
    self.percenTaageView = percenTaageView;
    
    UIView *percenTaagesubView = [[UIView alloc]init];
    percenTaagesubView.backgroundColor =  Kcolor16rgb(@"fc5c4c", 1);
    percenTaagesubView.layer.cornerRadius = 4;
    [self.percenTaageView addSubview:percenTaagesubView];
    self.percenTaagesubView = percenTaagesubView;

    
    
    
    UILabel *totalCountLabel = [[UILabel alloc]init];
    totalCountLabel.font = UIptfont(11);
    totalCountLabel.textColor = Kcolor16rgb(@"#333333", 1);
    totalCountLabel.text = @"300人";
    [self addSubview:totalCountLabel];
    self.totalCountLabel = totalCountLabel;
    
    
//    UIButton *addPartButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    addPartButton.backgroundColor = [UIColor redColor];
//    addPartButton.titleLabel.font = UIptfont(12);
//    [addPartButton setTitle:@"5元参团" forState:(UIControlStateNormal)];
//    [addPartButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    [self addSubview:addPartButton];
//    self.addPartButton = addPartButton;

}

-(void)setTitleArray:(NSArray *)titleArray{
    
    _titleArray = titleArray;
    
    self.numberArray = [NSMutableArray array];
    UIColor *color = Kcolor16rgb(@"#DDDDDD", 1)
    _formView.backgroundColor = color;
    [_formView removeAllSubViews];
    self.labelArray = [NSMutableArray array];
    
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.text = @"";
        [self.labelArray addObject:label];
        label.font = UIptfont(10);
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        [_formView addSubview:label];
        label.frame = CGRectMake(1, i*20, Kwidth*0.5-2, 20);
        
        NSDictionary *dict = titleArray[i];
  
       NSString  *num = [dict[@"groupon_num"] description];
       NSString *price = [dict[@"groupon_price"] description];
       [self.numberArray addObject:num];
   
        NSString *content = @"";
        if (num && price) {
            content = [NSString stringWithFormat:@"   %@人以上:  %@元",num,price];
            
            if ([num isEqualToString:@"0"]) {
                content = [NSString stringWithFormat:@"   原价:  %@元",price];

            }
            
        }
        
        label.text = content;
        
        
        
        
        if (i == 0) {
            [label addTopLineViewHeight:1 Color:color];
        }

      [label addBottomLineViewHeight:1 Color:color];
        
        label.clipsToBounds = YES;
        
//        UIView *view11 = [[UIView alloc]init];
//        view11.backgroundColor = [UIColor redColor];
//        view11.frame = CGRectMake(0, 0, label.width_extension, 3);
//        
//        [label addSubview:view11];
//        
    }

}




-(void)setDict:(NSDictionary *)dict{
    
//    NSMutableDictionary *dd = [dict mutableCopy];
//    dd[@"person_num"] = @"55";
//    _dict = [dd copy];

    _dict = dict;
    
    if (dict) {
        
        [self displayFormView];
        [self displayLabel];
        [self dealStatusdata];
        [self timer];
        
    }
 

    [self setNeedsLayout];
    
}


-(void)displayFormView{
    if (_dict[@"group_list"]) {
        
        self.titleArray = _dict[@"group_list"];
        
        NSString *person_num = [_dict[@"person_num"] description];
        self.nowPersonNumber = [person_num integerValue];
        
        __block NSUInteger sortIndex = 0;
        
        [self.numberArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.nowPersonNumber  >= [obj integerValue]) {
                sortIndex = idx;
                *stop = YES;
            }
 
        }];
        
        
        UILabel *label = self.labelArray[sortIndex];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = Kcolor16rgb(@"#fc5c4c", 1);
        self.tagLabel.frame = CGRectMake(0, label.y_extension, 100, label.height_extension);
        
        [_formView setNeedsLayout];
        
        
    }
    
}

-(void)dealStatusdata{
    
    if (_dict[@"group_status"]) {
        
        NSDictionary *dict = _dict[@"group_status"];
        
//        1,508,819,326
        _nowTime = [[dict[@"time"] description] integerValue];
        _endTime = [[dict[@"end_time"] description] integerValue];
    }
    
    NSUInteger perNumber = [[_dict[@"person_num"] description] integerValue];
    
    NSUInteger endNumber = [[self.numberArray lastObject] integerValue];
    
    if (endNumber) {
        _perCentage = perNumber*1.0/endNumber;
        
        if (_perCentage > 1) {
            _perCentage = 1;
        }
        
    }

    
}

-(void)displayLabel{
    self.addNumLabel.text = [NSString stringWithFormat:@"%zd人已参团", self.nowPersonNumber];
    self.totalCountLabel.text = [NSString stringWithFormat:@"%@人", [self.numberArray lastObject]];
   }

-(void)refreshTimeLabl{
    
    NSString *strHeader = @"剩余时间:  ";
    _nowTime += 1;
    NSString *content = [NSString stringWithFormat:@"%@ %@",strHeader, [self nowTime:_nowTime endTime:_endTime]];
    
    NSMutableAttributedString *remainContent = content.mutableAttributedString;
    
    UIColor *redColor = Kcolor16rgb(@"fc5c4c", 1);
    UIColor *normalColor = Kcolor16rgb(@"333333", 1);
    
    [remainContent font:11 color:redColor];
    [remainContent font:11 color:normalColor str:strHeader];
    [remainContent font:11 color:normalColor str:@"天"];
    [remainContent font:11 color:normalColor str:@"小时"];
    [remainContent font:11 color:normalColor str:@"分"];
    [remainContent font:11 color:normalColor str:@"秒"];

    self.reainningLabel.attributedText = remainContent;
    
}

-(NSString *)nowTime:(NSInteger)nowtime endTime:(NSInteger)endTime{
    
    if (nowtime <= 0 || endTime <= 0) {
        return @"";
    }
    
    NSInteger day = 0;
    NSInteger hour = 0;
    NSInteger min = 0;
    NSInteger sec = 0;
    
    NSUInteger remainTime = endTime-nowtime;
    day = remainTime/(24*3600);
    
    hour = (remainTime%(24*3600))/3600;
    
    min = (remainTime%(3600)) / 60;
    sec = (remainTime%(60));
    
    
    if (remainTime <= 0) {
        day = 0;
        hour = 0;
        min = 0;
        sec = 0;
    }
    
    return [NSString stringWithFormat:@"%zd天 %zd小时 %zd分 %zd秒", day,hour,min,sec];
    
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    self.addParLabel.frame = CGRectMake(12, 0, self.addParLabel.bounds.size.width, 11);
    self.formView.frame = CGRectMake(self.addParLabel.right_extension+10, 1, Kwidth*0.5, 20*self.titleArray.count);
    
    self.tagLabel.x_extension = self.formView.right_extension+10;
    
    self.reainningLabel.frame = CGRectMake(self.addParLabel.x_extension, self.formView.bottom_extension+10, 250, 12);
    
    
    self.percenTaageView.frame = CGRectMake(self.addParLabel.x_extension, self.reainningLabel.bottom_extension+5, self.width_extension-70, 4);
    //是percenTaageView上一个控件的子控件
    self.percenTaagesubView.frame = CGRectMake(0, 0, self.percenTaageView.width_extension*_perCentage, self.percenTaageView.height_extension);
 
    self.addNumLabel.frame = CGRectMake(0, 0, 100, 8);
    self.addNumLabel.right_extension = self.percenTaageView.right_extension;
    self.addNumLabel.centerY_extension = self.reainningLabel.centerY_extension;
    
    
    self.totalCountLabel.frame = CGRectMake(self.percenTaageView.right_extension+4, 0, 40, 12);
    self.totalCountLabel.centerY_extension = self.percenTaageView.centerY_extension;
    
//    self.addPartButton.frame = CGRectMake(0, self.percenTaageView.bottom_extension+15, self.width_extension*0.9, 30);
//    [self.addPartButton X_centerInSuperView];

    
//    [self colorForSubviews];
    
}

//当隐藏是，高度为0
-(CGFloat)contentHeight{
    
    if (self.hidden) {
        return 0;
    }
    
    _contentHeight = 0;
    _contentHeight += self.titleArray.count*20+10;
    _contentHeight += 11+5;
    _contentHeight += 4+15;
    
//    _contentHeight += 30+15;

    return _contentHeight;
    
}



@end







typedef NS_ENUM(NSUInteger, ButtonShowType) {
    
    buttonShowTypeNotKnow,
    buttonShowTypeHidden,
    buttonShowTypeQQconsult, // qq咨询
    buttonShowTypeAddShoppingCar,// 加入购物车
    buttonShowTypeGotoShoppingCar,// 跳转购物车页面
    buttonShowTypeGotoSLive// 跳转到直播页面
};

@interface JULiveButton : UIButton

@property (nonatomic,assign) ButtonShowType type;

@end

@implementation JULiveButton

-(void)layoutSubviews{
    [super layoutSubviews];

    self.imageView.y_extension = 8;
//    self.imageView.width_extension = self.width_extension;
    self.imageView.centerX_extension = self.width_extension*0.5;
    

    
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = UIptfont(8);

    self.titleLabel.y_extension = self.imageView.bottom_extension+5;
//    self.titleLabel.bottom_extension= self.height_extension-8;
    self.titleLabel.width_extension = self.width_extension;
    self.titleLabel.centerX_extension = self.width_extension*0.5;
 

}


@end
#import "JUAddInfomationController.h"
#import "JUUmengShareView.h"
#import "JUUMengShare.h"
#import "JULoginViewController.h"
#import "JUapplyController.h"
#import "NSArray+Extension.h"
#import "JUShoppingCarController.h"
#import "JUCourseDetailViewController.h"
#import "JUCompendiumController.h"
#import "JUButton.h"
//#import "JUapplyController"
@interface JULiveDetailController ()<TYSlidePageScrollViewDataSource, TYSlidePageScrollViewDelegate, CompendiumControllerDelegate>
@property (nonatomic, weak) TYSlidePageScrollView *slidePageScrollView;

@property(nonatomic, strong) TYTitlePageTabBar *titlePageTabBar;

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIView *scrollView;

@property(nonatomic, strong) UIView *headView;
@property(nonatomic, strong) UIView *footView;

@property (nonatomic,assign) CGFloat headViewHeight;
//@property(nonatomic, strong) UIView *statueView;
@property(nonatomic, strong) JULiveCourseView *liveCourseView;

@property(nonatomic, strong) JUServerCommitmentView *serverView;

@property(nonatomic, strong) JUCourseSimpleIntroduceView *simpleIntroduceView;

@property(nonatomic, strong) JUAddPartView *addPartView;

// footView 上有三个button, 不同的状态有不同的文字和点击事件

@property(nonatomic, strong) JULiveButton *leftbutton;
@property(nonatomic, strong) JULiveButton *centerButton;

//根据button的tag值来选择点击事件和button的展示样式， 默认值是立即购买
//1000 立即购买
//1001 开始学习
//1002   参团参团
// 1003  补交尾款
@property(nonatomic, strong) UIButton *rightButton;


@property(nonatomic, strong) NSString *addPartPrice;

//领取优惠券的View
@property(nonatomic, strong) UIView *receiveCouponsView;

@property(nonatomic, strong) UILabel *sharePriceLabel;


@property(nonatomic, strong) JULiveDetailModel *liveModel;

//参团信息
@property(nonatomic, strong) NSDictionary *goup_Infor;

//分享
@property(nonatomic, strong) JUUmengShareView *shareView;

@property(nonatomic, strong) UIWebView *webView;

@property(nonatomic, strong) JUButton *shoppingCarItemButton;



//视频自动播放时的VideoID, 如果有值，则跳到视频播放页面会自动播放
@property(nonatomic, strong) NSString *VideoID;

@end

@implementation JULiveDetailController


-(UIWebView *)webView{
    
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    
    return _webView;
}

-(UIView *)receiveCouponsView{
    if (!_receiveCouponsView) {
        //    领取的view
        UIView *receiveCouponsView = [[UIView alloc]init];
        //    receiveCouponsView.backgroundColor = [UIColor redColor];
        
        self.receiveCouponsView = receiveCouponsView;
        
        UIImageView *couponImv = [[UIImageView alloc]init];
        couponImv.image = [UIImage imageNamed:@"youhuijuan@icon"];
        couponImv.frame = CGRectMake(12, 15, 30, 20);
        [receiveCouponsView addSubview:couponImv];
        
        
        UILabel *sharePriceLabel = [[UILabel alloc]init];
        sharePriceLabel.text = @"分享课程领取5元优惠券";
        sharePriceLabel.textColor = Kcolor16rgb(@"fa952f", 1);
        sharePriceLabel.font = UIptfont(15);
        sharePriceLabel.frame = CGRectMake(couponImv.right_extension+6, 0, 250, 50);
        [receiveCouponsView addSubview:sharePriceLabel];
        self.sharePriceLabel = sharePriceLabel;
        
        
        UIButton *receiveCouponButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [receiveCouponButton setTitle:@"领取" forState:(UIControlStateNormal)];
        receiveCouponButton.titleLabel.font = UIptfont(14);
        UIColor *titleColor = Kcolor16rgb(@"ff2121", 1);
        [receiveCouponButton setTitleColor:titleColor forState:(UIControlStateNormal)];
        receiveCouponButton.layer.borderColor = titleColor.CGColor;
        receiveCouponButton.layer.cornerRadius = 4;
        receiveCouponButton.layer.borderWidth = 1;
        receiveCouponButton.frame = CGRectMake(Kwidth-60-12, 0, 60, 23);
        receiveCouponsView.frame = CGRectMake(0, 0, Kwidth, 50);
        [receiveCouponsView addSubview:receiveCouponButton];
        [receiveCouponButton Y_centerInSuperView];
        [receiveCouponButton addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
        UIColor *color = Kcolor16rgb(@"#DDDDDD", 1);
        [_receiveCouponsView addBottomLineViewHeight:1 Color:color];
        
        _receiveCouponsView = receiveCouponsView;
    }
    
    return _receiveCouponsView;
}

-(UIView *)headView{
    
    if (!_headView) {
        _headView = [[UIView alloc]init];

        
        _liveCourseView = [[JULiveCourseView alloc]init];
        [_headView addSubview:_liveCourseView];

        _serverView = [[JUServerCommitmentView alloc]init];
        _serverView.backgroundColor = kColorRGB(244, 244, 244, 1);
        [_headView addSubview:_serverView];

        
        
        [_headView addSubview:self.receiveCouponsView];
 
        
        // 讲师课时开班时间
        _simpleIntroduceView = [[JUCourseSimpleIntroduceView alloc]init];
        [_headView addSubview:_simpleIntroduceView];
        
        
        
        _addPartView = [[JUAddPartView alloc]init];
        [_headView addSubview:_addPartView];
  

    }
    
    return _headView;
    
    
}

-(UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]init];
        _footView.backgroundColor = [UIColor whiteColor];
        _footView.frame = CGRectMake(0, 0, self.slidePageScrollView.width_extension, 44);
        
        JULiveButton *leftButton = [JULiveButton buttonWithType:(UIButtonTypeCustom)];
        [leftButton addTarget:self action:@selector(liveButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        UIColor *titleColor = Kcolor16rgb(@"#333333", 1);
        
        CGFloat buttonSpace = 0;
        
        buttonSpace = _footView.width_extension / 375 * 50;
        
        [leftButton setTitleColor:titleColor forState:(UIControlStateNormal)];
        leftButton.frame = CGRectMake(buttonSpace, 0, 45, _footView.height_extension);
        [_footView addSubview:leftButton];
        self.leftbutton = leftButton;
        
        
        UIButton *rightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [rightButton.titleLabel setFont:UIptfont(16)];
        CGFloat rightButtonWidth = _footView.width_extension / 375 * 150;
        [rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        rightButton.frame = CGRectMake(_footView.width_extension-rightButtonWidth, 0, rightButtonWidth, _footView.height_extension);
        [_footView addSubview:rightButton];
        self.rightButton = rightButton;
        
        
        
        
        
        JULiveButton *centerButton = [JULiveButton buttonWithType:(UIButtonTypeCustom)];
        [centerButton setTitleColor:titleColor forState:(UIControlStateNormal)];
        [centerButton addTarget:self action:@selector(liveButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        centerButton.frame = CGRectMake(0, 0, 45, _footView.height_extension);
        centerButton.right_extension = rightButton.x_extension-buttonSpace;
        [_footView addSubview:centerButton];
        self.centerButton = centerButton;

        UIColor *topLineColor = Kcolor16rgb(@"#DDDDDD", 1);
        
        [_footView addTopLineViewHeight:1 Color:topLineColor];
        
        
    }
    return _footView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"课程详情";
    [self addNotifi];
    
    [self setNavigator];
    
  [self setup_subViews];
    
}

-(void)addNotifi{
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareCouponSucceed:) name:JUShareCouponSucceedNotification object:nil];
}



-(void)setNavigator{
    UIBarButtonItem *shareButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(shareAction:) image:@"share_coupon" highImage:@"share_coupon"];
    
    JUButton *shoppingButton = [JUButton buttonWithType:(UIButtonTypeCustom)];
    shoppingButton.frame = CGRectMake(0, 0, 30, 30);
    
    [shoppingButton setImage:[UIImage imageNamed:@"shop"] forState:(UIControlStateNormal)];
    [shoppingButton setImage: [UIImage imageNamed:@"xing@shop"] forState:(UIControlStateSelected)];
    [shoppingButton addTarget:self action:@selector(gotoShoppingCar:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.shoppingCarItemButton =shoppingButton;
    
    UIBarButtonItem *shopButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shoppingButton];
    self.navigationItem.rightBarButtonItems = @[shareButtonItem, shopButtonItem];
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        self.navigationItem.rightBarButtonItems = @[shareButtonItem];
    }
    
 
    [MBProgressHUD showMessage:@"正在加载中" toView: self.view];
    

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareCouponSucceed:) name:JUShareCouponSucceedNotification object:nil];
    

}



-(void)setup_subViews{
    [self addContentView];
    [self addSlidePageScrollView];
    [self addHeaderView];
    [self addFootView];
    [self addTabPageMenu];
    [self addChildrenVC];
    [self resetFrame];
    [self addShareView];
    
    [self.slidePageScrollView reloadData];
    
}


-(void)addContentView{
    
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds)-64);
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

-(void)addShareView{
    
    //友盟分享View
    JUUmengShareView *shareView = [[JUUmengShareView alloc]init];
    shareView.showLogin = YES;
    shareView.frame = CGRectMake(0, Kheight-64, Kwidth,0);
    shareView.backgroundColor = [UIColor whiteColor];
    
    __weak JUUmengShareView *weakShareView = shareView;
    
    __weak typeof(self) weakSelf = self;
    shareView.cancelBlcok = ^(UIButton *cancelButton){
        
        [UIView animateWithDuration:0.27 animations:^{
            weakShareView.y_extension = Kheight-64;
        }];
        
    };
    
    
    shareView.shareBlock = ^(JUShareButton *shareButton){
        
        JUUMengShare *umengShare = [[JUUMengShare alloc]init];
        
        umengShare.liveDetailModel = weakSelf.liveModel;
        
        [umengShare shareDataWithPlatform:(shareButton.platformType)];
        
    };
    
    
    shareView.loginBlock = ^(UIButton *loginButton){
        
        JULoginViewController *loginVC = [[JULoginViewController alloc]init];
        [weakSelf.navigationController pushViewController:loginVC animated:NO];
        
    };
    
    
    [self.contentView addSubview:shareView];
    self.shareView = shareView;

}

-(void)addSlidePageScrollView{
    
    TYSlidePageScrollView *slidePageScrollView = [[TYSlidePageScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
//    slidePageScrollView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
    slidePageScrollView.pageTabBarIsStopOnTop = YES;
    slidePageScrollView.pageTabBarStopOnTopHeight = 0;
    slidePageScrollView.dataSource = self;
    slidePageScrollView.delegate = self;
    [self.contentView addSubview:slidePageScrollView];
    self.slidePageScrollView = slidePageScrollView;
    
    JULog(@"%@", slidePageScrollView.logframe);
    
}

-(void)addHeaderView{
    
    
    self.slidePageScrollView.headerView = self.headView;
    self.headView = self.headView;
    
 
}

-(void)addFootView{
    
    UIView *footView = [self footView];

    self.slidePageScrollView.footerView = footView;

    
    self.leftbutton.type = buttonShowTypeQQconsult;
    self.centerButton.type = buttonShowTypeAddShoppingCar;
    self.rightButton.tag = 1002;
    
    [self disPlayAllLiveButton];
    [self disPlayRightButton];
    
}


-(void)addTabPageMenu{
    //    @property (nonatomic, strong) UIFont *textFont;
    //    @property (nonatomic, strong) UIFont *selectedTextFont;
    //
    //    @property (nonatomic, strong) UIColor *textColor;
    //    @property (nonatomic, strong) UIColor *selectedTextColor;
    NSArray *titleArray = @[@"    详情    ", @"    大纲    "];
    
    TYTitlePageTabBar *titlePageTaBar = [[TYTitlePageTabBar alloc]init];
    titlePageTaBar.backgroundColor = [UIColor whiteColor];;
    titlePageTaBar.textFont = UIptfont(15);
    titlePageTaBar.textColor = Kcolor16rgb(@"#333333", 1);
    titlePageTaBar.selectedTextColor = Kcolor16rgb(@"#00A5FF", 1);
    titlePageTaBar.horIndicatorColor = titlePageTaBar.selectedTextColor;
    titlePageTaBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.slidePageScrollView.bounds), 44);

    titlePageTaBar.titleArray = titleArray;
    self.slidePageScrollView.pageTabBar = titlePageTaBar;
    self.titlePageTabBar = titlePageTaBar;


   UIView *seperatorView = [[UIView alloc]init];
   seperatorView.frame = CGRectMake(0, 0, 1, 20);
    seperatorView.backgroundColor = kColorRGB(221, 221, 221, 1);
   
   [titlePageTaBar addSubview:seperatorView];
   [seperatorView XY_centerInSuperView];
    
    
    UIColor *color = Kcolor16rgb(@"#DDDDDD", 1);
    
    [titlePageTaBar addTopLineViewHeight:1 Color:color];
    [titlePageTaBar  addBottomLineViewHeight:1 Color:color];

    
    
}
- (void)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView verticalScrollViewDidScroll:(UIScrollView *)pageScrollView{
    
    
}

-(void)addChildrenVC{
    
    JUWebViewController *webVC = [[JUWebViewController alloc]init];
    webVC.webViewFrame = CGRectMake(0, 0, Kwidth, Kheight);
    [self addChildViewController:webVC];
    
    
    JUCompendiumController *compendiumVC = [[JUCompendiumController alloc]init];
    compendiumVC.delegate = self;
    [self addChildViewController:compendiumVC];
    
    
//    TableViewController *tabVC1 = [[TableViewController alloc]init];
//    tabVC1.itemNum = 15;
//    [self addChildViewController:tabVC1];
    
}


-(void)resetFrame{
    
    [self headSubViewFrame];
    self.headView.frame = CGRectMake(0, 0, CGRectGetWidth(self.slidePageScrollView.bounds), _headViewHeight);
    self.titlePageTabBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.slidePageScrollView.bounds), 44);
    
    
}

-(void)headSubViewFrame{
    _headViewHeight = 0;
    
    _liveCourseView.frame = CGRectMake(0, 0, Kwidth, Kwidth*0.4*0.72+30);
    _headViewHeight += _liveCourseView.height_extension;
    
    
    _serverView.frame = CGRectMake(0, _headViewHeight, Kwidth, 25);
    _headViewHeight += _serverView.height_extension;
    
    
    
    //领取优惠券是否隐藏
    //用户已经购买了也不显示
    
    JULog(@"%@  %@", self.liveModel.amount , self.liveModel.is_baoming);
    
    if (![self.liveModel.amount integerValue] || [self.liveModel.is_baoming integerValue]) {
        _receiveCouponsView.hidden = YES;
        
        //当隐藏时，就不用 分享的view就不用展示 登录按钮
        self.shareView.showLogin = NO;
       
    }else{
        self.shareView.showLogin = YES;
        _receiveCouponsView.hidden = NO;
    }

    [self.shareView setNeedsLayout];
    [self.shareView layoutIfNeeded];
    
    
    
    
    
    self.sharePriceLabel.text = [NSString stringWithFormat:@"分享课程领取%@元优惠券", self.liveModel.amount];
    
    _receiveCouponsView.frame = CGRectMake(0, _headViewHeight, Kwidth, _receiveCouponsView.hidden ? 0 : 50);
    _headViewHeight += _receiveCouponsView.height_extension;
 
    
    _simpleIntroduceView.frame = CGRectMake(0, _headViewHeight, Kwidth, _simpleIntroduceView.contentHeight);
    _headViewHeight += _simpleIntroduceView.height_extension;
    
    //参团是否隐藏
    if (self.rightButton.tag == 1002 || self.rightButton.tag == 1003) {
        _addPartView.hidden = NO;
        
    }else{
        _addPartView.hidden = YES;
        
    }
    
    
    
    _addPartView.frame = CGRectMake(0, _headViewHeight, Kwidth, _addPartView.contentHeight);
    _headViewHeight += _addPartView.height_extension;
    
    
    
}
-(void)disPlayButton{
    [self disPlayAllLiveButton];
    [self disPlayRightButton];
    
}


-(void)disPlayAllLiveButton{
    

    [self disPlayButton:self.leftbutton];
    [self disPlayButton:self.centerButton];

}

-(void)disPlayButton:(JULiveButton *)livebutton{
//    buttonShowTypeHidden
//    buttonShowTypeNotKnow,
//    buttonShowTypeQQconsult, // qq咨询
//    buttonShowTypeAddShoppingCar,// 加入购物车
//    buttonShowTypeGotoShoppingCar,// 跳转购物车页面
//    buttonShowTypeGotoSLive// 跳转到直播页面
    JULog(@"%zd", self.centerButton.type);

    livebutton.hidden = NO;
    switch (livebutton.type) {
            
        case buttonShowTypeHidden:{
            livebutton.hidden = YES;
            break;
        }
        case buttonShowTypeQQconsult:{
            
            [livebutton setImage:[UIImage imageNamed:@"zixun_icon"] forState:(UIControlStateNormal)];
            [livebutton setTitle:@"课程咨询" forState:(UIControlStateNormal)];
            break;
        }
            
        case buttonShowTypeAddShoppingCar:{
            [livebutton setImage:[UIImage imageNamed:@"shop_icon"] forState:(UIControlStateNormal)];
            [livebutton setTitle:@"加入购物车" forState:(UIControlStateNormal)];
            JULog(@"%zd", self.centerButton.tag);

            break;
        }
        
        case buttonShowTypeGotoShoppingCar:{
            [livebutton setImage:[UIImage imageNamed:@"shop_icon"] forState:(UIControlStateNormal)];
            [livebutton setTitle:@"去结算" forState:(UIControlStateNormal)];
            break;
        }
        
        
        case buttonShowTypeGotoSLive:{
            
            [livebutton setImage:[UIImage imageNamed:@"livevideo_icon"] forState:(UIControlStateNormal)];
            [livebutton setTitle:@"跟直播" forState:(UIControlStateNormal)];

            break;
        }
            
        default:
            break;
    }
    
}

-(void)disPlayRightButton{
    //1000  立即购买
    //1001  开始学习
    //1002  参团参团
    // 1003  补交尾款
    // 1004 不能报名


    if (self.rightButton.tag == 1000) {
        
        
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self.rightButton setTitle:@"立即购买" forState:(UIControlStateNormal)];
        self.rightButton.backgroundColor = kColorRGB(237, 70, 47, 1);
        
    }else if (self.rightButton.tag == 1001){
        
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self.rightButton setTitle:@"开始学习" forState:(UIControlStateNormal)];
        self.rightButton.backgroundColor = kColorRGB(40, 152, 251, 1);
        
        
    }else if (self.rightButton.tag == 1002){
        NSString *price = self.addPartPrice;
        
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self.rightButton setTitle:[NSString stringWithFormat:@"%@元参团", price] forState:(UIControlStateNormal)];

        self.rightButton.backgroundColor = kColorRGB(237, 70, 47, 1);
        
    }else if (self.rightButton.tag == 1003){
     //   NSString *price = self.addPartPrice;
        
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self.rightButton setTitle:@"补交尾款" forState:(UIControlStateNormal)];
        
        self.rightButton.backgroundColor = kColorRGB(237, 70, 47, 1);
        
    }else if (self.rightButton.tag == 1004){
        //   NSString *price = self.addPartPrice;
        
//        [self.rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//        [self.rightButton setTitle:@"补交尾款" forState:(UIControlStateNormal)];
//        
//        self.rightButton.backgroundColor = kColorRGB(237, 70, 47, 1);

        
        // 不能报名，点击提示对话框
   
        
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self.rightButton setTitle:@"报名结束" forState:(UIControlStateNormal)];
    
        self.rightButton.backgroundColor =Kcolor16rgb(@"#cccccc", 1);
        

    }
}

#pragma mark 响应事件

-(void)liveButtonClicked:(JULiveButton *)liveButton{
    
    
    if (!JuuserInfo.isLogin && liveButton.type != buttonShowTypeQQconsult) {
        
        [self gotoLoginController];
        
        return;
    }
    
    switch (liveButton.type) {
        case buttonShowTypeQQconsult:{
            
            [self QQconsulting];
            
            break;
        }
            
        case buttonShowTypeAddShoppingCar:{
            //添加到购物车接口
            [self addShoppingCar:liveButton];
            break;
        }
            
        case buttonShowTypeGotoShoppingCar:{
            [self gotoShoppingCar:liveButton];
            break;
        }
            
            
        case buttonShowTypeGotoSLive:{
            break;
        }
            
        default:
            break;
    }

    
    
}

-(void)QQconsulting{
    //安装了qq
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        
        NSString *QQ = self.liveModel.customer;
        //调用QQ客户端,发起QQ临时会话
        QQ = @"2852373040";
        NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",QQ];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
        
    }else{
        
        NSURL *url = [NSURL URLWithString:@"http://q.url.cn/s/Vbkup6m?_type=wpa"];
        [[UIApplication sharedApplication ] openURL:url];
    }

    
}

-(void)buttonClicked:(UIButton *)button{
    
    if (!JuuserInfo.isLogin) {
        [self gotoLoginController];
        return;
    }

    //1000  立即购买
    //1001  开始学习
    //1002  参团参团
    // 1003  补交尾款
    // 1004 不能报名
    
    
    if (self.rightButton.tag == 1000) {

        [self gotoApplyPage];

        
        
    }else if (self.rightButton.tag == 1001){
        
        
        JUCompendiumController *compendiumVC = [self.childViewControllers lastObject];
        
        if (compendiumVC.isWached) {
            
            [self startStudy];
            
        }else{
            
            [self showWithView:nil text:@"该课程暂时没有视频" duration:2];
        }
        
        

    }else if (self.rightButton.tag == 1002){
        
        JUAddInfomationController *addVC = [[JUAddInfomationController alloc]init];
        addVC.course_ID = self.course_id;
        addVC.price = self.addPartPrice;
        addVC.addPartType = @"1";
        [self.navigationController pushViewController:addVC animated:NO];
        
    }else if (self.rightButton.tag == 1003){
        
        JUAddInfomationController *addVC = [[JUAddInfomationController alloc]init];
        addVC.course_ID = self.course_id;
        addVC.addPartType = @"2";
        //补交尾款价格
        NSString * price = [self.goup_Infor[@"to_pay_amount"] description];
        if (!price) {
            price = @"0";
        }
        
        addVC.price = price;
        addVC.oid2 = [self.goup_Infor[@"oid2"] description];

        [self.navigationController pushViewController:addVC animated:NO];

    }else if (self.rightButton.tag == 1004){
        
        [self showWithView:nil text:@"该课程暂时不能报名" duration:3];
    }
    
    
}
-(void)startStudy{
    
    JUCourseDetailViewController *detailVC = [[JUCourseDetailViewController alloc]init];
    detailVC.course_id = self.liveModel.course_id;
    detailVC.course_title = self.liveModel.course_title;
    
    if ([self.VideoID length]) {
        
        detailVC.isAutoPlay = YES;
        
        JULessonModel *lessonMol = [[JULessonModel alloc]init];
        lessonMol.course_id = detailVC.course_id;
        lessonMol.ID = self.VideoID;
        
        
    }
    
    
    JULog(@"----------  %@", self.liveModel.course_id);
    
    if ([detailVC.course_id isEqualToString:@"0"]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        GMToast *toasts = [[GMToast alloc]initWithView:window text:@"暂无视频" duration:1.5];
        [toasts show];
        return;
    }
    
    [self.navigationController pushViewController:detailVC animated:NO];

    
    
}


-(void)gotoShoppingCar:(JULiveButton *)liveButton{
    

        JUShoppingCarController *shoppingCar = [[JUShoppingCarController alloc]init];
        
        [self.navigationController pushViewController:shoppingCar animated:NO];
    
//    if (liveButton) {
//        liveButton.type = buttonShowTypeGotoShoppingCar;
//        [self disPlayButton:liveButton];
//
//    }
    
    
    
    
}

-(void)shareAction:(UIButton *)shareButton{
    
    [UIView animateWithDuration:0.27 animations:^{
        
        self.shareView.bottom_extension = Kheight-64;
        

    }];

    
}


-(void)gotoLoginController{
    
    JULoginViewController *loginVC = [[JULoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:NO];
}

// 分享领取优惠券成功
-(void)shareCouponSucceed:(NSNotification *)notifi{
    
    if ([self.liveModel.amount isEqualToString:@"0"]) return;
    
    NSDictionary *dict = [notifi.userInfo mutableCopy];
    
    NSString *type = dict[@"type"];
    if (![type length] ) return;
    
    JULog(@"%@", JuuserInfo.headDit);
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@", shareCouponURL, type, self.course_id];
    YBNetManager *manager = [[YBNetManager alloc]init];
    
    [manager GET:urlString parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        
        JULog(@"领取优惠券信息：%@", responobject);
        NSString *msg = @"";
        
        if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
            msg = @"领券成功，购买课程时可直接使用";
        }else{
            msg = responobject[@"msg"];
        }
        
        //        GMToast *toast = [[GMToast alloc]initWithView:self.view text:msg duration:2 customWidth:300];
        //        [toast show];
        
        [self showWithView:nil text:msg duration:3];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        JULog(@"%@", error);
    }];
    
    
    
    
}
#pragma mark 代理方法

// 点击播放按钮的逻辑和 点击右下角按钮的逻辑差不多， 有一点差别是，如果点击播放按钮，要自动播放视频需要 一个视频的VideoID
// 为了不影响正常的点击，将self.videoID赋值后置为空
-(void)CompendiumController:(JUCompendiumController *)controller DidClickPlayButton:(JUCompentDiumModel *)Model{
    
    
    self.VideoID = Model.video_id;
    
    [self buttonClicked:self.rightButton];
    
    self.VideoID = nil;
    
    
}


- (UIScrollView *)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView pageVerticalScrollViewForIndex:(NSInteger)index
{
    
    if (index == 0) {
        
        JUWebViewController *webVc = self.childViewControllers[index];
        [webVc view];
        
        return webVc.webView.scrollView;
        
        
    }else if(index == 1){
        JUCompendiumController *tabViewVC = self.childViewControllers[index];
        
        [tabViewVC view];
        return [tabViewVC mainTableView];
    }
    
    return nil;
}

-(UIView *)slidePageChildView:(TYSlidePageScrollView *)slidePageScrollView pageVerticalScrollViewForIndex:(NSInteger)index{
    
    return [self.childViewControllers[index] view];
}

-(NSInteger)numberOfPageViewOnSlidePageScrollView{
    
    return self.childViewControllers.count;
}

#pragma mark 系统方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self makaData];
    [self getGoodsNumberFromShoppingCar];
    
    
    
}

#pragma mark 数据请求

-(void)makaData{
    


//
//     NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/Users/julyonline/Desktop/LIveSDk/22.plist"];
//    [self dealWithData:dict[@"data"]];
////    return;
//    
////    JULog(@"%@", self.course_id);
//    
//    return;
    
    
    JULoadingView *loadingView = [JULoadingView shareInstance];
    __weak typeof(self) weakSelf = self;
    loadingView.failureBlock = ^{
        
        [weakSelf makaData];
        
    };
    
    [self.view addSubview:loadingView];
    
    [loadingView beginLoad];

    YBNetManager *manager = [[YBNetManager alloc]init];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",V31CourseURL,self.course_id];
    
    [manager GET:urlString parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        
                           [loadingView loadSuccess];
        
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) {
            return ;
        }

        NSDictionary *result = responobject[@"data"];
        
//        [UIView createPropertyCodeWithDict:result[@"course_info"]];
        
        [responobject writeToFile:@"/Users/julyonline/Desktop/LIveSDk/11.plist" atomically:YES];
        
        [weakSelf dealWithData:result];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        JULog(@"--------\n\n%@", error);
        
        [loadingView loadFailure];

    }];
    
}


//购物车商品的数量
-(void)getGoodsNumberFromShoppingCar{
    
    self.shoppingCarItemButton.selected = NO;
    
    __weak typeof(self) weakSelf = self;
    YBNetManager *manager = [[YBNetManager alloc]init];
    
    [manager GET:shoppingCarNumURL parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *responobject) {
        if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
            NSString *num = responobject[@"data"][@"num"];
            if ([num intValue]) {
                weakSelf.shoppingCarItemButton.selected = YES;
            }else{
                weakSelf.shoppingCarItemButton.selected = NO;
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}



//跳转到支付页面
-(void)gotoApplyPage{
    __weak typeof(self) weakSelf = self;
    
    weakSelf.rightButton.userInteractionEnabled = NO;
    
    NSArray *array = [NSArray arrayWithObject:self.course_id];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"course_id"] = array.jsonStringEncoded;
    
    YBNetManager *manager = [[YBNetManager alloc]init];
    
    [manager POST:changeShoppingCarURL parameters:dict headdict:(JuuserInfo.headDit) constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } progress:^(NSProgress * _Nonnull Progress) {
        
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.rightButton.userInteractionEnabled = YES;

        JULog(@"成功： %@", responseObject);
        
        if ([[responseObject[@"errno"] description] isEqualToString:@"0"]){
            
            JUapplyController *applyVc = [[JUapplyController alloc]init];
            applyVc.dict = dict;
            [weakSelf.navigationController pushViewController:applyVc animated:NO];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        weakSelf.rightButton.userInteractionEnabled = YES;

        JULog(@"跳转支付页面error：%@", error);
        
    }];
    
}


-(void)addShoppingCar:(JULiveButton *)liveButton{
    
     NSString *urlStrign = [NSString stringWithFormat:@"%@%@",addShoppingCarURL,self.course_id];
    YBNetManager *manager = [[YBNetManager alloc]init];
//    __weak typeof(self) weakSelf = self;
    [manager GET:urlStrign parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        
        JULog(@"%@", responobject);
        
        
        if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
 
            [responobject showWithView:nil text:@"已经加入购物车" duration:1.5];
            liveButton.type = buttonShowTypeGotoShoppingCar;
 
            [self disPlayAllLiveButton];
            
        }else{
            [responobject showWithView:nil text:responobject[@"msg"] duration:1.5];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        
        
    }];
    

    
}




-(void)dealWithData:(NSDictionary *)dict{
    
//    NSLog(@"%@", dict[@"stage_info"]);
    
//    //后台的数据太乱了，返回时两层，在这儿处理一下包装成一层解析 course_info
//
//    NSMutableDictionary *dictCourseInfor = [dict[@"course_info"][@"course_info"] mutableCopy];
//    for (NSString * key in dict[@"course_info"]) {
//        if (![key isEqualToString:@"course_info"]) {
//            [dictCourseInfor setObject:dict[@"course_info"][key] forKey:key];
//            
//        }
//        
//    }

//    dictCourseInfor[@"service"] = @[@"好好学习", @"天天向上", @"天天开心"];
    

 
    
    
    self.liveModel = [JULiveDetailModel mj_objectWithKeyValues:dict[@"course_info"]];
    self.liveModel.course_id = self.liveModel.v_course_id;
    JULog(@"%@  %@", self.liveModel.amount, self.liveModel.is_baoming);

    
    self.liveCourseView.newliveDetailModel = self.liveModel;
    self.serverView.titleArray = self.liveModel.service;
    self.simpleIntroduceView.liveDetailModel = self.liveModel;
    self.navigationItem.title = self.liveModel.course_title;

    [self.liveModel.intro writeToFile:@"/Users/julyonline/Desktop/LIveSDk/11.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
   
    
    JUWebViewController *webVC = self.childViewControllers[0];
     webVC.html = self.liveModel.intro;
//    NSString *sss = [NSString stringWithContentsOfFile:@"" encoding:NSUTF8StringEncoding error:nil];
//    webVC.html = sss;
    
    
    
    JUCompendiumController *comperdiumVC = self.childViewControllers[1];
    comperdiumVC.liveModel = self.liveModel;
    comperdiumVC.sourceArray = dict[@"stage_info"];

    NSDictionary *addPartDic = dict[@"group_info"];
//    JULog(@"%@", addPartDic);
    if ([addPartDic count]) {
        self.goup_Infor = addPartDic;
        self.addPartView.dict = addPartDic;
    }

    // 参团价格
    
    self.addPartPrice = [dict[@"group_info"][@"group_status"][@"pre_price"] description];
    self.addPartPrice = [NSString stringWithFormat:@"%zd", [self.addPartPrice intValue]];
    
    [self resetProperty];
    
    [self resetFrame];
    [self disPlayButton];
    [self.slidePageScrollView reloadData];
}





-(void)resetProperty{
 
    //1000  立即购买
    //1001  开始学习
    //1002  参团参团
    // 1003  补交尾款
    // 1004 不能报名
    
    // is_goup代表是否参团
    NSInteger is_group = [[self.goup_Infor[@"is_group"] description] intValue];

    
    if ([self.liveModel.is_baoming integerValue]) {
        self.rightButton.tag = 1001;
        
        //正在拼团,
    }else if ([self.liveModel.group_status intValue] == 1){
        
   
        //表示补交尾款
        if (is_group == 1) {
            self.rightButton.tag = 1003;
        }else{
            self.rightButton.tag = 1002;
        }
        //拼团结束
        
        // 参团结束，但是如果已经交了参团费了，显示补交尾款
    }else if (([self.liveModel.group_status intValue] == 2)  && is_group){
        //表示补交尾款
            self.rightButton.tag = 1003;

        //该课程可以报名
    }else if([self.liveModel.isbaoming integerValue]){
        
        self.rightButton.tag = 1000;
        
        //该课程不能报名
    }else{
        
        self.rightButton.tag = 1004;
    }
//    JULog(@"%zd", self.rightButton.tag);
    // 中间的button
//    buttonShowTypeNotKnow,
//    buttonShowTypeHidden,
//    buttonShowTypeQQconsult, // qq咨询
//    buttonShowTypeAddShoppingCar,// 加入购物车
//    buttonShowTypeGotoShoppingCar,// 跳转购物车页面
//    buttonShowTypeGotoSLive// 跳转到直播页面
    self.rightButton.tag = 1001;

    
    // 该课程可以报名时，中间显示加入购物车
    if (self.rightButton.tag == 1000) {
       
        //如果是在购物车，跳转购物车页面
        if ([self.liveModel.in_cart integerValue]) {
            
            self.centerButton.type = buttonShowTypeGotoShoppingCar;
            
            //添加到购物车
        }else{
            self.centerButton.type = buttonShowTypeAddShoppingCar;
        }
 
        
        // 如果用户已经报了名 并且该课程时直播课程时  --跳转直播课程页面
        
        // 现在还没有直播，先保留着
    }else if (self.rightButton.tag == 1001 && 0){
        
        self.centerButton.type = buttonShowTypeGotoSLive;
        
        //否则的话中间button显示 咨询
    }else {
        
        self.centerButton.type = buttonShowTypeQQconsult;
    }

    //如果中间显示qq咨询时左边隐藏 否则左边显示qq咨询
    if (self.centerButton.type == buttonShowTypeQQconsult) {
        self.leftbutton.type = buttonShowTypeHidden;
    }else{
        self.leftbutton.type = buttonShowTypeQQconsult;
    }

    
    JULog(@"%zd", self.centerButton.tag);

}

- (void)dealloc
{
    
    JULog(@"控件销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
