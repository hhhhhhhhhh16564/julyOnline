//
//  JUUser.m
//  七月算法_iPad
//
//  Created by pro on 16/5/28.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUUser.h"

@implementation JUUser


+(instancetype)sharceInstance
{
    
    static dispatch_once_t onceToken;
    static JUUser *user = nil;
    dispatch_once(&onceToken, ^{
       
        user = [[JUUser alloc]init];
        
    });
    
    
    return user;
    
}

-(NSString *)showstring{
    
    if (_showstring == nil) {
        
        _showstring = @"0";
    }
    
    return _showstring;
}



-(NSString *)mobile{
    return _mobile?_mobile:@"";
}
-(NSString *)email{
    
    return _email?_email:@"";
}
-(NSString *)user_name{
    return _user_name?_user_name:@"";
}
-(NSString *)password{
    return _password?_password:@"";
}
-(NSString *)avatar_file{
    return _avatar_file?_avatar_file:@"";
}
-(NSString *)accessToken{
    return _accessToken?_accessToken:@"";
}
-(NSString *)uid{
    
 
   
    return _uid;
    
}

-(NSMutableDictionary *)loginDate{
  
    if (!_loginDate) {
        
        _loginDate = [NSMutableDictionary dictionary];
    }
    
    return _loginDate;
}






-(void)setUid:(NSString *)uid
{
    
    _uid = [NSString stringWithFormat:@"%@",uid];
    
    
}


-(void)setIsLogin:(BOOL)isLogin
{
//    BOOL oldState = _isLogin;
    
     _isLogin = isLogin;
    
    
    //老的状态不等于新的状态
//    if (oldState != isLogin) {
    
        
        [[NSNotificationCenter defaultCenter] postNotificationName:JULoginStatueDidChanged object:nil];

//    }
    
}


//取得时候先加载
-(void)loadFromUserDefaults{
    //    GMSingleClientUser* user = [[GMSingleClientUser alloc]init];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    _uid = [defaults objectForKey:@"uid"];
    _mobile =[defaults objectForKey:@"mobile"];
    _user_name =[defaults objectForKey:@"user_name"];
    _password =[defaults objectForKey:@"password"];
    _email =[defaults objectForKey:@"email"];
    _avatar_file = [defaults objectForKey:@"avatar_file"];
    _isLogin =[[defaults objectForKey:@"isLogin"] boolValue];
    _accessToken = [defaults objectForKey:@"accessToken"];
     _isThirdPartLogin =[[defaults objectForKey:@"isThirdPartLogin"] boolValue];
    
    _loginDate = [defaults objectForKey:@"loginDate"];
    
    //    return user;
}




-(void)saveUserInfo{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.uid forKey:@"uid"];
    
    [defaults setObject:self.mobile forKey:@"mobile"];
    [defaults setObject:self.user_name forKey:@"user_name"];
    [defaults setObject:self.password forKey:@"password"];
    [defaults setObject:self.email forKey:@"email"];
    [defaults setObject:self.avatar_file forKey:@"avatar_file"];
    [defaults setObject:self.loginDate forKey:@"loginDate"];
    
    
    
    
    NSNumber *isLogin = [NSNumber numberWithBool:self.isLogin];
    [defaults setObject:isLogin forKey:@"isLogin"];
    
    
    
    NSNumber *isThirdPartLogin = [NSNumber numberWithBool:self.isThirdPartLogin];
    [defaults setObject:isThirdPartLogin forKey:@"isThirdPartLogin"];
    
    
    
    [defaults setObject:self.accessToken forKey:@"accessToken"];
    

    [defaults synchronize];
    
}

-(void)logoutClear{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:@"" forKey:@"uid"];
    
    [defaults setObject:@"" forKey:@"mobile"];
    [defaults setObject:@"" forKey:@"user_name"];
    [defaults setObject:@"" forKey:@"password"];
    [defaults setObject:@"" forKey:@"email"];
    [defaults setObject:@"" forKey:@"avatar_file"];
    [defaults setObject:nil forKey:@"loginDate"];
    
    
    
    
    NSNumber *isLogin = [NSNumber numberWithBool:self.isLogin];
    [defaults setObject:isLogin forKey:@"isLogin"];
    
    
    
//    NSNumber *isThirdPartLogin = [NSNumber numberWithBool:self.isThirdPartLogin];
//    [defaults setObject:isThirdPartLogin forKey:@"isThirdPartLogin"];
    
    
    
//    [defaults setObject:@"" forKey:@"accessToken"];
    
    
    [defaults synchronize];
    
    
    
    
    
}










-(NSMutableDictionary *)headDit{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
// plat_form 1 //plat_form=1 表示ios plat_form=2 表示android
// client_os [[UIDevice currentDevice] systemVersion]
// device_id [[UIDevice currentDevice].identifierForVendor UUIDString]

    NSString *plat_form = [NSString stringWithFormat:@"%d",1];
    NSString *client_os = [[UIDevice currentDevice] systemVersion];
    NSString *device_id = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    [dict setObject:plat_form forKey:@"plat-form"];
    [dict setObject:client_os forKey:@"client-os"];
    [dict setObject:device_id forKey:@"device-id"];
    
    
    //登录之后加入 uid
    if (self.isLogin) {
        
        //登录时的 uid 和 accessToken
        
     [dict setObject:self.uid forKey:@"uid"];
     [dict setObject:self.accessToken forKey:@"access-token"];
        
//        JULog(@"uid:  %@ \n access-token: %@", self.uid, self.accessToken);
        
    }else{
        
        // 未登录时候的 uid 和 accesstoken
        
        // 为了应付苹果审核 当不登录时内部走这个账号
        // 账号： appleshenheyanbo@163.com    昵称： 1122334455
        
        // 密码  11111111
    
        
        if ([self.showstring isEqualToString:@"0"]) {
            NSString *uid = @"60162";
            NSString *accesstoken = @"e36fab9141d0b783-29c587a0a0238e9f";
            
            [dict setObject:uid forKey:@"uid"];
            [dict setObject:accesstoken forKey:@"access-token"];
            
        }
        
        

        
    }
    
    return dict;
    
}



@end
