//
//  JULiveCourseDetailController.m
//  algorithm
//
//  Created by 周磊 on 16/8/22.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JULiveCourseDetailController.h"
#import "JULiveCourseView.h"
#import "ButtonView.h"
#import "JUapplicantViewController.h"
#import "AppDelegate.h"
#import "JULiveDetailModel.h"
#import "JULoginViewController.h"
#import "JUCourseDetailViewController.h"
#import "JUUmengShareView.h"
#import "JUUMengShare.h"
#import "JUapplyController.h"

#import "JUShoppingCarController.h"
#import "DataMD5.h"
#import "JUButton.h"
#import "JUShoppingCarController.h"
#import "NSArray+Extension.h"
#define privateKey @"6b081347810286654b6e44f7ff00fe82"


@interface JULiveCourseDetailController ()<UIWebViewDelegate>

{
    
    CGFloat _receiveCouponsHeight;
}

@property(nonatomic, strong) UIView *contentView;

@property(nonatomic, strong) UIView *detailView;

@property(nonatomic, strong) JULiveDetailModel *liveDetailModel;

@property(nonatomic, strong) JULiveCourseView *liveCourseView;

//@property(nonatomic, strong) UIView *WebContentView;

@property(nonatomic, strong) UIWebView *webView;

@property(nonatomic, strong) NSURL *baseURL;

@property(nonatomic, strong) UIButton *enlistButton;

//开班时间
@property(nonatomic, strong) UILabel *statrt_timeLabel;
//课程时长
@property(nonatomic, strong) UILabel *course_hourLabel;



@property(nonatomic, strong) UIView *coverBlackView;

@property(nonatomic, strong) JUUmengShareView *shareView;

@property(nonatomic, strong) UIView *blackView;


@property(nonatomic, strong) JUButton *addShoppingCarButton;

@property(nonatomic, strong) JUButton *shoppingCarItemButton;

//判断该商品是否已经在购物车
@property (nonatomic,assign) BOOL isInShoppingCar;

//用来友盟统计 否已经购买该视频
@property (nonatomic,assign) BOOL courseBought;

@property(nonatomic, strong) UIView *receiveCouponsView;

@property(nonatomic, strong) UIView *  startTimeView;
@property(nonatomic, strong) UIView *  courseDurationView;

@property(nonatomic, strong) UILabel *sharePriceLabel;

@end

@implementation JULiveCourseDetailController

-(NSURL *)baseURL{
    if (!_baseURL) {
        _baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    }
    
    return _baseURL;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
  

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"课程详情";
    UIBarButtonItem *shareButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(shareAction) image:@"share_coupon" highImage:@"share_coupon"];

// UIBarButtonItem *shareButtonItem =   shareButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"share_coupon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:(UIBarButtonItemStylePlain) target:self action:@selector(shareAction)];
    
    
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
    
    
    [self getGoodsNumberFromShoppingCar];
    [MBProgressHUD showMessage:@"正在加载中" toView: self.view];

    [self setupViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareCouponSucceed:) name:JUShareCouponSucceedNotification object:nil];

    
}


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

-(void)gotoShoppingCar:(JUButton *)sender{
    

    

    if (JuuserInfo.isLogin) {
        JUShoppingCarController *shoppingCar = [[JUShoppingCarController alloc]init];
        
        [self.navigationController pushViewController:shoppingCar animated:NO];
        
        
        
    }else{
        
        JULoginViewController *loginVC = [[JULoginViewController alloc]init];
        
        [self.navigationController pushViewController:loginVC animated:NO];
        
        
    }
    
    
}

#pragma mark 视图布局
-(void)shareAction{
    
    if (self.courseBought) {
       
        [JUUmengStaticTool event:JUUmengStaticCourseDetail key:JUUmengParamCourseBought value:@"share"];
        
    }else{
      
        [JUUmengStaticTool event:JUUmengStaticCourseDetail key:JUUmengParamCourseNotBuy value:@"share"];

        
    }
    
    [UIView animateWithDuration:0.27 animations:^{
        
        self.shareView.bottom_extension = Kheight;
        
        self.blackView.hidden = NO;
        
        
    }];
    
    JUlogFunction
    
}

