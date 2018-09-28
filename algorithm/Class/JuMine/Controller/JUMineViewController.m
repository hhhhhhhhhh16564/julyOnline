//
//  JUMineViewController.m
//  algorithm
//
//  Created by pro on 16/7/4.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUMineViewController.h"
#import "JUCourseViewCell.h"
#import "JULoginViewController.h"
#import "JURegisteredViewController.h"
#import "JUAboutCompanyController.h"
#import "JUMineLoginStateController.h"
#import "JUpurchaseController.h"
#import "JURegisterLoginIBackInfo.h"
#import "JUDateBase.h"
#import "JUShoppingCarOrderController.h"
#import "JUMyCouponViewController.h"
static NSString * juCourseViewCell = @"mineCourseViewCell";


@interface JUMineViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIImageView *userIcon;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *loginView;

@property(nonatomic, strong) UIButton *logoutButton;
//注销请求
@property(nonatomic, strong) YBNetManager *logoutRequest;
@end

@implementation JUMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //登录状态发生改变通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginStateDidChanged:) name:JULoginStatueDidChanged object:nil];

    
    
    [self p_setupViews];
    
//    JUMineLoginStateController *loginVC = [[JUMineLoginStateController alloc]init];
//   [self addChildViewController:loginVC];
//
//    self.loginView = loginVC.view;
//    self.loginView.frame = CGRectMake(0, 0, Kwidth, Kheight-49);
    
    [self loginStateDidChanged:nil];
    
    [self deleteCashes];

}

//每次打开时，删除一下下载的缓存垃圾文件
-(void)deleteCashes{
    
    if ([JuuserInfo.showstring isEqualToString:@"1"]){
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSFileManager *manager = [NSFileManager defaultManager];
            NSString *cachesPath = NSSearchPathForDirectoriesInDomains(algorithmDowonloadMediaCachPath, NSUserDomainMask, YES)[0];
            cachesPath = [NSString stringWithFormat:@"%@/com.july.edu.algorithm/fsCachedData", cachesPath];
            [manager removeItemAtPath:cachesPath error:nil];
            [manager createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:nil];
            JULog(@"%@", cachesPath);
            
        }); 
        
        
    }
        
        
        

    
}

#pragma mark 视图布局
//设置子控件
-(void)p_setupViews{
    
    
//填一个大View，为了向上偏移
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(0, 64, Kwidth, Kheight-49-64);

    [self.view addSubview:contentView];
    
    self.contentView = contentView;

    
    

   //顶部view
//    UIView *topView = [[UIView alloc]init];
//    
//    topView.frame = CGRectMake(0, 0, Kwidth, 270);
//    topView.backgroundColor = Kcolor16rgb(@"#18b4ed", 1);
//    
//    //图像
//    UIImageView *userIcon = [[UIImageView alloc]init];
//    userIcon.image = [UIImage imageNamed:@"personal_head_sign"];
//    [topView addSubview:userIcon];
//    userIcon.layer.masksToBounds = YES;
//    self.userIcon = userIcon;
//    
//    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(80, 80));
//        make.top.equalTo(topView).with.offset(60);
//        make.centerX.equalTo(topView);
//        
//    }];
//    
//    //登录按钮
//    UIButton *loginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    
//    loginButton.layer.cornerRadius = 4;
//    loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
//    loginButton.layer.borderWidth = 1;
//    loginButton.titleLabel.textColor = [UIColor whiteColor];
//    [loginButton setTitle:@"登录" forState:(UIControlStateNormal)];
//    loginButton.titleLabel.font = UIptfont(15);
//    
//    UIColor *normolColor = Kcolor16rgb(@"#18b4ed", 1);
//    [loginButton setBackgroundImage:[UIImage imageWithColor:normolColor] forState:(UIControlStateNormal)];
//    
//    UIColor *hightedColor = Kcolor16rgb(@"#46c3f1", 1);
//
//    [loginButton setBackgroundImage:[UIImage imageWithColor:hightedColor] forState:(UIControlStateHighlighted)];
//
//    [topView addSubview:loginButton];
//    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.size.mas_equalTo(CGSizeMake(100, 30));
//        make.top.equalTo(userIcon.mas_bottom).offset(30);
//        make.centerX.equalTo(topView);
//        
//    }];
//    
//    
//    //注册按钮方法
//    UIButton *registeredButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [registeredButton addTarget:self action:@selector(registeredButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    
//    
//    [registeredButton setTitle:@"没有账号， 去注册 >" forState:(UIControlStateNormal)];
//    [registeredButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    [topView addSubview:registeredButton];
//    [registeredButton.titleLabel setFont:UIptfont(14)];
//    
//    [registeredButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(loginButton.mas_bottom).offset(25);
//        make.centerX.equalTo(topView);
//        
//        
//    }];
//    
    


    //底部Viwe 是一个tableView
    
    CGRect tableViewFrame =  CGRectMake(0, 0, Kwidth, Kheight-49-64);
    
    self.tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = HCanvasColor(1);
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.tableView];
    self.tableView.tableFooterView = [self setupFootView];
    
    [self.tableView registerClass:[JUCourseViewCell class] forCellReuseIdentifier:juCourseViewCell];

            
}


