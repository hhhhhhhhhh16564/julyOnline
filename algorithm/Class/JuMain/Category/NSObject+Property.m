//
//  NSObject+Property.m
//  runtime_1.0
//
//  Created by 周磊 on 16/7/27.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>


@implementation NSObject (Property)

-(void)showWithView:(UIView *)view text:(NSString *)text duration:(CGFloat)timeInterval{
    
    if (view == nil) {
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        view = window;
    }
    if (![text length]) {
        return;
    }
    
    GMToast *toast = [[GMToast alloc]initWithView:view  text:text duration:timeInterval];
    [toast show];
    

    
}



+(void)createPropertyCodeWithDict:(id)obj{
    
    
    NSDictionary *dict = nil;
    
    
    if ([obj isKindOfClass:[NSArray class]]) {
        if (![obj count]) return;
        
        obj = [obj firstObject];
        
    }
    
    if([obj isKindOfClass:[NSDictionary class]]) {
        
        dict = obj;
        
    }else{
        
        NSLog(@"传入的对象没有字典");
        return;
    }
    

    
    NSMutableString *strM = [NSMutableString string];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull propertyName, id  _Nonnull value, BOOL * _Nonnull stop) {
       
        
        NSString *code;
        
        if ([value isKindOfClass:[NSString class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;",propertyName]
            ;
            
            //如果模型是number,用字符串表示
        }else if ([value isKindOfClass:[NSNumber class]]){
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;",propertyName]
            ;
        }else if ([value isKindOfClass:[NSArray class]]){
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",propertyName]
            ;
        }else if ([value isKindOfClass:[NSDictionary class]]){
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",propertyName]
            ;
        }else if ([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",propertyName]
            ;
        }
        
        [strM appendFormat:@"\n%@\n",code];
        
    }];
    
    NSLog(@"%@", strM);
    
}



//利用runtime打印该类的所有属性
-(NSMutableDictionary *)logObjectExtension_YanBo{
    
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
//    dictionary[@"<*************该对象的类型和地址****************>"] = [NSString stringWithFormat:@"<%@: %p>", [self class], self];
    
    unsigned int count = 0;
    
    Ivar *ivar = class_copyIvarList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        
        NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(ivar[i])];
        
        
        //去掉下划线
        propertyName = [propertyName substringFromIndex:1];
        
        
        id PropertyValue = [self valueForKey:propertyName]?:@"****";
        
        
        [dictionary setValue:PropertyValue forKey:propertyName];
        
    }
    
    free(ivar);
    
    
    JULog(@"%@", dictionary);
    
    return dictionary;
    
}
//打印包括父类的所有属性
-(NSMutableDictionary *)logObjectAllExtension_YanBo{
    
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    //    dictionary[@"<*************该对象的类型和地址****************>"] = [NSString stringWithFormat:@"<%@: %p>", [self class], self];
    
    Class c = [self class];
    
    while (c && c!= [NSObject class]) {
        
        
        unsigned int count = 0;
        
        Ivar *ivar = class_copyIvarList([c class], &count);
        
        for (int i = 0; i < count; i++) {
            
            NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(ivar[i])];
            
            
            //去掉下划线
            propertyName = [propertyName substringFromIndex:1];
            
            
            id PropertyValue = [self valueForKey:propertyName]?:@"nil";
            
            
            [dictionary setValue:PropertyValue forKey:propertyName];
            
        }
        
        free(ivar);
        
        c = [c superclass];
        
    
    }
    
    
    
    
    
    

    
    
    JULog(@"%@", dictionary);
    
    return dictionary;
    
}




- (NSString *)debugDescription
{
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    //    dictionary[@"<*************该对象的类型和地址****************>"] = [NSString stringWithFormat:@"<%@: %p>", [self class], self];
    
    unsigned int count = 0;
    
    Ivar *ivar = class_copyIvarList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        
        NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(ivar[i])];
        
        
        //去掉下划线
        propertyName = [propertyName substringFromIndex:1];
        
        
        id PropertyValue = [self valueForKey:propertyName]?:@"nil";
        
        
        [dictionary setValue:PropertyValue forKey:propertyName];
        
    }
    
    free(ivar);

    return [NSString stringWithFormat:@"<%@: %p> %@", [self class], self, dictionary];
}



@end