-(void)receiveCouponButtonClicked:(UIButton *)button{
    
//    JUlogFunction
}



-(void)setupViews{
    
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = self.view.bounds;
    [self.view addSubview:contentView];
    self.contentView = contentView;

 
    UIView *webContentView = [[UIView alloc]init];
    webContentView.frame = CGRectMake(0, 64 ,Kwidth, Kheight-49-64);
    
    [self.contentView addSubview:webContentView];
    
    webContentView.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc]init];
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    webView.backgroundColor = [UIColor whiteColor];
//    webView.scalesPageToFit = YES;
    webView.frame = CGRectMake(0, 0, Kwidth, webContentView.height_extension);
    [webContentView addSubview: webView];
    self.webView = webView;
    
    CGFloat backViewHeight = 75;
    webView.scrollView.contentInset = UIEdgeInsetsMake(backViewHeight*2+30+Kwidth*0.4*0.72 + 50, 0, 0, 0);
    JULiveCourseView *liveCourseView = [[JULiveCourseView alloc]init];
    liveCourseView.frame = CGRectMake(0,-backViewHeight*2-30-Kwidth*0.4*0.72-50 , Kwidth, 30+Kwidth*0.4*0.72);
    [webView.scrollView addSubview:liveCourseView];
    webView.delegate = self;
    
    
    liveCourseView.backgroundColor = [UIColor whiteColor];
    self.liveCourseView = liveCourseView;
    
    ///////////////////////////////////////////
    
//    领取的view
    UIView *receiveCouponsView = [[UIView alloc]init];
