//
//  JUWebViewController.m
//  algorithm
//
//  Created by pro on 16/9/17.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUWebViewController.h"

@interface JUWebViewController ()<UIWebViewDelegate>

@end

@implementation JUWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIWebView *webView = [[UIWebView alloc]init];
    webView.delegate = self;
    webView.frame = CGRectMake(0, 64, Kwidth, Kheight-64);
    webView.opaque = NO;
    webView.backgroundColor = [UIColor whiteColor];
    
    if (self.jump_url) {
         webView.scalesPageToFit = YES;

    }
    

    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.jump_url]]];
    self.webView = webView;

    
    
}

-(void)setHtml:(NSString *)html{
    _html = html;

    if (self.webView) {
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        [self.webView loadHTMLString:html baseURL:url];
        
    }
    
    
    
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    if (self.webViewFrame.size.height && self.webViewFrame.size.width) {
        self.webView.frame = self.webViewFrame;
    }     
    
}



-(void)setJump_url:(NSString *)jump_url{
    _jump_url = jump_url;
    
    if (self.webView) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.jump_url]]];
    }
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{

    NSURL *requestURL = [request URL];
    BOOL iswebURL = [[requestURL scheme] isEqualToString:@"http"] || [[requestURL scheme] isEqualToString:@"https"];
    if ( iswebURL && navigationType == UIWebViewNavigationTypeLinkClicked) {
        // 课程详情页不要跳转
        
            if ([_html length]) {
                return NO;
            }

        
        return  ![[UIApplication sharedApplication ] openURL: requestURL];
        
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([_html length]) {
        return ;
    }
    NSMutableString *mutableString = [NSMutableString string];
    
    [mutableString appendString:@"javascript:(function(){"];
    [mutableString appendString:@"var objs = document.getElementsByTagName('img');"];
    [mutableString appendString:@"for(var i=0;i<objs.length;i++) {"];
    [mutableString appendString:@"objs[i].style.maxWidth = '100%';objs[i].style.height = 'auto';"];
    
    [mutableString appendString:@"}"];
    [mutableString appendString:@"})()"];
//    "javascript:(function(){"
//    + "var objs = document.getElementsByTagName('img'); "
//    + "for(var i=0;i<objs.length;i++) {"
//    + " objs[i].style.maxWidth = '100%';objs[i].style.height = 'auto';"
//    + "}"
//    + "})()"

   [self.webView stringByEvaluatingJavaScriptFromString:mutableString];
    
    
}



@end
