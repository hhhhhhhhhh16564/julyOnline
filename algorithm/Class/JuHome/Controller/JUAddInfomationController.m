//
//  JUAddInfomationController.m
//  algorithm
//
//  Created by yanbo on 17/10/19.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUAddInfomationController.h"
#import "JUsignUpInfomationView.h"
#import "JUPayCategoryView.h"
#import "JUDiscountRulesController.h"
#import "JUPayManager.h"
@interface JUAddInfomationController ()
@property(nonatomic, strong) JUsignUpInfomationView *signUpInfomationView;

@property(nonatomic, strong) UIView *headView;

@property(nonatomic, strong) UIView *conentView;

@property(nonatomic, strong)  UserInformationView  *nameView;
@property(nonatomic, strong)  UserInformationView  *phoneView;
@property(nonatomic, strong)  UserInformationView  *qqView;

@property(nonatomic, strong) JUButton *selectedButton;

@property(nonatomic, strong) UIButton *enlistButton;

@property(nonatomic, strong) DiscountRulesCellView *payPriceView;
@property(nonatomic, strong) NSString *type;

@end

@implementation JUAddInfomationController
//-(void)loadView{
//    
//    UIView *scrollView = [[UIScrollView alloc]init];
//    scrollView.frame = CGRectMake(0, 0, Kwidth, Kheight);
//    self.view = scrollView;
//    
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payOrderSucceedAction:) name:JUPayOrderSucceedNotification object:nil];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"填写信息";
//    self.view.backgroundColor = HCanvasColor(1);

    [self setupViews];
    
    [self getInfo];
    
}

-(void)setupViews{
    
    
    self.navigationItem.title = @"报名信息";
//    self.navigationItem.leftBarButtonItem =   [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"btn_black_back" highImage:nil];
    

    UIView *conentView = [[UIView alloc]init];
    conentView.backgroundColor =  HCanvasColor(1);
    conentView.frame = CGRectMake(0, 64, Kwidth, Kheight-64);
    [self.view addSubview:conentView];
    self.conentView = conentView;
    
    
    [self setHeadView];
    [self setFootView];
    [self gotoPayView];
    
}


-(void)setHeadView{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, 10, Kwidth, 44*3);
    [self.conentView addSubview:headView];
    
    UserInformationView *nameView = [[UserInformationView alloc]initWithFrame:CGRectZero name:@"姓名" placeholder:@"请输入您的真实姓名" valueText:@""];
    [headView addSubview:nameView];
    self.nameView = nameView;
    
    UserInformationView *phoneView = [[UserInformationView alloc]initWithFrame:CGRectZero name:@"手机号码" placeholder:@"请输入您的手机号码" valueText:@""];
    [headView addSubview:phoneView];
    self.phoneView = phoneView;
    
    UserInformationView *qqView = [[UserInformationView alloc]initWithFrame:CGRectZero name:@"QQ号码" placeholder:@"请输入您的QQ号码" valueText:@""];
    [headView addSubview:qqView];
    self.qqView = qqView;
    
    self.headView = headView;

    
    
    CGFloat cellHeitht = 44;
    CGFloat cellWidth = Kwidth - 12;
    self.nameView.frame = CGRectMake(12, 0, cellWidth, cellHeitht);
    self.phoneView.frame = CGRectMake(12, cellHeitht, cellWidth, cellHeitht);
    self.qqView.frame = CGRectMake(12, cellHeitht*2, cellWidth, cellHeitht);
    
}