//    receiveCouponsView.backgroundColor = [UIColor redColor];
    receiveCouponsView.frame = CGRectMake(0, -backViewHeight*2-50, Kwidth, 50);
    [webView.scrollView addSubview:receiveCouponsView];
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
    [receiveCouponsView addSubview:receiveCouponButton];
    [receiveCouponButton Y_centerInSuperView];
    [receiveCouponButton addTarget:self action:@selector(shareAction) forControlEvents:(UIControlEventTouchUpInside)];

    ////////////////////////////////////////////////////
    
    //开班时间
    UIView *startTimeView = [[UIView alloc]init];
    startTimeView.backgroundColor = [UIColor whiteColor];
    startTimeView.frame = CGRectMake(0, -backViewHeight*2, Kwidth, backViewHeight);
    [webView.scrollView addSubview:startTimeView];
    
    self.startTimeView = startTimeView;
    
    
    
    UIView *topViewLineView = [[UIView alloc]init];
    topViewLineView.frame = CGRectMake(12, 0, Kwidth-12, 0.5);
    topViewLineView.backgroundColor = HCommomSeperatorline(1);
    [startTimeView addSubview:topViewLineView];
    
    
    //课程时长View
    UIView *courseDurationView = [[UIView alloc]init];
    courseDurationView.backgroundColor = [UIColor whiteColor];
    courseDurationView.frame = CGRectMake(0, -backViewHeight, Kwidth, backViewHeight);
    [webView.scrollView addSubview:courseDurationView];
    self.courseDurationView = courseDurationView;

    //因为设置了偏移量，webView在加载前边会出现一段黑边，用白色view遮盖，之后隐藏
    
    UIView *coverBlackView = [[UIView alloc]init];
    coverBlackView.frame = CGRectMake(0, webView.height_extension-backViewHeight*2-liveCourseView.height_extension-50, Kwidth, backViewHeight*2+liveCourseView.height_extension+50);
    coverBlackView.backgroundColor = [UIColor whiteColor];
    [webView addSubview:coverBlackView];
    self.coverBlackView = coverBlackView;
  

    //开班时间
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(12, 0, 100, 46);
    titleLabel.font = UIptfont(16);
    titleLabel.text = @"开班时间";
    [startTimeView addSubview:titleLabel];
    
    
    UILabel *statrt_timeLabel = [[UILabel alloc]init];
    statrt_timeLabel.frame = CGRectMake(12, titleLabel.bottom_extension, Kwidth-24, 14);
    statrt_timeLabel.font = UIptfont(14);
    statrt_timeLabel.textColor = [UIColor grayColor];
    [startTimeView addSubview:statrt_timeLabel];
    self.statrt_timeLabel = statrt_timeLabel;
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.frame = CGRectMake(12, backViewHeight-0.5, Kwidth-12, 0.5);
    bottomLineView.backgroundColor = HCommomSeperatorline(1);
    [startTimeView addSubview:bottomLineView];
    
    
 
    //课程时长
    UILabel *titleLabel2 = [[UILabel alloc]init];
    titleLabel2.frame = CGRectMake(12, 0, 100, 46);
    titleLabel2.font = UIptfont(16);
    titleLabel2.text = @"课程时长";
    [courseDurationView addSubview:titleLabel2];
    
    
    UILabel *course_hourLabel = [[UILabel alloc]init];
    course_hourLabel.frame = CGRectMake(12, titleLabel.bottom_extension, Kwidth-24, 14);
    course_hourLabel.font = UIptfont(14);
    course_hourLabel.textColor = [UIColor grayColor];
    [courseDurationView addSubview:course_hourLabel];
    self.course_hourLabel = course_hourLabel;
    
    UIView *bottomLineView1 = [[UIView alloc]init];
    bottomLineView1.frame = CGRectMake(12, backViewHeight-0.5, Kwidth-12, 0.5);
    bottomLineView1.backgroundColor = HCommomSeperatorline(1);
    [courseDurationView addSubview:bottomLineView1];
    
    
    
    UIView *enlistButtonParentView = [[UIView alloc]init];
    enlistButtonParentView.frame = CGRectMake(0, Kheight-50, Kwidth, 50);
    [self.view addSubview:enlistButtonParentView];
    
    
    
    
    UIButton *enlistButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    enlistButton.frame = CGRectMake(0, 0, Kwidth, 50);
    [enlistButton.titleLabel setFont:UIptfont(17)];
    [enlistButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [enlistButton setTitle:@"我要报名" forState:(UIControlStateNormal)];
    UIColor *normalColor = Kcolor16rgb(@"#18b4ed", 1);
    [enlistButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateNormal)];
    UIColor *selectedColor = Kcolor16rgb(@"#2ca6e0", 1);
    [enlistButton setBackgroundImage:[UIImage imageWithColor:selectedColor] forState:(UIControlStateHighlighted)];
    [enlistButtonParentView addSubview:enlistButton];
    [enlistButton addTarget:self action:@selector(enlistAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.enlistButton = enlistButton;
    

    JUButton *addShoppingCarButton = [JUButton buttonWithType:(UIButtonTypeCustom)];
    addShoppingCarButton.frame = CGRectMake(0, 0, Kwidth*0.5, 50);
    [addShoppingCarButton.titleLabel setFont:UIptfont(17)];
    [addShoppingCarButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [addShoppingCarButton setTitle:@"加入购物车" forState:(UIControlStateNormal)];
    
    UIColor *orangeColor = Kcolor16rgb(@"#FE824C", 1);
    
    [addShoppingCarButton setBackgroundImage:[UIImage imageWithColor:orangeColor] forState:(UIControlStateNormal)];
//    UIColor *selectedColor = Kcolor16rgb(@"#2ca6e0", 1);
//    [addShoppingCarButton setBackgroundImage:[UIImage imageWithColor:selectedColor] forState:(UIControlStateHighlighted)];
    
    if ([JuuserInfo.showstring isEqualToString:@"1"]) {
        [enlistButtonParentView addSubview:addShoppingCarButton];
    }
    
    [addShoppingCarButton addTarget:self action:@selector(addShoppingAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.addShoppingCarButton = addShoppingCarButton;
    self.addShoppingCarButton.hidden = YES;
    
    
    
    UIView *blackView = [[UIView alloc]init];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:blackView];
//    blackView.userInteractionEnabled = NO;
    self.blackView = blackView;
    
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        self.receiveCouponsView.alpha = 0;
        topViewLineView.hidden = YES;
    }
    
    
    
    
    //友盟分享View
    JUUmengShareView *shareView = [[JUUmengShareView alloc]init];
    shareView.frame = CGRectMake(0, Kheight, Kwidth,0);
    shareView.backgroundColor = [UIColor whiteColor];
    
    __weak JUUmengShareView *weakShareView = shareView;
    
    __weak typeof(self) weakSelf = self;
    shareView.cancelBlcok = ^(UIButton *cancelButton){
        
        [UIView animateWithDuration:0.27 animations:^{
            
            weakShareView.y_extension = Kheight;
            
            weakSelf.blackView.hidden = YES;
            

        }];

    };

    
    shareView.shareBlock = ^(JUShareButton *shareButton){
        
        JUUMengShare *umengShare = [[JUUMengShare alloc]init];
        
        umengShare.liveDetailModel = weakSelf.liveDetailModel;
        
       [umengShare shareDataWithPlatform:(shareButton.platformType)];
        

        
    };

    
    shareView.loginBlock = ^(UIButton *loginButton){
        
    
        JULoginViewController *loginVC = [[JULoginViewController alloc]init];
        
        [weakSelf.navigationController pushViewController:loginVC animated:NO];
         
         
         };
    
    
    [self.view addSubview:shareView];
     self.shareView = shareView;
     //[shareView layoutIfNeeded];
    self.blackView.frame = CGRectMake(0, 0, Kwidth,Kheight-self.shareView.height_extension);
    self.blackView.hidden = YES;

}

#pragma mark 请求数据
-(void)makeDate{
    
    
    YBNetManager *mannger = [[YBNetManager alloc]init];
    
    __weak typeof(self) weakSelf = self;
    
    NSString *urlStrign = [NSString stringWithFormat:@"%@%@",liveCourseDetailURL,self.course_id];
    
//    urlStrign = [NSString stringWithFormat:@"%@%@",@"https://api.julyedu.com/app/v26/course/",self.course_id];
    JULog(@"%@", urlStrign);
    JULog(@"%@", JuuserInfo.headDit);
    [mannger GET:urlStrign parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
    } success:^(NSURLSessionDataTask *task, NSDictionary *responobject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//        JULog(@"%@", responobject);
        if (!responobject) return ;

        self.liveDetailModel = [JULiveDetailModel mj_objectWithKeyValues:responobject[@"data"]];
        

        [self displayShareView];

        
        
        //字典转化为属性值
//          [NSObject createPropertyCodeWithDict:responobject[@"data"]];
//        JULog(@"%@  %@", self.liveDetailModel.share_url, self.liveDetailModel.share_img);
        
        
        
        //打印Model的各个属性值
//       [self.liveDetailModel logObjectExtension_YanBo];
        
            dispatch_async(dispatch_get_main_queue(), ^{

                self.liveCourseView.liveDetailModel = self.liveDetailModel;
                self.statrt_timeLabel.text = self.liveDetailModel.start_time;
                self.course_hourLabel.text = self.liveDetailModel.course_hour;
//                self.navigationItem.title = self.liveDetailModel.course_title;
                
//                self.navigationItem.title = self.liveDetailModel.course_title;
                
                [self.webView loadHTMLString:self.liveDetailModel.catalog baseURL:self.baseURL];
                

//                [self setButtonBackgroundColor];
                
                [self setButtonTitle];
                
            });
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        JULog(@"%@", error);
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [JUUmengStaticTool event:JUUmengStaticCourseDetail key:JUUmengParamCourseNotBuy value:JUUmengStaticPV];

        
    }];

    
}

#pragma mark响应方法
//修改button字体的方法
-(void)setButtonTitle{
    
//    JULog(@"\n\n%@\n\n", self.liveDetailModel.is_buy);
    
    self.addShoppingCarButton.hidden = YES;

    if ([JuuserInfo.showstring isEqualToString:@"1"]) {
        self.enlistButton.frame = CGRectMake(0, 0, Kwidth, self.enlistButton.superview.height_extension);

    }
    
    
    
    if ([self.liveDetailModel.is_buy isEqualToString:@"1"]) {
        self.courseBought = YES;
        [JUUmengStaticTool event:JUUmengStaticCourseDetail key:JUUmengParamCourseBought value:JUUmengStaticPV];
       [self.enlistButton setTitle:@"观看视频" forState:(UIControlStateNormal)];
        
    }else{
        self.courseBought = NO;
        
        [JUUmengStaticTool event:JUUmengStaticCourseDetail key:JUUmengParamCourseNotBuy value:JUUmengStaticPV];
        
        [self.enlistButton setTitle:@"我要报名" forState:(UIControlStateNormal)];
        UIColor *normalColor = Kcolor16rgb(@"#dddddd", 1);
        [self.enlistButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateNormal)];
        self.enlistButton.userInteractionEnabled = NO;
        
        if ([self.liveDetailModel.status isEqualToString:@"0"]) {//未开始
            [JUUmengStaticTool event:JUUmengStaticCourseDetail key:JUUmengParamCourseNotBuy value:@"Waitting"];

        [self.enlistButton setTitle:@"敬请期待" forState:(UIControlStateNormal)];
 
        }else if ([self.liveDetailModel.status isEqualToString:@"1"]){//可报名
            
            UIColor *normalColor = Kcolor16rgb(@"#18b4ed", 1);
            [self.enlistButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateNormal)];
            self.enlistButton.userInteractionEnabled = YES;
            
            self.addShoppingCarButton.hidden = NO;
            
              if ([JuuserInfo.showstring isEqualToString:@"1"]) {
                  self.enlistButton.frame = CGRectMake(Kwidth *0.5, 0, Kwidth*0.5, self.enlistButton.superview.height_extension);

              }

        }else if ([self.liveDetailModel.status isEqualToString:@"2"]){//报名结束
            
        [self.enlistButton setTitle:@"报名结束" forState:(UIControlStateNormal)];
   
        }
    }
}