-(UIView *)setupFootView{
    
    UIView *footView = [[UIView alloc]init];
    footView.frame = CGRectMake(0, 0, self.view.width_extension, 56+40);
//    footView.backgroundColor = HCanvasColor(1);
    footView.backgroundColor = [UIColor whiteColor];
    //退出按钮
    UIButton *logoutButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.logoutButton = logoutButton;
    [logoutButton addTarget:self action:@selector(logoutAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    logoutButton.layer.cornerRadius = 4;
    logoutButton.layer.borderColor = (Hcgray(1)).CGColor;
    logoutButton.layer.borderWidth = 1;
    //    logoutButton.titleLabel.textColor = Hcgray(1);
    [logoutButton setTitleColor:Hcgray(1) forState:(UIControlStateNormal)];
    [logoutButton setTitle:@"退出登录" forState:(UIControlStateNormal)];
    logoutButton.titleLabel.font = UIptfont(16);
    [logoutButton setBackgroundColor:[UIColor whiteColor]];
    [footView addSubview:logoutButton];
    
    [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.centerX.equalTo(footView);
        make.bottom.equalTo(footView);
    }];
    
    return footView;
    
}

-(void)logoutAction:(UIButton *)button{
    if (JuuserInfo.isLogin) {
        
        [self logout];
        
    }else{
        
        [self loginAction:nil];
    }
    
    
    
}


#pragma mark 响应方法

//注销方法
//注销方法
-(void)logout{
    [JUUmengStaticTool event:JUUmengStaticMine key:JUUmengParamMineLogin value:@"Logout"];
    
    
    JULog(@"退出登录++++++++++++++++++++++++++");
    
    if (networkingType == NotReachable) {
        
        [self showWithView:nil text:@"请检查你的网络" duration:1.5];
        return;
    }
    
    
    
    
    if (JuuserInfo.isLogin) {
        
        //判断是否应注销，取消之前的请求,防止重复点击
        if (self.logoutRequest) {
            [self.logoutRequest canceAllrequest];
            self.logoutRequest = nil;
            
        }
        
        
        [MBProgressHUD showMessage:@"正在注销中" toView:self.view];
        
        NSMutableDictionary *headdic = JuuserInfo.headDit;
        
        self.logoutRequest = requestManager;
        
        
        
        __weak typeof(self) weakself = self;
        
        JULog(@"%@------------", headdic);
        
        
        [self.logoutRequest POST:logoutURL parameters:nil headdict:headdic progress:^(NSProgress *progress) {
            
            
        } success:^(NSURLSessionDataTask *task, id responobject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
                
            });
            
            
            if (responobject) {
                
                //                JULog(@"请求成功: %@",responobject);
                
                if (responobject[@"errno"]) {
                    //msg字段是ok时，注销成功
                    if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
                        
                        JULog(@"注销成功");
                        
                        JuuserInfo.isLogin = NO;
                        JuuserInfo.loginDate = nil;
                        
                        [JuuserInfo logoutClear];
                        JUDownloadManager *manager = [JUDownloadManager shredManager];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [manager downloadTaskWillBeTerminate:nil];
                            [mydatabase changedDownloadStatusOnAppLaunch];
                            
                            
                        });
                        
                    }else{
                        //注销失败
                        //错误码
                        NSString *backcode = [NSString stringWithFormat:@"%@", responobject[@"errno"]];
                        JURegisterLoginIBackInfo *info = [[JURegisterLoginIBackInfo alloc]init];
                        
                        [info showInformationError:backcode ToView:weakself.view];
                        
                        
                        
                    }
                    
                }
                
                
                
            }
            
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
                
            });
            
            JULog(@"请求失败失败: %@",error);
            
            JUDetectNetworkingTool *delectTool  = [[JUDetectNetworkingTool alloc]init];
            
            //因为检测网络是一异步的，需要时间，1秒应该够了，设定一秒钟后执行
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                
                if (delectTool.networkType == NotReachable) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        GMToast *toast = [[GMToast alloc]initWithView:weakself.view text:@"请检测你的网咯" duration:1.2];
                        
                        [toast show];
                        
                    });
                    
                }
                
            });
            
            
        }];
        
    }
    
}




