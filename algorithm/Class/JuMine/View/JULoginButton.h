//
//  JULoginButton.h
//  七月算法_iPad
//
//  Created by pro on 16/5/26.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    
    winxinlogin = 10,// 不能开始就0，否则不设置默认值为0，随便给一个数字吧
    weibologin,
    QQlogin,
    normallogin,
    
    
}LoginStyle;

//qq  微信  微博登录的按钮

@interface JULoginButton : UIButton
@property(nonatomic, assign) LoginStyle loginstyle;
@end