-(void)setButtonBackgroundColor{
    
    
    if ([self.liveDetailModel.price1 isEqualToString:@"0"]) {
        
        UIColor *normalColor = Kcolor16rgb(@"#dddddd", 1);
        
        [self.enlistButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateNormal)];
        
        self.enlistButton.userInteractionEnabled = NO;
        
    }
    
    
}








-(void)enlistAction:(UIButton *)sender{
    
    if ([self.liveDetailModel.is_buy isEqualToString:@"1"]) {//观看视频
        [JUUmengStaticTool event:JUUmengStaticCourseDetail key:JUUmengParamCourseBought value:@"View"];
        JUCourseDetailViewController *detailVC = [[JUCourseDetailViewController alloc]init];
        detailVC.course_id = self.liveDetailModel.v_id;
        detailVC.course_title = self.liveDetailModel.course_title;

        
        if ([detailVC.course_id isEqualToString:@"0"]) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            GMToast *toasts = [[GMToast alloc]initWithView:window text:@"暂无视频" duration:1.5];
            [toasts show];
            return;
        }
        
        [self.navigationController pushViewController:detailVC animated:NO];
        
    }else{//我要报名
        
        if (JuuserInfo.isLogin) {
            [JUUmengStaticTool event:JUUmengStaticCourseDetail key:JUUmengParamCourseNotBuy value:@"Application"];

            if ([JuuserInfo.showstring isEqualToString:@"0"]) {
                //走内购页面
//                            JUapplicantViewController *applicantVC = [[JUapplicantViewController alloc]initWithStyle:(UITableViewStyleGrouped)];
//                
//                            applicantVC.course_id = self.liveDetailModel.course_id;
//                
//                            applicantVC.lastliveDetailModel = self.liveDetailModel;
//                
//                            [self.navigationController pushViewController:applicantVC animated:NO];
                [self onlineApplicant];

                
                
            }else{
                
                //走购物车页面
                [self onlineApplicant];
                
            }
            
            
            
         
            
        }else{
            
            // 没有登录状况
            
            
            if ([JuuserInfo.showstring isEqualToString:@"0"]) {
                
                [self onlineApplicant];
                
//                JUapplicantViewController *applicantVC = [[JUapplicantViewController alloc]initWithStyle:(UITableViewStyleGrouped)];
//                
//                applicantVC.course_id = self.liveDetailModel.course_id;
//                
//                applicantVC.lastliveDetailModel = self.liveDetailModel;
//                
//                [self.navigationController pushViewController:applicantVC animated:NO];
                
                return;
            }
            
            
            JULoginViewController *loginVC = [[JULoginViewController alloc]init];
            
            [self.navigationController pushViewController:loginVC animated:NO];
          

        }
        
        
        
        
    }

}

