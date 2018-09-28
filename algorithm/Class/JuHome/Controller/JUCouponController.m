//
//  JUCouponController.m
//  algorithm
//
//  Created by pro on 16/9/12.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUCouponController.h"

@interface JUCouponController ()
@property(nonatomic, strong) UIView *contentView;

@property(nonatomic, strong) UILabel *invalidCouponLabel;

@property(nonatomic, strong) UITextField *textfield;

@property(nonatomic, strong) UIButton *sureButton;

@end

@implementation JUCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        return;
    }
    
    
    [self setupViews];
}

#pragma mark 视图布局
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
    
    [sureButton setTitle:self.buttonString forState:(UIControlStateNormal)];
    
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
#pragma mark 响应方法

-(void)sureButtonAction:(UIButton *)button{
    
    if ([self.buttonString isEqualToString:@"取消使用"]) {
        
        if (self.myBlock) {
            
        self.myBlock(@"无");

        }
        
        
        if (self.couponBlock) {
            
            self.couponBlock(@"0");
            
        }
        
        
        [self.navigationController popViewControllerAnimated:NO];
        
        return;
    }
    
    //点击之后按钮不能点击，优惠码文字不能输入
    
    [self makeData];
    
  
    JUlogFunction
    
}

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

#pragma mark 数据请求

//请求数据
-(void)makeData{
    

    YBNetManager *mannger = [[YBNetManager alloc]init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"code"] = self.textfield.text;
    dict[@"cid"] = self.cid;
    
    [mannger POST:validCouponURL parameters:dict headdict:JuuserInfo.headDit constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } progress:^(NSProgress * _Nonnull Progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        JULog(@"%@", responseObject);
        
        if ([[responseObject[@"errno"] description] isEqualToString:@"0"]) {//优惠券可用
            
            if (self.myBlock) {
                
                NSString *redcePrice = [responseObject[@"data"][@"amount"] description];
                
                self.myBlock(redcePrice);
                
            }
            
            
            
            if (self.couponBlock) {
                
                NSString *couponString = self.textfield.text;
                
                self.couponBlock(couponString);
                
            }
            
      

            [self.navigationController popViewControllerAnimated:NO];

            
            
        }else{//优惠券不可用
            
            if (self.myBlock) {
                
                self.myBlock(@"无");
                
            }
            
            
            
            if ([[responseObject[@"errno"] description] isEqualToString:@"4030"]){//优惠码不存在
                
                self.invalidCouponLabel.text = @"   优惠码不存在,使用失败";
                
            }else if ([[responseObject[@"errno"] description] isEqualToString:@"4031"]){//优惠码金额超过支付价格
                
                self.invalidCouponLabel.text = @"   优惠码金额超过支付价格,本次课程不能使用";

                
            }else if ([[responseObject[@"errno"] description] isEqualToString:@"4032"]){// 	优惠码已使用
                
                self.invalidCouponLabel.text = @"   优惠码已经使用,无效";

                
            }
            
            [self invalidCouponAction];
         
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
    
}


#pragma mark 系统方法
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([self.buttonString isEqualToString:@"确定使用"]) {
        self.textfield.userInteractionEnabled = YES;
        
        UIColor *normalColor = Kcolor16rgb(@"#dddddd", 1);
        [self.sureButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateNormal)];
        self.sureButton.userInteractionEnabled = NO;
        
    }else if ([self.buttonString isEqualToString:@"取消使用"]){
        self.textfield.userInteractionEnabled = NO;
        
        UIColor *normalColor = Hcgray(1);
        [self.sureButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateNormal)];
        [self.sureButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateHighlighted)];

        self.sureButton.userInteractionEnabled = YES;

        
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


-(void)dealloc{
    
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
