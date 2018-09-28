//
//  JURegisteredViewController.m
//  algorithm
//
//  Created by pro on 16/7/7.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JURegisteredViewController.h"
#import "JUTextField.h"
#import "JURegisterLoginIBackInfo.h"
#import "JURegisteredAgreementViewContoller.h"


@interface JURegisteredViewController ()<JUTextFieldDelegat>

@property(nonatomic, strong) JUTextField *emailTF;
@property(nonatomic, strong) JUTextField *nicknameTF;
@property(nonatomic, strong) JUTextField *passwordTF;
@property(nonatomic, strong) JUTextField *confirmPasswordTF;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIButton *agreeButton;

@property(nonatomic, strong) UIView *protocolButton;


//注册请求的类
@property(nonatomic, strong) YBNetManager *registerRequest;


@end

@implementation JURegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];

    
    [self p_setNavigationBar];
    
    [self setUpViews];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    

    
}

#pragma mark 视图布局
-(void)p_setNavigationBar{
    
    //左
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(goBack:) image:@"bule_back"highImage:nil];
    
    //    leftBarButtonItem = [leftBarButtonItem itemWithtitlesize:(28*KMultiplier) color:[UIColor whiteColor] UIBarButonItem:leftBarButtonItem];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    //中间
    self.title = @"新用户注册";
    
    
}
-(void)setUpViews{
    
    //填一个大View，为了向上偏移
    UIView *contentView = [[UIView alloc]init];
      // contentView.backgroundColor = Kcolor16rgb(@"#18b4ed", 1);
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    __weak typeof(self) weakSelf = self;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];

    
    
    JUTextField *emailTF = [[JUTextField alloc]initWithImage:@"login_mail_icon" placeholder:@"请输入邮箱"];
    [self.contentView addSubview:emailTF];
    emailTF.delegate = self;
    self.emailTF = emailTF;
    
    [emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView).with.offset(26);
        make.height.mas_equalTo(40);
        
        
    }];
    
    JUTextField *nicknameTF = [[JUTextField alloc]initWithImage:@"login_name_icon" placeholder:@"请填写昵称"];
    [self.contentView addSubview:nicknameTF];
    nicknameTF.delegate = self;
    self.nicknameTF = nicknameTF;
    
    
    [nicknameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.top.equalTo(emailTF.mas_bottom).with.offset(15);
        make.height.mas_equalTo(40);
        
        
    }];

    
    

    JUTextField *passwordTF = [[JUTextField alloc]initWithImage:@"login_password_icon" placeholder:@"请填写6-16为的密码"];
    passwordTF.tf.secureTextEntry = YES;
    [self.contentView addSubview:passwordTF];
    passwordTF.delegate = self;
    self.passwordTF = passwordTF;
    
    
    [passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.top.equalTo(nicknameTF.mas_bottom).with.offset(15);
        make.height.mas_equalTo(40);
        
        
    }];
    
    JUTextField *confirmPasswordTF = [[JUTextField alloc]initWithImage:@"login_password_icon" placeholder:@"请再次确认密码"];
    confirmPasswordTF.tf.secureTextEntry = YES;
    [self.contentView addSubview:confirmPasswordTF];
    confirmPasswordTF.delegate = self;
    self.confirmPasswordTF = confirmPasswordTF;
    
    
    [confirmPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.top.equalTo(passwordTF.mas_bottom).with.offset(15);
        make.height.mas_equalTo(40);
        
        
    }];
    
