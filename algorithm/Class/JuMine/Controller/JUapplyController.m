//
//  JUapplyController.m
//  algorithm
//
//  Created by 周磊 on 17/1/24.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUapplyController.h"
#import "JUapplyCell.h"
#import "JUDiscountRulesController.h"
#import "JUUserInfoModel.h"
#import "JUCouponCodeController.h"
#import "JURegistrationView.h"
#import "JUButton.h"
#import "JUsignUpInfomationController.h"
#import "JUPayController.h"
#import "JUUsingCouponCodeController.h"
static NSString *const applyCell = @"applyCell";

@interface JUapplyController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *footView;
@property(nonatomic, strong) UILabel *priceLabel;

@property(nonatomic, strong) UILabel *totalLabel;


@property(nonatomic, strong) JUUserInfoModel *userInfoModel;

@property(nonatomic, strong) NSString *totalPrice;




//报名信息有关
@property(nonatomic, strong) JURegistrationView *registrationView;
@property(nonatomic, strong) JUButton *button;

@property (nonatomic,assign) BOOL isFirstload;


@end

@implementation JUapplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"课程报名";
    [self setup_SubViews];
    
//    [self makeData];
    [self repadateRequestDate];
    
    self.isFirstload = YES;

}


-(void)repadateRequestDate{
//    [manager POST:changeShoppingCarURL parameters:dict headdict:JuuserInfo.headDit constructingBodyWithBloc
    __weak typeof(self) weakSelf = self;
    YBNetManager *manager = [[YBNetManager alloc]init];
    
    [manager POST:changeShoppingCarURL parameters:self.dict headdict:(JuuserInfo.headDit) constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } progress:^(NSProgress * _Nonnull Progress) {
        
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject[@"errno"] description] isEqualToString:@"0"]){
            [weakSelf makeData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
     
     
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setup_SubViews{
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setup_tableview];
    [self setHeaderView];
    [self setFootView];
    
}
-(void)setup_tableview{
    
    CGRect tableViewFrame =  CGRectMake(0, 64, Kwidth, Kheight-64-44+8);
    self.tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HCanvasColor(1);
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[JUapplyCell class] forCellReuseIdentifier:applyCell];
    
}
-(void)setHeaderView{
    
    UIView *headerView = [[UIView alloc]init];
    CGFloat headerViewHeight = 120;
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
    
    
    self.tableView.tableHeaderView = headerView;
    
    
}
-(void)setFootView{

    
    //尾部确认订单
    UIView *footView = [[UIView alloc]init];
    footView.frame = CGRectMake(0, Kheight-44, Kwidth, 44);
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    self.footView = footView;
    
    
    UIView *lineView3= [[UIView alloc]init];
    lineView3.backgroundColor = HCommomSeperatorline(1);
    lineView3.frame = CGRectMake(0, 0, Kwidth, 0.5);
    [footView addSubview:lineView3];
    
    
    
    UILabel *totalLable = [[UILabel alloc]init];
    totalLable.font = UIptfont(17);
    CGFloat fragmentWidth = (Kwidth-110)*0.3333;
    totalLable.frame = CGRectMake(0, 0, fragmentWidth*2, 44);
    totalLable.textAlignment = NSTextAlignmentRight;
    totalLable.text = @"合计:";
    [self.footView addSubview:totalLable];
    self.totalLabel = totalLable;
    
    
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
}





#pragma mark 代理方法




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JUapplyCell *cell = [tableView dequeueReusableCellWithIdentifier:applyCell forIndexPath:indexPath];
    
     __weak typeof(self) weakSelf = self;
    
//    cell.disPriceBlock = ^(JUShoppingCarModel *shoppingCarModel){
//        
//        //优惠规则
//        JUDiscountRulesController *disCountVC = [[JUDiscountRulesController alloc]init];
//        disCountVC.course_id = shoppingCarModel.course_id;
//        
//        disCountVC.price_level = shoppingCarModel.level;
//        
//        [weakSelf.navigationController pushViewController:disCountVC animated:NO];
//        
//        
//    };

    cell.couponCodeBlock = ^(JUShoppingCarModel *shoppingCarModel){
        
        //优惠券
        JUUsingCouponCodeController *CouponCodeVC = [[JUUsingCouponCodeController alloc]init];
//        couponCodeVC.shoppingCarModel = shoppingCarModel;
        CouponCodeVC.courseID = shoppingCarModel.course_id;
        [weakSelf.navigationController pushViewController:CouponCodeVC animated:NO];        
    };
    
    cell.shoppingCarModel = self.shoppingCarArray[indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [JUUmengStaticTool event:JUUmengStaticCourseApplication key:JUUmengStaticCourseApplication value:@"CourseInfo"];

}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //加10是因为重新设置cell的fram时高度减去10,所以这儿要加上10
    
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        
        return 115+Kwidth*0.3334*0.72+8-44-44;

    }

    // 90是固定高度，
    return 115+Kwidth*0.3334*0.72+8-44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.shoppingCarArray.count;
}

