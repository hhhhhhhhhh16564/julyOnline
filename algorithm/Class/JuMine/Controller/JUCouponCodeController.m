//
//  JUCouponCodeController.m
//  algorithm
//
//  Created by 周磊 on 17/1/24.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUCouponCodeController.h"

@interface JUCouponCodeController ()
@property(nonatomic, strong) UIView *contentView;

@property(nonatomic, strong) UILabel *invalidCouponLabel;

@property(nonatomic, strong) UITextField *textfield;

@property(nonatomic, strong) UIButton *sureButton;
@end

@implementation JUCouponCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
}


-(void)setupViews{
    
    
    self.navigationItem.title = @"优惠码";
    
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(0, 64, Kwidth, Kheight-64);
    contentView.backgroundColor = [UIColor redColor];
    contentView.backgroundColor = HCanvasColor(1);
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    
    UILabel *invalidCouponLabel = [[UILabel alloc]init];
    invalidCouponLabel.backgroundColor = HClightYellow(1);
    invalidCouponLabel.text = @"   优惠码无效,使用失败";
    invalidCouponLabel.textColor = Hmred(1);
    invalidCouponLabel.font = UIptfont(14);
    
    [contentView addSubview:invalidCouponLabel];
    
    [invalidCouponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(0);
        make.height.mas_equalTo(0);
        
    }];
    self.invalidCouponLabel = invalidCouponLabel;
    
    //分割线
    UIView *commSeprateLineView = [[UIView alloc]init];
    commSeprateLineView.backgroundColor = HCommomSeperatorline(1);
    [self.contentView addSubview:commSeprateLineView];
    
    [commSeprateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.equalTo(invalidCouponLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(45);
        
    }];
    
    
    //白色的背景
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [commSeprateLineView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(0.5);
        make.bottom.mas_equalTo(-0.5);
    }];
    
    //textfield
    
    UITextField *textfield = [[UITextField alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textfield];
    
    
    
    textfield.placeholder = @"请输入优惠码";
    textfield.borderStyle = UITextBorderStyleNone;
    [commSeprateLineView addSubview:textfield];
    self.textfield = textfield;
    
    [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0.5);
        make.bottom.mas_equalTo(-0.5);
        make.left.mas_equalTo(12);
        
        
    }];
    
    
    
    
    UIButton *sureButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [sureButton.titleLabel setFont:UIptfont(17)];
    [sureButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    sureButton.userInteractionEnabled = NO;
    
    UIColor *normalColor = Kcolor16rgb(@"#dddddd", 1);
    [sureButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateNormal)];
    
    
    UIColor *selectedColor = Kcolor16rgb(@"#2ca6e0", 1);
    [sureButton setBackgroundImage:[UIImage imageWithColor:selectedColor] forState:(UIControlStateHighlighted)];
    
    [sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    sureButton.layer.cornerRadius = 5;
    sureButton.layer.masksToBounds = YES;
    [self.contentView addSubview:sureButton];
    
    self.sureButton = sureButton;
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(textfield.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
        
    }];
    
}



// 确定