// 协议的对号图标
    //
    UIButton *agreeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [agreeButton addTarget:self action:@selector(agreeAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [agreeButton setBackgroundImage:[UIImage imageNamed:@"login_check_btn"] forState:(UIControlStateNormal)];
       [agreeButton setBackgroundImage:[UIImage imageNamed:@"login_check_btn_pre"] forState:(UIControlStateSelected)];
    agreeButton.selected = YES;
    [contentView addSubview:agreeButton];
    self.agreeButton = agreeButton;
    [agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmPasswordTF.mas_bottom).offset(20);
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        
    }];
    

    //第三方账号快速登录
    UILabel *agreeLabel = [[UILabel alloc]init];
    agreeLabel.font = UIptfont(12);
    agreeLabel.text = @"我同意";
    agreeLabel.textColor = HSpecialSeperatorline(1);
    [self.contentView addSubview:agreeLabel];
    
    [agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agreeButton.mas_right).offset(10);
        make.centerY.equalTo(agreeButton);
    }];

    
    UIButton *protocolButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [protocolButton addTarget:self action:@selector(switchWebViewPtotocol:) forControlEvents:(UIControlEventTouchUpInside)];
   
    [protocolButton setTitle:@"《七月在线用户使用协议》" forState:(UIControlStateNormal)];
    [protocolButton setTitleColor:Hmblue(1) forState:(UIControlStateNormal)];
    protocolButton.titleLabel.font = UIptfont(12);
    [contentView addSubview:protocolButton];
    self.protocolButton = protocolButton;
    [protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(agreeButton);
        make.left.equalTo(agreeLabel.mas_right).offset(2);
        
        
    }];
    
    //登录
    //注册按钮
    UIButton *retisteredButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [retisteredButton addTarget:self action:@selector(retisteredAction:) forControlEvents:(UIControlEventTouchUpInside)];
    retisteredButton.layer.masksToBounds = YES;
    retisteredButton.layer.cornerRadius = 5;
    retisteredButton.layer.borderColor = Hmblue(1).CGColor;
    retisteredButton.layer.borderWidth = 1;
    retisteredButton.titleLabel.textColor = Hmblue(1);
    [retisteredButton setTitle:@"注册" forState:(UIControlStateNormal)];
    retisteredButton.titleLabel.font = UIptfont(16);
    
    //不同状态下的背景颜色
    UIColor *normolColor = [UIColor whiteColor];
    [retisteredButton setBackgroundImage:[UIImage imageWithColor:normolColor] forState:(UIControlStateNormal)];
    
    UIColor *hightedColor = Hmblue(1);
    
    [retisteredButton setBackgroundImage:[UIImage imageWithColor:hightedColor] forState:(UIControlStateHighlighted)];
    //不同状态下的字体颜色
    
    [retisteredButton setTitleColor:hightedColor forState:(UIControlStateNormal)];
    [retisteredButton setTitleColor:normolColor forState:(UIControlStateHighlighted)];
    
    
    
    [contentView addSubview:retisteredButton];
    [retisteredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(agreeButton.mas_bottom).offset(40);
        make.left.equalTo(contentView).with.offset(30);
        make.right.equalTo(contentView).with.offset(-30);
        make.height.mas_equalTo(40);
        
    }];


    
}



#pragma mark 响应事件方法
//同意图标
-(void)agreeAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
}

//返回按钮
-(void)goBack:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

