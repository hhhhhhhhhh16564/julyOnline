//
//  JULoginViewController.m
//  algorithm
//
//  Created by pro on 16/7/6.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JULoginViewController.h"
#import "JUTextField.h"
#import "JULoginButton.h"
#import "JURegisteredViewController.h"
#import "JURegisterLoginIBackInfo.h"
//#import "UMSocial.h"
#import <UMSocialCore/UMSocialCore.h>

#import "JUThirdLoginTool.h"

//#import "JUUMengShare.h"


@interface JULoginViewController ()

@property(nonatomic, strong) UIView *contentView;

@property(nonatomic, strong) JUTextField *emailTF;
@property(nonatomic, strong) JUTextField *passwordTF;
@property(nonatomic, strong) UIButton *loginButton;

@property(nonatomic, strong) UIView *thirdLoginView;
@property(nonatomic, strong) YBNetManager *loginRequest;

@property(nonatomic, strong) JULoginButton *QQloginButton;
@property(nonatomic, strong) JULoginButton *WeiXinloginButton;
@property(nonatomic, strong) JULoginButton *WeiboLoginButton;

@property(nonatomic, strong) JUThirdLoginTool *loginTool;

@end

@implementation JULoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    [self p_setNavigationBar];
    
    [self p_setUpViews];
    
//   self.emailTF.tf.text = @"2313567416@qq.com";
//    self.passwordTF.tf.text = @"1234abcd";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registeredSucceedNotification:) name:JURegisteredSucceedNotification object:nil];
    
}


#pragma mark 视图布局
-(void)p_setNavigationBar{
    
    //左
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(goBack:) image:@"bule_back"highImage:nil];
    
//    leftBarButtonItem = [leftBarButtonItem itemWithtitlesize:(28*KMultiplier) color:[UIColor whiteColor] UIBarButonItem:leftBarButtonItem];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    //中间
    self.title = @"用户登录";
    
    
    //右
    
   UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册  " style:(UIBarButtonItemStyleDone) target:self action:@selector(registerAction:)];
    ;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    

    
    
    
}

-(void)p_setUpViews{
    
    //填一个大View，为了向上偏移
    UIView *contentView = [[UIView alloc]init];
    //   contentView.backgroundColor = Kcolor16rgb(@"#18b4ed", 1);
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    __weak typeof(self) weakSelf = self;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
        
    }];
    
    
    JUTextField *emailTF = [[JUTextField alloc]initWithImage:@"login_name_icon" placeholder:@"账号"];
    [self.contentView addSubview:emailTF];
    self.emailTF = emailTF;
    
    [emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView).with.offset(26);
        make.height.mas_equalTo(40);
        
        
    }];
   
    
    JUTextField *passwordTF = [[JUTextField alloc]initWithImage:@"login_password_icon" placeholder:@"密码"];
    passwordTF.tf.secureTextEntry = YES;
    [self.contentView addSubview:passwordTF];
    self.passwordTF = passwordTF;
    
 
    [passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.top.equalTo(emailTF.mas_bottom).with.offset(15);
        make.height.mas_equalTo(40);

        
    }];
    
    
    //登录按钮
    UIButton *loginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:(UIControlEventTouchUpInside)];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 5;
    loginButton.layer.borderColor = Hmblue(1).CGColor;
    loginButton.layer.borderWidth = 1;
    loginButton.titleLabel.textColor = Hmblue(1);
    [loginButton setTitle:@"登录" forState:(UIControlStateNormal)];
    loginButton.titleLabel.font = UIptfont(16);
    
    //不同状态下的背景颜色
    UIColor *normolColor = [UIColor whiteColor];
    [loginButton setBackgroundImage:[UIImage imageWithColor:normolColor] forState:(UIControlStateNormal)];
    
    UIColor *hightedColor = Hmblue(1);
    
    [loginButton setBackgroundImage:[UIImage imageWithColor:hightedColor] forState:(UIControlStateHighlighted)];
    //不同状态下的字体颜色
    
    [loginButton setTitleColor:hightedColor forState:(UIControlStateNormal)];
    [loginButton setTitleColor:normolColor forState:(UIControlStateHighlighted)];
    
    
    
    [contentView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(passwordTF.mas_bottom).offset(40);
        make.left.equalTo(contentView).with.offset(30);
        make.right.equalTo(contentView).with.offset(-30);
        make.height.mas_equalTo(40);
        
    }];
    
    
    
    
    //第三方账号快速登录
    UILabel *thirdloginLabel = [[UILabel alloc]init];
    thirdloginLabel.font = UIptfont(12);
    thirdloginLabel.text = @"    第三方账号快速登录    ";
    thirdloginLabel.textColor = Hcgray(1);
    thirdloginLabel.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:thirdloginLabel];
    
    [thirdloginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(loginButton.mas_bottom).with.offset(40);
        
    }];
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HSpecialSeperatorline(1);
    [self.contentView addSubview:lineView];
    [self.contentView sendSubviewToBack:lineView];
      
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(contentView).offset(30);
        make.right.equalTo(contentView).offset(-30);
        make.centerY.equalTo(thirdloginLabel);
        make.height.mas_equalTo(0.5);
        
        
    }];
    


    
    
    UIView *thirdLoginView = [[UIView alloc]init];

    [self.contentView addSubview:thirdLoginView];
    self.thirdLoginView = thirdLoginView;