-(void)sureButtonAction:(UIButton *)button{
    // 确定使用的请求
    
    YBNetManager *mannger = [[YBNetManager alloc]init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    __weak typeof(self) weakSelf = self;
    
    if ([self.shoppingCarModel.coupon isEqualToString:@"0"]) {

        dict[@"coupon"] = self.textfield.text;
        dict[@"cid"] = self.shoppingCarModel.course_id;
        
        [mannger POST:useCouponCodeURL parameters:dict headdict:JuuserInfo.headDit constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            
        } progress:^(NSProgress * _Nonnull Progress) {
            
            
        } success:^(NSURLSessionDataTask *task, NSDictionary * responseObject) {
            
            JULog(@"%@", responseObject);
            
            NSString *responseCode = [responseObject[@"errno"] description];
            
            if ([responseCode isEqualToString:@"0"]) { // 优惠码可以使用
                
                [weakSelf.navigationController popViewControllerAnimated:NO];
                
   
            }else{
                

//                if ([responseCode isEqualToString:@"404"]){//优惠码不存在
//                    
//                    weakSelf.invalidCouponLabel.text = @"   优惠码不存在,使用失败";
//                    
//                }else if ([responseCode isEqualToString:@"500"]){//优惠码金额超过支付价格
//                    
//                    weakSelf.invalidCouponLabel.text = @"   优惠码金额超过支付价格,本次课程不能使用";
//                    
//                }else if ([responseCode isEqualToString:@"403"]){// 	优惠码已使用
//                    
//                    weakSelf.invalidCouponLabel.text = @"   优惠码不存在，已经过期或已经被使用";
//                    
//                }else if ([responseCode isEqualToString:@"402"]){// 	优惠码已使用
//                    
//                    weakSelf.invalidCouponLabel.text = @"   优惠码不适用此课程";
//                    
//                }
//                
                NSString *msg = responseObject[@"msg"];
                if (![msg length]) {
                    msg = @"优惠码使用失败";
                }
                
                
                weakSelf.invalidCouponLabel.text = msg;
                
                
                [weakSelf invalidCouponAction];

                
            }
            
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            
        }];
        
 
        
        
        
        
        
        //取消使用的请求
    }else{
        

        
        dict[@"coupon"] = self.shoppingCarModel.coupon;
        
        [mannger POST:cancelUseCouponCodeURL parameters:dict headdict:JuuserInfo.headDit constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            
        } progress:^(NSProgress * _Nonnull Progress) {
            
            
        } success:^(NSURLSessionDataTask *task, NSDictionary * responseObject) {
            
            NSString *responseCode = [responseObject[@"errno"] description];
            
            if ([responseCode isEqualToString:@"0"]) { //取消使用
                
                [weakSelf.navigationController popViewControllerAnimated:NO];
                
                
                
            }else{
                //取消使用失败
                [responseObject showWithView:nil text:@"取消使用失败" duration:1.5];
          
                
            }
            
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            
        }];
        

        
        
    }
    
    
}



#pragma mark 通知方法

-(void)textFieldTextDidChangeNotification:(NSNotification *)notifi{
    
    if ([self.textfield.text length]) {
        
        UIColor *normalColor = Kcolor16rgb(@"#18b4ed", 1);
        [self.sureButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateNormal)];
        self.sureButton.userInteractionEnabled = YES;
        
        
    }else{
        
        
        UIColor *normalColor = Kcolor16rgb(@"#dddddd", 1);
        [self.sureButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateNormal)];
        self.sureButton.userInteractionEnabled = NO;
        
    }
    
}


//优惠券无效的动画
-(void)invalidCouponAction{
    
    [self.invalidCouponLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.and.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
        
    }];
    
    [UIView animateWithDuration:0.9 animations:^{
        
        [self.contentView layoutIfNeeded];
        
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       
                       [self.invalidCouponLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                           
                           make.left.and.right.and.top.mas_equalTo(0);
                           make.height.mas_equalTo(0);
                           
                       }];
                       
                       [UIView animateWithDuration:0.9 animations:^{
                           
                           [self.contentView layoutIfNeeded];

                       }];
                   });
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    if ([self.shoppingCarModel.coupon isEqualToString:@"0"]) {
        self.textfield.userInteractionEnabled = YES;
        
        UIColor *normalColor = Kcolor16rgb(@"#dddddd", 1);
        [self.sureButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateNormal)];
        self.sureButton.userInteractionEnabled = NO;
        [self.sureButton setTitle:@"确定使用" forState:(UIControlStateNormal)];

    }else{
        self.textfield.userInteractionEnabled = NO;
        self.textfield.text = self.shoppingCarModel.coupon;
        
        UIColor *normalColor = Hcgray(1);
        [self.sureButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateNormal)];
        [self.sureButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateHighlighted)];
        
        self.sureButton.userInteractionEnabled = YES;
        [self.sureButton setTitle:@"取消使用" forState:(UIControlStateNormal)];

        
    }
    
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}



@end