//跳转到协议页面retisteredAction:
-(void)switchWebViewPtotocol:(UIButton *)sender{
    
    JURegisteredAgreementViewContoller *registereAGVC = [[JURegisteredAgreementViewContoller alloc]init];
    [self.navigationController pushViewController:registereAGVC animated:NO];
    
    
    
}
//注册按钮
-(void)retisteredAction:(UIButton *)sender{
    
    
    if (networkingType == NotReachable) {
        
        [self showWithView:nil text:@"请检查你的网络" duration:1.5];
        return;
    }

    
    if (!self.agreeButton.selected) {
        return;
    }

    
    //返回值是YES，之前返回
    if ([self checkRegistrationInformation]) {
        
        return;
    }
    
    
    
    //判断是否应注册过了，取消之前的请求
    if (self.registerRequest) {
        [self.registerRequest canceAllrequest];
        self.registerRequest = nil;
        
    }
    
    [MBProgressHUD showMessage:@"正在注册中" toView:self.view];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"un"] = self.nicknameTF.tf.text;
    dic[@"em"] = self.emailTF.tf.text;
    dic[@"pd"] = self.passwordTF.tf.text;
    
    
    NSMutableDictionary *headdic = JuuserInfo.headDit;
    
    self.registerRequest = requestManager;
    
    
    
    __weak typeof(self) weakself = self;
    [self.registerRequest POST:registerURL parameters:dic headdict:headdic progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, id responobject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
            
        });
        if (responobject) {
            
//            JULog(@"请求成功: %@",responobject);
            
            if (responobject[@"errno"]) {
                //msg字段是ok时，注册成功
                if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
                    
                    
                    
                    JULog(@"注册成功");
                    
                    
                    JuuserInfo.email = weakself.emailTF.tf.text;
                    JuuserInfo.password = weakself.passwordTF.tf.text;
                    
//                    //发送通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:JURegisteredSucceedNotification object:nil];
                    
                    
                    //注册成功后返回
                    [weakself.navigationController popViewControllerAnimated:NO];
                    return ;
                    
                }
                
            }
            
            //错误码
            NSString *backcode = [NSString stringWithFormat:@"%@", responobject[@"errno"]];
            JURegisterLoginIBackInfo *info = [[JURegisterLoginIBackInfo alloc]init];
            
            [info showInformationError:backcode ToView:weakself.view];
            
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
            
        });

        
        
    }];
    
    
    
}
/**
 *  将要开始编辑
 */

-(void)textfieldShouldEditing:(UITextField *)textfield{
   

    
    if (Kheight > 568) {
        return;
    }
    
    BOOL ischangeFrame  = [self.passwordTF isinput] || [self.confirmPasswordTF isinput];
    
    if (!ischangeFrame) {
        
        JULog(@"开始编辑************");

        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(-140);
            
        }];
        
        [self.view layoutIfNeeded];
        
    }];
    
    
    

    
    
}


//键盘将要消失通知
-(void)KeyboardWillHideNotification:(NSNotification *)notifi{
    
    
    
    if (Kheight > 568) {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(0);
            
        }];
        
        [self.view layoutIfNeeded];
        
    }];
    
     
}

#pragma mark 其它的方法
//如果返回值为NO，发送请求，YES不发送请求
-(BOOL)checkRegistrationInformation{
    
    if (!(self.emailTF.isHaveWord && self.nicknameTF.isHaveWord && self.passwordTF.isHaveWord && self.confirmPasswordTF.isHaveWord)) {
        GMToast *toast = [[GMToast alloc]initWithView:self.view text:@"信息输入不完整" duration:1.5];
        [toast show];
        
        
        return YES;
    }
   
    
    
    
    
    if (![NSString validateEmail:self.emailTF.tf.text]) {
        
        GMToast *toast = [[GMToast alloc]initWithView:self.view text:@"请输入正确的邮箱" duration:1.5];
        [toast show];
        return YES;
        
    }else if (![NSString validatePassword:self.passwordTF.tf.text]){
        
        GMToast *toast = [[GMToast alloc]initWithView:self.view text:@"密码为6-20位" duration:1.5];
        [toast show];
        return YES;
        
    }else if (![self.passwordTF.tf.text isEqualToString:self.confirmPasswordTF.tf.text]){
        
        GMToast *toast = [[GMToast alloc]initWithView:self.view text:@"两次输入密码不一致" duration:1.5];
        [toast show];
        return YES;
        
        
    }
    
    return NO;
    
}







#pragma mark 系统方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //取消导航栏下的黑色线条
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.navigationController.navigationBar.translucent = NO;
    
}




-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //视图将要消失时，取消状态栏下黑色线条的隐藏
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = YES;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = Hmblue(1);
    dict[NSFontAttributeName] = UIptfont(34*KMultiplier);
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    


}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