//    thirdLoginView.backgroundColor = [UIColor redColor];
    [thirdLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(thirdloginLabel.mas_bottom).with.offset(30);
        make.height.mas_equalTo(50);
        
        
        
    }];
    
    
    //第三方登录view
   [self p_setupThirdPartLogin];
    
    
    //忘记密码
    
    
    
    //登录按钮
    UIButton *forgetPasswordButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [forgetPasswordButton addTarget:self action:@selector(forgetPasswordAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [forgetPasswordButton setTitle:@"忘记密码" forState:(UIControlStateNormal)];
    forgetPasswordButton.titleLabel.font = UIptfont(14);
    [forgetPasswordButton setTitleColor:Hcgray(1) forState:(UIControlStateNormal)];
    
    [contentView addSubview:forgetPasswordButton];
    [forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(contentView.mas_bottom).offset(-20);
        make.left.equalTo(contentView).with.offset(30);
        make.right.equalTo(contentView).with.offset(-30);
        make.height.mas_equalTo(30);
        
    }];
    forgetPasswordButton.hidden = YES;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)p_setupThirdPartLogin{
    
    
    self.loginTool = [[JUThirdLoginTool alloc]init];

        for (int i = 0; i < 3; i++) {
            
            JULoginButton *loginButton = [JULoginButton buttonWithType:(UIButtonTypeCustom)];
   
            [self.thirdLoginView addSubview:loginButton];
            
            [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
              
        
                make.height.equalTo(self.thirdLoginView);
                make.width.equalTo(self.thirdLoginView.mas_height);
                make.centerY.equalTo(self.thirdLoginView);
                
                make.centerX.equalTo(self.thirdLoginView.mas_centerX).with.offset(80*(i-1));
                
            }];
            
            
            
            
            
            [loginButton addTarget:self action:@selector(thirdPartLogin:) forControlEvents:(UIControlEventTouchUpInside)];
            
            UIImage *image = nil;
            
            if (i == 0) {
                image = [UIImage imageNamed:@"login_weixing_sign"];
                
                loginButton.loginstyle = winxinlogin;
                self.WeiXinloginButton = loginButton;
                

                
            }else if (i == 1){
                
                image = [UIImage imageNamed:@"login_weibo_sign"];
                
                loginButton.loginstyle = weibologin;
                
                self.WeiboLoginButton = loginButton;

                
            }else if (i == 2){
                
                
                image = [UIImage imageNamed:@"login_qq_sign"];
                
                loginButton.loginstyle = QQlogin;
                
                self.QQloginButton = loginButton;

            }
            
            [loginButton setBackgroundImage:image forState:(UIControlStateNormal)];
            
        }

}

//第三方登录

