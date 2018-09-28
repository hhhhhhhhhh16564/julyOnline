//
//  NSObject+Property.h
//  runtime_1.0
//
//  Created by 周磊 on 16/7/27.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMToast.h"

@interface NSObject (Property)

// 字典转模型时直接打印出 属性 @proteryName....  ,打印出来复制粘贴到Model中
+(void)createPropertyCodeWithDict:(id)obj;

//打印某个对象属性值
-(NSMutableDictionary *)logObjectExtension_YanBo;


//打印某个对象包括父类在内的所有的属性值
-(NSMutableDictionary *)logObjectAllExtension_YanBo;



-(void)showWithView:(UIView *)view text:(NSString *)text duration:(CGFloat)timeInterval;



@end
