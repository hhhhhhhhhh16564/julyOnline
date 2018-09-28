//
//  JUWebViewController.h
//  algorithm
//
//  Created by pro on 16/9/17.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUBaseViewController.h"

@interface JUWebViewController : JUBaseViewController

@property(nonatomic, strong) UIWebView *webView;


@property(nonatomic, strong) NSString *jump_url;
@property (nonatomic,assign) CGRect webViewFrame;

@property(nonatomic, strong) NSString *html;

@end
