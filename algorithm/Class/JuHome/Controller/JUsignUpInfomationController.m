//
//  JUsignUpInfomationController.m
//  algorithm
//
//  Created by 周磊 on 16/8/24.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUsignUpInfomationController.h"


#import "JUsignUpInfomationView.h"

@interface JUsignUpInfomationController ()<UIAlertViewDelegate>

@property(nonatomic, strong) JUsignUpInfomationView *signUpInfomationView;



@end

@implementation JUsignUpInfomationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HCanvasColor(1);
    
    [self setupViews];
    
    
    //刚进入界面时，填写信息
    [self setupInformation];
    
    
}


#pragma mark 视图布局

-(void)setupViews{
    
    
    self.navigationItem.title = @"报名信息";
    self.navigationItem.leftBarButtonItem =   [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"btn_black_back" highImage:nil];
    

    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    JUsignUpInfomationView *signUpInfomationView = [[JUsignUpInfomationView alloc]init];
    
    signUpInfomationView.frame = CGRectMake(0, 74, Kwidth, Kheight-74);
    signUpInfomationView.contentSize = CGSizeMake(Kwidth, 416);
    
    [self.view addSubview:signUpInfomationView];
    
    __weak typeof(self) weakSelf = self;
    
    signUpInfomationView.block = ^{
        
        [weakSelf.navigationController popViewControllerAnimated:NO];
        
    };
    
    
    
    self.signUpInfomationView = signUpInfomationView;
    


    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UIKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

-(void)setupInformation{
    
    self.signUpInfomationView.userInfoModel = self.userInfoModel;
    
}




-(void)KeyboardWillShowNotification:(NSNotification *)notifi{
    
    

    
    CGRect rect = [notifi.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    self.signUpInfomationView.contentSize = CGSizeMake(Kwidth, rect.size.height+416);
    [self.signUpInfomationView layoutIfNeeded];
    
    
}


-(void)UIKeyboardWillHideNotification:(NSNotification *)notifi{
    
    self.signUpInfomationView.contentSize = CGSizeMake(Kwidth, 416);
    [self.signUpInfomationView layoutIfNeeded];
    
    

    
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


- (void)dealloc
{
    JUlogFunction
}











@end