-(void)setFootView{
    
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = HCanvasColor(1);
    [self.conentView addSubview:footView];
    
    
    //支付金额View
    DiscountRulesCellView *payPriceView = [[DiscountRulesCellView alloc]init];
    payPriceView.frame = CGRectMake(0, 0, Kwidth, 44);
    payPriceView.categoryLabel.text= @"支付金额";
    payPriceView.priceLabel.textColor = [UIColor redColor];
    payPriceView.priceLabel.font = UIptfont(16);
    payPriceView.priceLabel.text = [NSString stringWithFormat:@"¥%@", self.price];
    [footView addSubview:payPriceView];
    self.payPriceView = payPriceView;
  
    
    
    
    //支付宝
    
    // type 1代表微信   2代表支付宝
    JUPayCategoryView *payTreasureView = [[JUPayCategoryView alloc]initWithImage:@"pay_logo_zhifubao" text:@"支付宝支付"];
    
    payTreasureView.frame = CGRectMake(0, payPriceView.bottom_extension+10, Kwidth, 44);
    
    __weak typeof(self) weakSelf = self;
    payTreasureView.myblock = ^(JUButton *button){
        
        weakSelf.selectedButton.selected = NO;
        
        weakSelf.selectedButton = button;
        
        weakSelf.type = @"2";
        
    };
    
    [footView addSubview:payTreasureView];
    
    payTreasureView.checkButton.selected = YES;
    weakSelf.selectedButton = payTreasureView.checkButton;
    
    self.type = @"2";
    
    // 微信
    JUPayCategoryView *weChatPayView = [[JUPayCategoryView alloc]initWithImage:@"pay_logo_weixin" text:@"微信支付"];
    weChatPayView.frame = CGRectMake(0, payTreasureView.bottom_extension, Kwidth, 44);
    
    weChatPayView.myblock = ^(JUButton *button){
        weakSelf.selectedButton.selected = NO;
        weakSelf.selectedButton = button;
        weakSelf.type = @"1";
    };
    
    [footView addSubview:weChatPayView];
    
    
    // 警示信息
    //提示警告信息
    UIView *cuecardView = [[UIView alloc]init];
    cuecardView.frame = CGRectMake(0, weChatPayView.bottom_extension, Kwidth, 55);
    [footView addSubview:cuecardView];
    
    UIImageView *signNoticeView = [[UIImageView alloc]init];
    signNoticeView.frame = CGRectMake(12, 10, 12, 12);
    signNoticeView.image = [UIImage imageNamed:@"apply_sign_notice"];
    [cuecardView addSubview:signNoticeView];
    UILabel *signNoticeLabel = [[UILabel alloc]init];
    signNoticeLabel.frame = CGRectMake(signNoticeView.right_extension+8, signNoticeView.y_extension-1.5, cuecardView.width_extension-44, 45);
    signNoticeLabel.text = @"请在24小时内完成支付, 否则届时系统将关闭该订单\n\n\n";
    //label的字体从顶部显示
    signNoticeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    signNoticeLabel.textColor = HCOrange(1);
    signNoticeLabel.font = UIptfont(12);
    signNoticeLabel.numberOfLines = 0;
    [cuecardView addSubview:signNoticeLabel];

    footView.frame = CGRectMake(0, self.headView.bottom_extension+10, Kwidth, cuecardView.bottom_extension);

    
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        
        //        payTreasureView = nil;
        //        weChatPayView = nil;
        //        cuecardView = nil;
        
        [payTreasureView removeFromSuperview];
        
        [weChatPayView removeFromSuperview];
        
        [cuecardView removeFromSuperview];
        
        
    }
    
    
}