/**
 *  登录按钮点击方法
 *
 *
 */
-(void)loginAction:(UIButton *)button{
    
    [self pushLoginViewContorller];
}

/**
 *  注册按钮方法
 */


-(void)registeredButtonAction:(UIButton *)button{
    [JUUmengStaticTool event:JUUmengStaticMine key:JUUmengParamMineNotLogin value:@"Register"];

    JURegisteredViewController *registeredVC = [[JURegisteredViewController alloc]init];
    [self.navigationController pushViewController:registeredVC animated:NO];
}

// 用户的登录状态改变的通知

-(void)loginStateDidChanged:(NSNotification *)notifi
{
    
    [self loginStateChanged:JuuserInfo.isLogin];
    
    if (JuuserInfo.isLogin) {
        
        [JUUmengStaticTool event:JUUmengStaticMine key:JUUmengParamMineLogin value:JUUmengStaticPV];
    }else{
        
        [JUUmengStaticTool event:JUUmengStaticMine key:JUUmengParamMineNotLogin value:JUUmengStaticPV];

    }
    
    
}

#pragma mark其它方法
//当登录状态发生改变时调用
-(void)loginStateChanged:(BOOL)isLogin{
 
    
    if (isLogin) {
        
        [self.logoutButton setTitle:@"退出登录" forState:(UIControlStateNormal)];
        
    }else{
        
        [self.logoutButton setTitle:@"去登录" forState:(UIControlStateNormal)];

    }
    
    

    
}




