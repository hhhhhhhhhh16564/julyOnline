//
//  JUapplicantViewController.m
//  algorithm
//
//  Created by 周磊 on 16/8/22.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUapplicantViewController.h"
#import "JUButton.h"
#import "JURegistrationView.h"
#import "JULiveCourseView.h"
#import "JUapplicantCell.h"
#import "JUsignUpInfomationController.h"
#import "JUDiscountRulesController.h"
#import "JUOnlinepaymentController.h"
#import "JUUserInfoModel.h"
#import "JUCouponController.h"
#import "JUOrderModel.h"






static NSString *applicantViewCell = @"applicantViewCell";

@interface JUapplicantViewController ()

@property(nonatomic, strong) UIView *footView;
@property(nonatomic, strong) UILabel *priceLabel;

//课程信息
@property(nonatomic, strong) JULiveDetailModel *liveDetailModel;

//报名信息
@property(nonatomic, strong)  JUUserInfoModel *userInfoModel;




@property(nonatomic, strong) JURegistrationView *registrationView;

@property(nonatomic, strong) JUButton *button;

//减少价格
@property(nonatomic, strong) NSString *reducePrice;



//优惠码
@property(nonatomic, strong) NSString *couponCode;

//订单
@property(nonatomic, strong) JUOrderModel *orderModel;



@end

@implementation JUapplicantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HCanvasColor(1);
    
    
    [self setupViews];
    
    [self makeData];
    
    
}

#pragma mark 视图布局

-(void)setupViews{
    self.navigationItem.title = @"课程报名";
    [self.tableView registerClass:[JUapplicantCell class] forCellReuseIdentifier:applicantViewCell];
    
    //默认减少价格是0
    self.reducePrice=@"无";
    self.couponCode = @"0";
    
    UIView *headerView = [[UIView alloc]init];
    CGFloat headerViewHeight = 120+70+Kwidth*0.72*0.4;
    headerView.frame = CGRectMake(0, 64, Kwidth, headerViewHeight);
    
    
    
    
    JURegistrationView *registrationView = [[JURegistrationView alloc]init];
    
    registrationView.frame = CGRectMake(0, 10, Kwidth, 100);
    
    [headerView addSubview:registrationView];
    
    self.registrationView = registrationView;
    
    
    
    
    JUButton *button = [JUButton buttonWithType:(UIButtonTypeCustom)];
    button.backgroundColor = [UIColor whiteColor];
    button.frame = CGRectMake(0, 0, Kwidth-24, 80);
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    UIColor *borderColor = Kcolor16rgb(@"3cb4f6", 1);
    button.layer.borderColor = borderColor.CGColor;
   
    [button setImage:[UIImage imageNamed:@"apply_icon_write"] forState:(UIControlStateNormal)];
    
    [button setTitle:@"填写报名信息" forState:(UIControlStateNormal)];
    
    [button setTitleColor:borderColor forState:(UIControlStateNormal)];
    
    [button.titleLabel setFont:UIptfont(15)];
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, -8)];
    
//    [button addTarget:self action:@selector(registrationAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [registrationView addSubview:button];
    
    [button XY_centerInSuperView];
    
    self.button = button;
    