-(void)gotoPayView{
    
    NSString *buttonTitle = @"";
    
    if ([self.addPartType isEqualToString:@"1"]) {
        
        buttonTitle = [NSString stringWithFormat:@"%@元参团",self.price];
    }else if([self.addPartType isEqualToString:@"2"]){
        
        buttonTitle = @"补交尾款";
    }
    
    
    UIButton *enlistButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    enlistButton.frame = CGRectMake(0, self.conentView.height_extension-44, Kwidth, 44);
    [enlistButton.titleLabel setFont:UIptfont(17)];
    [enlistButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [enlistButton setTitle:buttonTitle forState:(UIControlStateNormal)];
    
    UIColor *redColor = Kcolor16rgb(@"#ff4000", 1);
    [enlistButton setBackgroundImage:[UIImage imageWithColor:redColor] forState:(UIControlStateNormal)];
    

    [enlistButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [enlistButton addTarget:self action:@selector(confirmPayment:) forControlEvents:(UIControlEventTouchUpInside)];
    self.enlistButton = enlistButton;
    [self.conentView addSubview:enlistButton];
    [self.conentView addSubview:enlistButton];
    


    
}

-(void)confirmPayment:(UIButton *)button{
    
    if (![self checkInformation]) {
        return;
    }
    
    
    
    if ([self.addPartType isEqualToString:@"1"]) {

        [self addPart];
        
    }else if([self.addPartType isEqualToString:@"2"]){
        
        [self reaminningMoney];

    }
    

    
}

//参团
-(void)addPart{
    
    
    
    

    YBNetManager *manager = [[YBNetManager alloc]init];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"course_id"] = self.course_ID;
    dict[@"pay_type"] = self.type;
    
    
    dict[@"real_name"] = self.nameView.valueText;
    dict[@"cellphone"] = self.phoneView.valueText;
    dict[@"qq"] = self.qqView.valueText;
    
 
    
    __weak typeof(self) weakSelf = self;
    
    self.enlistButton.userInteractionEnabled = NO;
        
    [manager POST:V31Grouppay parameters:dict headdict:JuuserInfo.headDit constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } progress:^(NSProgress * _Nonnull Progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        
        self.enlistButton.userInteractionEnabled = YES;


        //        JULog(@"%@", responobject);
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) {
            return ;
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        
        NSString *oid = [responobject[@"data"][@"oid"] description];
        
        
        dict[@"oid"] = oid;
        dict[@"type"] = self.type;
        
        if ([oid length]) {
            [JUPayManager payOrderActionWithDict:dict];
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.enlistButton.userInteractionEnabled = YES;

        JULog(@"%@", error);
        
    }];
    
    
    
}

//补交尾款
-(void)reaminningMoney{
    
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    
    dict[@"oid"] = self.oid2;
    dict[@"type"] = self.type;
    
    if ([self.oid2 length]) {
        [JUPayManager payOrderActionWithDict:dict];
    }
    
    
    
}



-(void)getInfo{
    
    YBNetManager *manager = [[YBNetManager alloc]init];
    
    [manager GET:V31personinfo parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) {
            return ;
        }
        
        
         
        
        NSDictionary *dict = responobject[@"data"];
        
        
        self.userInfoModel = [JUUserInfoModel mj_objectWithKeyValues:dict];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
    
}




-(void)back{
    
    
    __weak typeof(self) weakSelf = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:@"确定要放弃此次编辑" preferredStyle:(UIAlertControllerStyleAlert)];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
            
            
        }];
        
        UIAlertAction *desAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf.navigationController popViewControllerAnimated:NO];
            
            
            
        }];
        
        
        [alterVC addAction:cancelAction];
        [alterVC addAction:desAction];
        
        [self presentViewController:alterVC animated:NO completion:^{
            
            
        }];
        
        
    }else{
        
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"确定要放弃此次编辑" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alterView show];
        
        
    }
    
    
    
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        
        [self.navigationController popViewControllerAnimated:NO];
        
        
    }else{
        
        
    }
    
    
    
}

-(void)setUserInfoModel:(JUUserInfoModel *)userInfoModel{
    
    _userInfoModel = userInfoModel;
    
    if ([userInfoModel.cellphone isEqualToString:@"0"])return;
    
    self.qqView.valueText = userInfoModel.qq;
    self.phoneView.valueText = userInfoModel.cellphone;
    self.nameView.valueText = userInfoModel.real_name;

    
}



-(BOOL)checkInformation{
    
    NSString *showInformation = @"";
    
    if (!self.nameView.valueText.length) {
        
        showInformation = @"请输入姓名";
        
        [self showToolTipbox:showInformation];
        
        return NO;
        
    }
    
    if (![NSString valiMobile:self.phoneView.valueText]) {
        
        showInformation = @"手机号码格式有误";
        
        [self showToolTipbox:showInformation];
        
        return NO;
        
    }
    
    
    if (![NSString valiQQ:self.qqView.valueText]) {
        
        showInformation = @"QQ号码格式有误";
        [self showToolTipbox:showInformation];
        
        return NO;
        
    }
    
    return YES;
    
}



-(void)showToolTipbox:(NSString *)showString{
    
    if (showString.length) {
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        GMToast *toasts = [[GMToast alloc]initWithView:window text:showString duration:1.5];
        [toasts show];
    }
    
}

-(void)payOrderSucceedAction:(NSNotification *)notifi{
    
    [self.navigationController popViewControllerAnimated:NO];
    
}


- (void)dealloc
{
    JUlogFunction
}
@end