-(void)onlineApplicant{
    
    if (self.isInShoppingCar) {//如果已经在购物车 购物车选中
        
        [self gotoApplyPage];
        
    }
    else{ // 添加到购物车
        
        __weak typeof(self) weakSelf = self;
        NSString *urlStrign = [NSString stringWithFormat:@"%@%@",addShoppingCarURL,self.course_id];
        
        
        YBNetManager *manager = [[YBNetManager alloc]init];
        [manager GET:urlStrign parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
            
            JULog(@"%@", responobject);
            
            if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
                
                [weakSelf gotoApplyPage];
                
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            JULog(@"我要报名： %@", error);
            
        }];
        
    }
    
}



//跳转到支付页面
-(void)gotoApplyPage{
    __weak typeof(self) weakSelf = self;
    NSArray *array = [NSArray arrayWithObject:self.course_id];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"course_id"] = array.jsonStringEncoded;
    
    YBNetManager *manager = [[YBNetManager alloc]init];
    
    [manager POST:changeShoppingCarURL parameters:dict headdict:(JuuserInfo.headDit) constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } progress:^(NSProgress * _Nonnull Progress) {
        
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        JULog(@"成功： %@", responseObject);
        
        if ([[responseObject[@"errno"] description] isEqualToString:@"0"]){
            
            JUapplyController *applyVc = [[JUapplyController alloc]init];
            applyVc.dict = dict;
            [weakSelf.navigationController pushViewController:applyVc animated:NO];
           
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
        JULog(@"跳转支付页面error：%@", error);
        
    }];
    
}