#pragma mark tableView的delegate
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    

    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = HCanvasColor(1);

    
    return view;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0001;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        
        return 0.0001;
    }
    
    
    return 15;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        if ([JuuserInfo.showstring isEqualToString:@"0"]) {
            
            return 1;
        }
        
        return 3;
        
    }else if (section == 1){
 
        return 1;
        
        
    }else{
        
        return 0;
    }
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JUCourseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:juCourseViewCell forIndexPath:indexPath];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        
        
        if (indexPath.row == 0) {
            
            cell.cellView.leftView.image = [UIImage imageNamed:@"my_class_icon"];
            cell.cellView.centerLabel.text = @"已购课程";
            cell.lineView.hidden = NO;
            

            
        }else if (indexPath.row == 1){
            
            cell.cellView.leftView.image = [UIImage imageNamed:@"my_order_icon"];
            cell.cellView.centerLabel.text = @"课程订单";
            cell.lineView.hidden = NO;

            
            
        }else if (indexPath.row == 2){
            
            cell.cellView.leftView.image = [UIImage imageNamed:@"youhuiquan@icon"];
            cell.cellView.centerLabel.text = @"优惠券";
            cell.lineView.hidden = YES;

        }
        
        
    }else if (indexPath.section == 1){
        
        
        if (indexPath.row == 0) {
            cell.cellView.leftView.image = [UIImage imageNamed:@"guanyu@icon"];
            cell.cellView.centerLabel.text = @"关于七月在线";
            cell.lineView.hidden = NO ;
        }
    }

    cell.cellView.rightView.image = [UIImage imageNamed:@"arrow_icon"];
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSString *Value = @"";
//    
//    if (indexPath.section == 0) {
//        
//        if (indexPath.row == 0) {
//            
//        Value = @"LearningRecord";
//            
//        }else if (indexPath.row == 1){
//            
//            Value = @"Course";
//            
//        }
//        
//    }else if (indexPath.section == 1){
//        if (indexPath.row == 0) {
//            Value = @"ShoppingCart";
//            
//        }else if (indexPath.row == 1){
//            Value = @"Order";
//            
//        }else if(indexPath.row == 2){
//            
//            Value = @"Coupon";
//            
//        }
//    }else if (indexPath.section == 2){
//
//        if (indexPath.row == 0) {
//            Value = @"About";
//
//        }
//        
//        
//    }
// 
//    [JUUmengStaticTool event:JUUmengStaticMine key:JUUmengParamMineNotLogin value:Value];
    
    
//    if (indexPath.section == 2) {
//        if (indexPath.row == 0) {
//            JUAboutCompanyController *aboutCompanyVC = [[JUAboutCompanyController alloc]init];
//            [self.navigationController pushViewController:aboutCompanyVC animated:NO];
//            return;
//        }
// 
//    }
//    
//    
//    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
//        if (indexPath.section == 0) {
//            if (indexPath.row == 1) {
//                //已购课程
//                JUpurchaseController *purchaseVc = [[JUpurchaseController alloc]init];
//                [self.navigationController pushViewController:purchaseVc animated:NO];
//                return;
//            }
//            
//        }
//    }
//
    
    
    NSLog(@"%f  %f", Kwidth, Kheight);
    
  
    NSLog(@"-------%@", self.navigationController.navigationBar.logframe);
    return;
    
    
    if (indexPath.row == 0 && indexPath.section == 1) {
        
        JUAboutCompanyController *aboutCompanyVC = [[JUAboutCompanyController alloc]init];
        [self.navigationController pushViewController:aboutCompanyVC animated:NO];
        
        return;
    }

    
    
    if (JuuserInfo.isLogin) {
        
        
        UIViewController *VC = nil;
        
        
        if (indexPath.section == 0) {

            if (indexPath.row == 0) {
                //已购课程
                JUpurchaseController *purchaseVc = [[JUpurchaseController alloc]init];
                VC = purchaseVc;
                
            }else if (indexPath.row == 1){
                
                
                
                JUShoppingCarOrderController *myOrderVC = [[JUShoppingCarOrderController alloc]init];
                
                VC = myOrderVC;
                
                
            }else if (indexPath.row == 2){
                
                JUMyCouponViewController *myCouponVC = [[JUMyCouponViewController alloc]init];
                VC = myCouponVC;
            }
            
            
            [self.navigationController pushViewController:VC animated:NO];
            
            
        }
 
        
        
    }else{

        [self pushLoginViewContorller];

    }
    

    
    


}

/**
 *  进入登录界面
 */
-(void)pushLoginViewContorller{
    
    JULoginViewController *loginVC = [[JULoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:NO];
    
    
}

#pragma mark系统方法
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