-(void)thirdPartLogin:(JULoginButton *)sender{
    
    if (networkingType == NotReachable) {
        
        
        GMToast *toast = [[GMToast alloc]initWithView:self.view text:@"请检查你的网络" duration:1.5];
        [toast show];
        
        return;
    }
    
    
    
    // qq 微信  微博
    
    if (sender.loginstyle == winxinlogin) {
        
        [self weixinLogin];
        
    }else if (sender.loginstyle == weibologin){
        
        [self weiboLogin];
        
    }else if (sender.loginstyle == QQlogin){
        [self qqLogin];
        
        
    }
    
    
}

#pragma mark 响应事件
//登录

-(void)loginAction:(UIButton *)sender{
    [JUUmengStaticTool event:JUUmengStaticMine key:JUUmengParamMineNotLogin value:@"Login"];

    if (networkingType == NotReachable) {
        
        [self showWithView:nil text:@"请检查你的网络" duration:1.5];
        return;
    }

    
    
    
    //返回值是YES，之前返回
    if ([self checkLoginInformation]) {
        
        return;
    }
    
    
    //判断是否应请求过了，取消之前的请求,防止重复点击
    if (self.loginRequest) {
        [self.loginRequest canceAllrequest];
        self.loginRequest = nil;
        
    }
    
    [MBProgressHUD showMessage:@"正在登录中" toView:self.view];
    //    hud.transform = CGAffineTransformRotate(hud.transform, M_PI_2);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"em"] = self.emailTF.tf.text;
    dic[@"pd"] = self.passwordTF.tf.text;
    
    
    NSMutableDictionary *headdic = JuuserInfo.headDit;
    
    self.loginRequest = requestManager;
    
    
    
    __weak typeof(self) weakself = self;
    
    
    JULog(@"header:   %@", headdic);
    
    [self.loginRequest POST:V30LoginURL parameters:dic headdict:headdic progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, id responobject) {
        if (responobject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
                
            });
//            JULog(@"请求成功: %@",responobject);
            
            if (responobject[@"msg"]) {
                //msg字段是ok时，注册成功
                if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
                    
  
                    
                    [JuuserInfo loadFromUserDefaults];
                    //登录成功时，保存用户信息
      
                    JuuserInfo.email = weakself.emailTF.tf.text;
                    JuuserInfo.password = weakself.passwordTF.tf.text;
                    NSDictionary *dict = responobject[@"data"];
                    //加入两个字段
                    if (dict) {
                        JuuserInfo.uid = dict[@"uid"];
                        JuuserInfo.accessToken = dict[@"access-token"];
                    }
                    
                    JuuserInfo.loginDate = nil;
                    
                    //islogin要写在最后，否则会出错，因为设置状态会走代理方法，但此时uid为空
                    JuuserInfo.isLogin = YES;
                    [JuuserInfo saveUserInfo];
                                      JULog(@"登录成功");
                    //登录成功后返回
                    [weakself.navigationController popViewControllerAnimated:NO];
                    return ;
                    
                    
                }
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //错误码
                NSString *backcode = [NSString stringWithFormat:@"%@", responobject[@"errno"]];
                JURegisterLoginIBackInfo *info = [[JURegisterLoginIBackInfo alloc]init];
                
                [info showInformationError:backcode ToView:weakself.view];
                
                
            });
            
            
            
            
            
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
                    
                    GMToast *toast = [[GMToast alloc]initWithView:weakself.view text:@"请检测你的网咯" duration:1.5];
                    
                    [toast show];
                    
                });
                
            }
            
        });
        
        
    }];
    
 
    
    
    
    
}

//忘记密码
-(void)forgetPasswordAction:(UIButton *)sender{
    
    
}

//微信登录
-(void)weixinLogin{
    
    __weak typeof(self) weakSelf = self;
    
    [self.loginTool weixinLogin:^{
        
        //登录成功后返回
        [weakSelf.navigationController popViewControllerAnimated:NO];
        
    } failure:^{
        
        
    }];

}