-(NSString *)getPurchaseTotalPrice{
    
    NSString *totalPrice = nil;
 
    NSInteger courseID = [self.course_id integerValue];
    
    if (courseID) {
        
        switch (courseID) {
            case 46:{
                
                totalPrice = @"1498";
                break;
            }
            case 47:{
                totalPrice = @"1198";
                
                break;
            }
            case 56:{
                totalPrice = @"1198";
                
                break;
            }
            case 93:{
                totalPrice = @"2598";
                
                break;
            }
            case 102:{
                totalPrice = @"2598";
                
                break;
            }
            case 103:{
                totalPrice = @"2298";
                
                break;
            }
            case 149:{
                totalPrice = @"3298";
                
                break;
            }
                
            default:
                break;
        }
        
        return totalPrice;

    }
    
 
    return @"0";
}


-(void)addShoppingAction:(UIButton *)sender{
    __weak typeof(self) weakSelf = self;
    
    NSString *urlStrign = [NSString stringWithFormat:@"%@%@",addShoppingCarURL,self.course_id];

    [JUUmengStaticTool event:JUUmengStaticCourseDetail key:JUUmengParamCourseNotBuy value:@"AddToCart"];

    
    if (JuuserInfo.isLogin) {
        
        //如果已经在购物车中，跳转到购物车
        if (weakSelf.isInShoppingCar) {
            
            
            [self gotoShoppingCar:nil];
            
            
            
           //否则加入购物车
        }else{
            
            YBNetManager *manager = [[YBNetManager alloc]init];
            [manager GET:urlStrign parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
                
                
            } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
                
                JULog(@"%@", responobject);
                
                
                if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
                    
                    
                    [responobject showWithView:nil text:@"已经加入购物车" duration:1.5];
                    
                    [weakSelf goodsShowState];
                }else{
                    
                    [responobject showWithView:nil text:responobject[@"msg"] duration:1.5];
                    
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                
                
                
            }];

            
            
        }
        
        
        
        
       
        
    }else{
        
        JULoginViewController *loginVC = [[JULoginViewController alloc]init];
        
        [self.navigationController pushViewController:loginVC animated:NO];
        
        
    }
    
    
    
}




