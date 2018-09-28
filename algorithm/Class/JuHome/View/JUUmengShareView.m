//
//  JUUmengShareView.m
//  algorithm
//
//  Created by 周磊 on 16/10/13.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUUmengShareView.h"
#import "UIButton+Extension.h"
#import "JUShareModel.h"




@interface JUUmengShareView ()
@property(nonatomic, strong) UILabel *shareLabel;
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIView *backView;

@property(nonatomic, strong) UIView  *lineView1;

@property(nonatomic, strong) UIView *lineView2;

@property(nonatomic, strong) NSArray<JUShareModel *> *shareArray;

@property (nonatomic,assign) BOOL weiXinInstall;
@property (nonatomic,assign) BOOL QQInstall;

@property(nonatomic, strong) UIButton *loginButton;

@end



@implementation JUUmengShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupViews];
    }
    return self;
}


-(void)setupViews{
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        
        self.weiXinInstall = YES;

    }else{
        
        self.weiXinInstall = NO;
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        
        self.QQInstall = YES;
        
    }else{
        
        self.QQInstall = NO;
        
    }
    
    

    
    NSArray *array = @[
                       
                       @{@"iconName":@"weibo-",
                         @"title":@"微博"
                         },
                       @{@"iconName":@"weixin-hao",
                         @"title":@"微信好友"
                         },
                       @{@"iconName":@"pengyouquan",
                         @"title":@"微信朋友圈"
                         },
                       @{@"iconName":@"QQ",
                         @"title":@"QQ好友"
                         },
                       @{@"iconName":@"kongjian",
                         @"title":@"QQ空间"
                         },
                       
                       ];
    
    self.shareArray = [JUShareModel mj_objectArrayWithKeyValuesArray:array];
    
//    [[self.shareArray firstObject] logObjectExtension_YanBo];
    
    
    
    UILabel *shareLabel = [[UILabel alloc]init];
    shareLabel.text = @"分享";
    shareLabel.font = UIptfont(16);
    shareLabel.textAlignment = NSTextAlignmentCenter;
    self.shareLabel = shareLabel;
    [self addSubview:shareLabel];
    

    UIView *lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = HCommomSeperatorline(1);
    [shareLabel addSubview:lineView1];
    self.lineView1 = lineView1;
    
    
    UIButton *loginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [loginButton.titleLabel setFont:UIptfont(15)];
    UIColor *titleColor = Kcolor16rgb(@"0099ff", 1);
    [loginButton setTitleColor:titleColor forState:(UIControlStateNormal)];
    [loginButton setTitle:@"您尚未登录，分享无法领取优惠券，请登录>" forState:(UIControlStateNormal)];
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:loginButton];
    self.loginButton = loginButton;
  
    UIView *backView = [[UIView alloc]init];
    [self addSubview:backView];
//    backView.backgroundColor = [UIColor redColor];
    self.backView = backView;
    
    
    for (int i = 0; i < 5; i++) {
        
        JUShareButton *button = [JUShareButton buttonWithType:UIButtonTypeCustom];
        JUShareModel *shareModel = self.shareArray[i];
        [JUShareButton buttonWithImage:shareModel.iconName title:shareModel.title titlefont:15 titleColor:[UIColor blackColor] button:button];
        
        button.tag = 1000+i;
        [backView addSubview:button];
        
        switch (i) {
            case 0:
                button.platformType = UMSocialPlatformType_Sina;
                break;
                
            case 1:
                button.platformType = UMSocialPlatformType_WechatSession;
                break;

            case 2:
                button.platformType = UMSocialPlatformType_WechatTimeLine;
                break;

            case 3:
                button.platformType = UMSocialPlatformType_QQ;
                break;

            case 4:
                button.platformType = UMSocialPlatformType_Qzone;
                break;

                
            default:
                break;
        }
        
        
        
        [button addTarget:self action:@selector(ShareButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
    }

    self.cancelButton = [UIButton buttonWithImage:nil title:@"取消" titlefont:16 titleColor:[UIColor blackColor] button:nil];
    
    [self.cancelButton addTarget:self action:@selector(cancelShare:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addSubview:self.cancelButton];
    
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = HCommomSeperatorline(1);
    [self.cancelButton addSubview:lineView2];
    self.lineView2 = lineView2;
    
    
    
    if (!self.weiXinInstall) {
        [self.backView viewWithTag:(1000+1)].hidden = YES;
        [self.backView viewWithTag:(1000+2)].hidden = YES;

        
    }
    
    
    
    if (!self.QQInstall) {
        
        [self.backView viewWithTag:(1000+3)].hidden = YES;
        [self.backView viewWithTag:(1000+4)].hidden = YES;
        
    }
    
    
    
}

-(void)ShareButtonAction:(JUShareButton *)shareButton{
    
    
    if (self.shareBlock) {
        self.shareBlock(shareButton);
    
    }
   
    
}


-(void)loginButtonClicked:(UIButton *)sender{
    
    if (self.loginBlock) {
        self.loginBlock(sender);
    }
}




-(void)cancelShare:(UIButton *)cancelButton{
    
    if (self.cancelBlcok) {
        self.cancelBlcok(cancelButton);
    }
    
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
//间距
   
    //距离左右的间距
    
    CGFloat spaceing = (Kwidth - 44*3-77*2)*0.5;
    

    
    self.shareLabel.frame = CGRectMake(0, 0, Kwidth, 44);
    self.lineView1.frame = CGRectMake(0, 0, Kwidth, 0.5);
    self.lineView1.bottom_extension = self.shareLabel.height_extension;
    
    
    CGFloat loginButtonHeight = 15;
    self.loginButton.hidden = YES;
    
    if (!JuuserInfo.isLogin && [JuuserInfo.showstring isEqualToString:@"1"] && self.showLogin) {
        //展示登录按钮
        
        loginButtonHeight = 39;
        self.loginButton.hidden = NO;
    }
    
    self.loginButton.frame = CGRectMake(0, self.shareLabel.bottom_extension, Kwidth, loginButtonHeight);
    self.backView.frame = CGRectMake(0, self.loginButton.bottom_extension, Kwidth, 100);
    for (int i = 0; i < 5; i++) {
        JUShareButton *button = (JUShareButton *)[self.backView viewWithTag:1000+i];
        int row = i / 3;
        int line = i % 3;
        //左右间距77
        CGFloat buttonx = (44+77)*line;
        //上下25
        CGFloat buttonY = (75+16)*row;
        
        button.frame = CGRectMake(buttonx+spaceing, buttonY, 44, 75);
        
        
        if (i==4) {
            
            self.backView.height_extension = button.bottom_extension+5;
        }
        
    }
    
    self.cancelButton.frame = CGRectMake(0, self.backView.bottom_extension+15, Kwidth, 50);
    self.lineView2.frame = CGRectMake(0, 0, Kwidth, 0.5);

    self.height_extension = self.cancelButton.bottom_extension;
    
    if ([self intersectWithView:nil]) {
        self.bottom_extension = Kheight;
    }else{
        
        self.y_extension = Kheight;
    }
    
    
    
    
}



@end