//    self.button.hidden = YES;

    //事件响应点击的button
    UIButton *respondButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [respondButton addTarget:self action:@selector(registrationAction:) forControlEvents:(UIControlEventTouchUpInside)];

    respondButton.frame = CGRectMake(0, 0, Kwidth, 90);
    [registrationView addSubview:respondButton];
    [respondButton XY_centerInSuperView];

    UIView *lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = HCommomSeperatorline(1);
    lineView1.frame = CGRectMake(0, registrationView.height_extension, Kwidth, 0.5);
    [registrationView addSubview:lineView1];
    

    
    
    UIView *detailView = [[UIView alloc]init];
    detailView.backgroundColor = [UIColor whiteColor];
    detailView.frame = CGRectMake(0, registrationView.bottom_extension+10, Kwidth, 60+Kwidth*0.4*0.72);
    [headerView addSubview:detailView];
    
    
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        registrationView.hidden = YES;
        headerView.height_extension = headerView.height_extension-registrationView.height_extension-25;
        registrationView.height_extension = 0.01;
        detailView.y_extension = 0;
    }
    
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = HCommomSeperatorline(1);
    lineView2.frame = CGRectMake(0, 0, Kwidth, 0.5);
    [detailView addSubview:lineView2];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"课程详情";
    titleLabel.frame = CGRectMake(12, 0, Kwidth-12, 45);
    titleLabel.font = UIptfont(15);
    [detailView addSubview:titleLabel];
    
    
    JULiveCourseView *liveCourseView = [[JULiveCourseView alloc]init];
    liveCourseView.frame = CGRectMake(0, titleLabel.bottom_extension-15, Kwidth, Kwidth*0.4*0.72+30);
    [detailView addSubview:liveCourseView];
    liveCourseView.liveDetailModel = self.lastliveDetailModel;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(courseViewTap)];
    [liveCourseView addGestureRecognizer:tap];
    
    //尾部确认订单
    UIView *footView = [[UIView alloc]init];
    footView.frame = CGRectMake(0, Kheight-44-64, Kwidth, 44);
    footView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:footView];
    self.footView = footView;
    
    
    UIView *lineView3= [[UIView alloc]init];
    lineView3.backgroundColor = HCommomSeperatorline(1);
    lineView3.frame = CGRectMake(0, 0, Kwidth, 0.5);
    [footView addSubview:lineView3];
    
    
    UILabel *totalLable = [[UILabel alloc]init];
    totalLable.font = UIptfont(17);
    CGFloat fragmentWidth = (Kwidth-110)*0.3333;
    totalLable.frame = CGRectMake(fragmentWidth, 0, fragmentWidth, 44);
    totalLable.textAlignment = NSTextAlignmentRight;
    totalLable.text = @"合计:";
    [self.footView addSubview:totalLable];
    
    
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.font = UIptfont(17);
    priceLabel.textColor = [UIColor redColor];
    priceLabel.frame = CGRectMake(fragmentWidth * 2, 0, fragmentWidth, 44);
    priceLabel.textAlignment = NSTextAlignmentCenter;

    [self.footView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    
    
    UIButton *confirmButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    confirmButton.frame = CGRectMake(Kwidth-110, 0, 110, 44);
    UIColor *backgroundImageColor = Kcolor16rgb(@"#18b4ed", 1);
//    [confirmButton setBackgroundImage:[UIImage imageWithColor:backgroundImageColor] forState:(UIControlStateNormal)];
    
    [confirmButton setBackgroundColor:backgroundImageColor];
   [confirmButton setTitle:@"确定订单" forState:(UIControlStateNormal)];
   
   [confirmButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
   
   [confirmButton.titleLabel setFont:UIptfont(17)];
   
   [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
   
   [self.footView addSubview:confirmButton];
    
    
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
}

-(void)courseViewTap{
    
    [JUUmengStaticTool event:JUUmengStaticCourseApplication key:JUUmengStaticCourseApplication value:@"CourseInfo"];

}

#pragma mark 代理方法

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JUapplicantCell *cell = [tableView dequeueReusableCellWithIdentifier:applicantViewCell forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = @"尊享优惠价";
        
        cell.detailTextLabel.text = @"￥999";
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"apply_sign_question"]];
        
        if ([JuuserInfo.showstring isEqualToString:@"0"]) {
            
            cell.accessoryView = nil;
            cell.userInteractionEnabled = NO;
            
        }
        

        
    }else if(indexPath.section == 1){
        
        cell.textLabel.text = @"优惠码";
//        cell.detailTextLabel.text = @"无";
        cell.detailTextLabel.textColor = [UIColor grayColor];

        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"apply_icon_arrow"]];
        

    }
    
    
    
    return cell;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat y = Kheight;
    self.footView.y_extension = y + (scrollView.contentOffset.y-44);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        
        return 1;
    }
    
    
    return 2;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    JULog(@"%s", __func__);
    
    
    if (indexPath.section == 0) {
        [JUUmengStaticTool event:JUUmengStaticCourseApplication key:JUUmengStaticCourseApplication value:@"UserPrivilege"];

        //优惠规则
        JUDiscountRulesController *disCountVC = [[JUDiscountRulesController alloc]init];
        disCountVC.course_id = self.liveDetailModel.course_id;
        
        disCountVC.price_level = self.liveDetailModel.level;
        
        [self.navigationController pushViewController:disCountVC animated:NO];
        
    
    }else{
        
        [JUUmengStaticTool event:JUUmengStaticCourseApplication key:JUUmengStaticCourseApplication value:@"Privilege"];

        //优惠码
        JUCouponController *couponController = [[JUCouponController alloc]init];
        couponController.cid = self.course_id;
        //减少价格
        __weak typeof(self) weakSelf = self;
        
        couponController.myBlock = ^(NSString *redcePrice){
            
            weakSelf.reducePrice = redcePrice;
            
        };
        
        couponController.couponBlock = ^(NSString *couponString){
            
            weakSelf.couponCode = couponString;
            
        };
        
        
        couponController.buttonString = @"确定使用";
        
        if (![self.reducePrice isEqualToString:@"无"]) {
            
            couponController.buttonString = @"取消使用";
            
        }
        
        [self.navigationController pushViewController:couponController animated:NO];
   
    }
    
}



#pragma mark 响应方法

//填写报名信息
-(void)registrationAction:(JUButton *)button{
    
    [JUUmengStaticTool event:JUUmengStaticCourseApplication key:JUUmengStaticCourseApplication value:@"UserInfo"];

    JUlogFunction
    
    JUsignUpInfomationController *signupVC = [[JUsignUpInfomationController alloc]init];
    
    signupVC.userInfoModel = self.userInfoModel;
    [self.navigationController pushViewController:signupVC animated:NO];
}