#pragma mark 响应方法
-(void)confirmButtonAction:(UIButton *)sender{
    
    
    if (self.button.hidden == NO) { //如果button不隐藏，既信息填写不完整
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        GMToast *toasts = [[GMToast alloc]initWithView:window text:@"请填写报名信息" duration:1.5];
        [toasts show];
        
        return;
    
    }
   [self makeSureOrder];
    

}



-(void)makeSureOrder{
    
    
    JUPayController *payVC = [[JUPayController alloc]init];
    payVC.purchaseArray = self.shoppingCarArray;
    payVC.purchaseTotalPrice = self.purchaseTotalPrice;
    YBNetManager *manager = [[YBNetManager alloc]init];
    
    __weak typeof(self) weakSelf = self;
    
    JULog(@"%@"  ,JuuserInfo.headDit);
    
    [manager GET:submitOrderURL parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        
        
        JULog(@"确定订单： %@", responobject);
        NSString *responseCode = [responobject[@"errno"] description];
        
        
        if ([responseCode isEqualToString:@"0"]) {
            
            payVC.orderID = responobject[@"data"][@"order_id"];
            
            payVC.is_free = [NSString stringWithFormat:@"%@", responobject[@"data"][@"is_free"]];
            
            [weakSelf.navigationController pushViewController:payVC animated:NO];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        
    }];
    
}


//填写报名信息
-(void)registrationAction:(JUButton *)button{
    
//    JUlogFunction
    [JUUmengStaticTool event:JUUmengStaticCourseApplication key:JUUmengStaticCourseApplication value:@"UserInfo"];

    JUsignUpInfomationController *signupVC = [[JUsignUpInfomationController alloc]init];
    
    signupVC.userInfoModel = self.userInfoModel;
    
    [self.navigationController pushViewController:signupVC animated:NO];
    
    
    
}


#pragma mark 请求数据
-(void)makeData{
    

    
    __weak typeof(self) weakSelf = self;
    YBNetManager *manager = [[YBNetManager alloc]init];

    [manager GET:v26cartCheckURL parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        
        
        JULog(@"%@",responobject);
        
//        responobject[@"data"][@"course"]
//        [UIView createPropertyCodeWithDict:responobject[@"data"][@"course"]];
        
        
        
        if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
            
            weakSelf.shoppingCarArray = [JUShoppingCarModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"course"]];

  
            weakSelf.userInfoModel = [JUUserInfoModel mj_objectWithKeyValues:responobject[@"data"][@"u"]];
            
            [weakSelf setUpregistrationView];
            
            
//            weakSelf.totalPrice = [responobject[@"data"][@"total"] description];
            
            weakSelf.totalLabel.text = [NSString stringWithFormat:@"%zd门课程    合计:", weakSelf.shoppingCarArray.count];
            weakSelf.priceLabel.text = [NSString stringWithFormat:@"¥%@",[responobject[@"data"][@"total"] description]];
            
            
            if ([JuuserInfo.showstring isEqualToString:@"0"]) {
                
     
                    weakSelf.priceLabel.text = [NSString stringWithFormat:@"¥%@", self.purchaseTotalPrice];
       
                
            }
            
            
            
            
            [weakSelf.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        JULog(@"%@",error);
        
  
    }];

}

//数据请求后改变View
-(void)setUpregistrationView{

    self.registrationView.userInfoModel = self.userInfoModel;


    if ([self.userInfoModel.cellphone isEqualToString:@"0"]) {
        
        self.button.hidden = NO;
        
    }else{
        
        self.button.hidden = YES;
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [JUUmengStaticTool event:JUUmengStaticCourseApplication key:JUUmengStaticCourseApplication value:JUUmengStaticPV];
    if (self.isFirstload) {
        
        self.isFirstload = NO;
        
    }else{
        
      [self makeData];

        
    }
    
    
    
    
}


@end
