//
//  JURegisteredAgreementViewContoller.m
//  七月算法_iPad
//
//  Created by pro on 16/7/3.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JURegisteredAgreementViewContoller.h"

#import "JUDetectNetworkingTool.h"
#import "JUTabBarController.h"

@interface JURegisteredAgreementViewContoller ()<UIWebViewDelegate>


@property(nonatomic, strong) UIWebView *webView;

@end

@implementation JURegisteredAgreementViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"用户使用协议";
    self.view.backgroundColor = [UIColor whiteColor];

    
    
    UIWebView *webView = [[UIWebView alloc]init];
    

    NSURL *url = [NSURL URLWithString:registeredAgreementWebURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
   webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    self.webView = webView;
    
//    [webView.scrollView setBounces:NO];
    self.webView.frame = self.view.bounds;
    
    
    [self.view addSubview:self.webView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (networkingType == NotReachable) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            GMToast *toasts = [[GMToast alloc]initWithView:window text:@"请检查你的网络" duration:1.5];
            
            [toasts show];
            
        });
        
    }
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'"];//修改百分比即可
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置导航栏的背景颜色
    
    [self.navigationController.navigationBar setBarTintColor:HCanvasColor(1)];
    //设置title的字体颜色和样式
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = UIptfont(34*KMultiplier);
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    
    
}




@end