//确定订单Action
-(void)confirmButtonAction:(UIButton *)button{
    [JUUmengStaticTool event:JUUmengStaticCourseApplication key:JUUmengStaticCourseApplication value:@"Buy"];

    
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        
        [self makeSureOrder];

        return;
    }
    
    
        
    if (self.button.hidden == NO) { //如果button不隐藏，既信息填写不完整
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        GMToast *toasts = [[GMToast alloc]initWithView:window text:@"请填写报名信息" duration:1.5];
        [toasts show];
        
        return;
        
    }
    
    [self makeSureOrder];
    
}


#pragma mark 数据请求

//确定订单

-(void)makeSureOrder{
    
        YBNetManager *mannger = [[YBNetManager alloc]init];
    NSMutableDictionary *dictonary = [NSMutableDictionary dictionary];
    
    dictonary[@"course_id"] = self.course_id;
    
    dictonary[@"coupon"] = self.couponCode;
    
    [mannger POST:createOrderURL parameters:dictonary headdict:JuuserInfo.headDit constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } progress:^(NSProgress * _Nonnull Progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary *responseObject) {
        
        JULog(@"*******\n%@\n*******", responseObject);
        
        
        if (![[responseObject[@"errno"] description] isEqualToString:@"0"]) return ;
        
        NSMutableDictionary *dict = responseObject[@"data"][@"order"];
        
//        [NSObject createPropertyCodeWithDict:dict];

        self.orderModel = [JUOrderModel mj_objectWithKeyValues:dict];
//        [self.orderModel logObjectExtension_YanBo];
        
        
        //提交订单后进入下一个页面
        
        //提交订单成功后，此优惠码不可用，优惠码字体变为无
        self.reducePrice = @"无";
        
   
        JUOnlinepaymentController *onlineVC = [[JUOnlinepaymentController alloc]init];
        onlineVC.orderModel = self.orderModel;
        
        [self.navigationController pushViewController:onlineVC animated:NO];
        
  
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        JULog(@"请求信息失败");
        
    }];
    
    
  
    
    
    
}



-(void)makeData{
    
    YBNetManager *mannger = [[YBNetManager alloc]init];
    
//    __weak typeof(self) weakSelf = self;
    
    JULog(@"%@", JuuserInfo.headDit);
    
    NSString *urlStrign = [NSString stringWithFormat:@"%@%@",applicantViewControllerURL, self.course_id];
    
    [mannger GET:urlStrign parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *responobject) {
        
        if (!responobject) return ;
        
        
        self.liveDetailModel = [JULiveDetailModel mj_objectWithKeyValues:responobject[@"data"][@"course_info"]];
        
        self.userInfoModel = [JUUserInfoModel mj_objectWithKeyValues:responobject[@"data"][@"user_info"]];
        
        
        [self setUpregistrationView];
        
       JULog(@"%@", responobject);
        
        //字典转化为属性值
//          [NSObject createPropertyCodeWithDict:responobject[@"data"][@"user_info"]];
        
        
        //打印Model的各个属性值
//              [self.liveDetailModel logObjectExtension_YanBo];
//       [self.userInfoModel logObjectExtension_YanBo];

        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        

    }];

}


//数据请求后改变View
-(void)setUpregistrationView{
    
    self.registrationView.userInfoModel = self.userInfoModel;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    JUapplicantCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",self.liveDetailModel.level_price];
    
    if ([self.reducePrice isEqualToString:@"无"]) {
        
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",self.liveDetailModel.level_price];
        
    }

    
    
    if ([self.userInfoModel.cellphone isEqualToString:@"0"]) {
        
        self.button.hidden = NO;

    }else{
        
        self.button.hidden = YES;
    }
 
}


#pragma mark 系统方法
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    [JUUmengStaticTool event:JUUmengStaticCourseApplication key:JUUmengStaticCourseApplication value:JUUmengStaticPV];
    
    
//请求刷新数据
    [self makeData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    JUapplicantCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.reducePrice isEqualToString:@"无"]){
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.text = self.reducePrice;

        //优惠码为无
        self.couponCode = @"0";
        
        
    }else{
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"-¥%@",self.reducePrice];
        
        cell.detailTextLabel.textColor = [UIColor redColor];
        
        
        NSUInteger totalPrice = [self.liveDetailModel.level_price integerValue];
        NSUInteger reducePricenumber = [self.reducePrice integerValue];
        
        NSUInteger actualPayPrice = totalPrice - reducePricenumber;
        
        self.priceLabel.text = [NSString stringWithFormat:@"¥%zd", actualPayPrice];
        
        if ([JuuserInfo.showstring isEqualToString:@"0"]) {
            
            self.priceLabel.text = [NSString stringWithFormat:@"¥%@",self.lastliveDetailModel.price1];


            
        }
          
        
    }
    
    
    
    
    
    
}

//合计的价格















@end