-(void)isOrNotInshoppingCar{
    
    UIColor *orangeColor = Kcolor16rgb(@"#FE824C", 1);
      UIColor *redColor = Kcolor16rgb(@"#ff3c00", 1);
    

    __weak typeof(self) weakSelf = self;
    
    NSString *urlStrign = [NSString stringWithFormat:@"%@%@",goodInShoppingCarURL,self.course_id];

    YBNetManager *manager = [[YBNetManager alloc]init];
    
    [manager GET:urlStrign parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        
                    JULog(@"%@", responobject);
        
        
        if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
            
            if ([[responobject[@"data"][@"status"] description] isEqualToString:@"1"]) {
                //在购物车
//                weakSelf.addShoppingCarButton.userInteractionEnabled = NO;
                [weakSelf.addShoppingCarButton setBackgroundImage:[UIImage imageWithColor:redColor] forState:(UIControlStateNormal)];
                
                weakSelf.isInShoppingCar = YES;
                
                //如果已经在购物车，改变购物车按钮字体
                [weakSelf.addShoppingCarButton setTitle:@"去购物车结算" forState:(UIControlStateNormal)];

                
       
            }else{
                //不在购物车
                
//                weakSelf.addShoppingCarButton.userInteractionEnabled = YES;
                [weakSelf.addShoppingCarButton setBackgroundImage:[UIImage imageWithColor:orangeColor] forState:(UIControlStateNormal)];
                [weakSelf.addShoppingCarButton setTitle:@"加入购物车" forState:(UIControlStateNormal)];
                weakSelf.isInShoppingCar = NO;

            }

            
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
//通知方法
-(void)shareCouponSucceed:(NSNotification *)notifi{
    
    if ([self.liveDetailModel.coupon_amount isEqualToString:@"0"]) return;
    
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

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.coverBlackView.hidden = YES;
    
}

#pragma mark 系统方法
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    UIColor *tabBarColor = Kcolor16rgb(@"#f7f9fc", 1);
    [self.navigationController.navigationBar setBarTintColor:tabBarColor];
    
    [self makeDate];
    [self goodsShowState];
    
}
-(void)displayShareView{
    
    //分享金额为0时，不开启分享
    if ([self.liveDetailModel.coupon_amount isEqualToString:@"0"]) {
        _receiveCouponsHeight = 0;
        self.shareView.showLogin = NO;
        self.receiveCouponsView.hidden = YES;
        
    }else{
        
        _receiveCouponsHeight = 50;
        self.shareView.showLogin = YES;
        self.receiveCouponsView.hidden = NO;

        self.sharePriceLabel.text = [NSString stringWithFormat:@"分享课程领取%@元优惠券", self.liveDetailModel.coupon_amount];

    }
    
    [self displayFrame];
    
    [self.shareView setNeedsLayout];
    [self.shareView layoutIfNeeded];
     self.blackView.alpha = 0.5;
    self.blackView.height_extension = Kheight - self.shareView.height_extension;
}


-(void)displayFrame{
    
    
    CGFloat backViewHeight = 75;
    
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(backViewHeight*2+30+Kwidth*0.4*0.72 + _receiveCouponsHeight, 0, 0, 0);
    self.liveCourseView.frame = CGRectMake(0,-backViewHeight*2-30-Kwidth*0.4*0.72-_receiveCouponsHeight , Kwidth, 30+Kwidth*0.4*0.72);
    
    self.receiveCouponsView.frame = CGRectMake(0, -backViewHeight*2-_receiveCouponsHeight, Kwidth, _receiveCouponsHeight);
    
    self.startTimeView.frame = CGRectMake(0, -backViewHeight*2, Kwidth, backViewHeight);
    self.courseDurationView.frame = CGRectMake(0, -backViewHeight, Kwidth, backViewHeight);
    
    
    self.coverBlackView.frame = CGRectMake(0, _webView.height_extension-backViewHeight*2-_liveCourseView.height_extension-_receiveCouponsHeight, Kwidth, backViewHeight*2+_liveCourseView.height_extension+_receiveCouponsHeight);

}





-(void)goodsShowState{
    [self getGoodsNumberFromShoppingCar];
    [self isOrNotInshoppingCar];

    
    
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{

    NSURL *requestURL = [request URL];
    
    BOOL iswebURL = [[requestURL scheme] isEqualToString:@"http"] || [[requestURL scheme] isEqualToString:@"https"];
    
    if ( iswebURL && navigationType == UIWebViewNavigationTypeLinkClicked) {
        
      return  ![[UIApplication sharedApplication ] openURL: requestURL];
        
    }
    
    return YES;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.blackView.alpha = 0;

    
}




- (void)dealloc
{
    [self.blackView removeFromSuperview];
    self.blackView = nil;
    
  
    
}


@end
