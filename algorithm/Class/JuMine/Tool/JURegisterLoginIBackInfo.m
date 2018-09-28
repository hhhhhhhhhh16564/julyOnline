//
//  JURegisterLoginIBackInfo.m
//  七月算法_iPad
//
//  Created by pro on 16/5/28.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JURegisterLoginIBackInfo.h"


@interface JURegisterLoginIBackInfo ()

@property(nonatomic, strong) NSMutableDictionary *backInfo;
@end

@implementation JURegisterLoginIBackInfo
-(NSMutableDictionary *)backInfo{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    
    [dic setObject:@"用户名或密码错误" forKey:@"4003"];
    [dic setObject:@"用户不存在" forKey:@"4004"];
    [dic setObject:@"登录失败" forKey:@"4007"];
    [dic setObject:@"密码不正确" forKey:@"4015"];
    [dic setObject:@"退出失败" forKey:@"4017"];
    [dic setObject:@"用户名已被注册" forKey:@"4021"];
    [dic setObject:@"该邮箱已被注册" forKey:@"4022"];
    [dic setObject:@"注册失败" forKey:@"4023"];
    
    /**
     *4000 访问频率限制
     4003 用户名或密码错误
     4004 用户不存在
     4007 登录失败
     4008 获取用户 access_token 失败
     4009 登录 token 不存在
     4010 登录 ID 不存在
     4011 非法请求
     4012 非法 token
     4013 用户未登录
     4014 未收到数据
     4015 密码不正确
     4016 数据不存在
     4017 退出失败
     4018 无权限观看此视频
     4020 course_id 或 lesson_id 不能为空
     4021 用户名已被注册
     4022 email 已被注册
     4023 注册失败
     4024 缺少 access-token 字段
     4025 缺少 uid 字段
     4026 缺少 plat-form 字段
     4027 需要重新登录
     4028 用户信息不完整
     5001 access_token 不能为空
     5002 uid 不能为空
     5003 uid 不能为空
     5004 生成用户失败

     */
    
    
    return dic;
 }

-(void)showInformationError:(NSString *)erroecode ToView:(UIView *)view{
    
  [self.backInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
      
      if ([key isEqualToString:erroecode]) {
          
          
          dispatch_async(dispatch_get_main_queue(), ^{
              
              GMToast *toast = [[GMToast alloc]initWithView:view text:obj duration:1.5];
              [toast show];
              
          });
          
          
          
      }
      
      
  }];
    
    
    
    
}














@end