//微博登录
-(void)weiboLogin{
    
    
    __weak typeof(self) weakSelf = self;
    

    [self.loginTool weiboLogin:^{
        //登录成功后返回
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } failure:^{
        
        
    }];
    
    

 
}
//QQ登录
-(void)qqLogin{

    __weak typeof(self) weakSelf = self;
    
    [self.loginTool qqLogin:^{
        //登录成功后返回
        [weakSelf.navigationController popViewControllerAnimated:NO];

    } failure:^{
        
        
    }];
    
    return;
    
}






//第三方登录后获取 第三方信息后的登录方法



//注册按钮
-(void)registerAction:(UIBarButtonItem *)sender{
    
    
    JURegisteredViewController *registeredVC = [[JURegisteredViewController alloc]init];
    [self.navigationController pushViewController:registeredVC animated:NO];
    
}

//返回按钮
-(void)goBack:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

#pragma mark其它方法
//如果返回值为NO，发送请求，YES不发送请求
-(BOOL)checkLoginInformation{
    
    
    if (!(self.emailTF.isHaveWord &&  self.passwordTF.isHaveWord)) {
        GMToast *toast = [[GMToast alloc]initWithView:self.view text:@"信息输入不完整" duration:1.5];
        [toast show];
        
        
        return YES;
    }
    

    
    
    
   if (![NSString validatePassword:self.passwordTF.tf.text]){
        
        GMToast *toast = [[GMToast alloc]initWithView:self.view text:@"密码为6-20位" duration:1.5];
        [toast show];
        return YES;
        
    }
    return NO;
    
}

-(void)registeredSucceedNotification:(NSNotification *)notifi{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       self.emailTF.tf.text = JuuserInfo.email;
                       self.passwordTF.tf.text = JuuserInfo.password;
                    
                   });
    
    
}


-(void)hiddenLoginButton{
    
    
    
    //判断系统是否安装了QQ 微信 第三方登录
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
       
        self.WeiXinloginButton.hidden = NO;
        
    }else{
      
        self.WeiXinloginButton.hidden = YES;
    }
    
    
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        
        self.QQloginButton.hidden = NO;
        
    }else{
        
        self.QQloginButton.hidden = YES;
        
    }
    
    
    // 默认状况是微信、微博、QQ
    
    //要根据是否安装了QQ和微信对第三方登录重新布局
    
    
    //1. qq和微信都没有安装，默认布局, 不用更改布局
    
    //2. 安装了QQ，没有安装微信 ，微博布局更改,
    
  
    if (self.QQloginButton.hidden == NO && self.WeiXinloginButton.hidden == YES) {
        
        [self.WeiboLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            
            make.height.equalTo(self.thirdLoginView);
            make.width.equalTo(self.thirdLoginView.mas_height);
            make.centerY.equalTo(self.thirdLoginView);
            
            make.centerX.equalTo(self.thirdLoginView.mas_centerX).with.offset(-80);
            
        }];
        
    }
    
    
    //3. 安装了微信，没有安装QQ ， 微博布局更改
    if (self.QQloginButton.hidden == YES && self.WeiXinloginButton.hidden == NO) {
       
        
        [self.WeiboLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            
            make.height.equalTo(self.thirdLoginView);
            make.width.equalTo(self.thirdLoginView.mas_height);
            make.centerY.equalTo(self.thirdLoginView);
            
            make.centerX.equalTo(self.thirdLoginView.mas_centerX).with.offset(80);
            
        }];
        

        
    }
    
    
    //4. qq和微信都安装，默认布局
    
    
    
    
    
}
#pragma mark 系统方法

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //取消导航栏下的黑色线条
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = Hmblue(1);
    dict[NSFontAttributeName] = UIptfont(34*KMultiplier);
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    
    // 设置普通状态
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = Hmblue(1);
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:28*KMultiplier];
    
   [self.navigationItem.rightBarButtonItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];


    [self hiddenLoginButton];
    

    
    //记住登录的密码
    self.emailTF.tf.text = JuuserInfo.email;
    self.passwordTF.tf.text = JuuserInfo.password;
    
//    self.emailTF.tf.text = @"2313567416@qq.com";
//    self.passwordTF.tf.text = @"11111111";
//
    
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //视图将要消失时，取消状态栏下黑色线条的隐藏
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.view endEditing:YES];

    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
