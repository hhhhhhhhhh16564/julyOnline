//
//  JUYUtil.m
//  七月算法_iPad
//
//  Created by pro on 16/5/28.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUYUtil.h"

@implementation JUYUtil
+(int)wordsCount:(NSString *)string{
    int i,n=[string length],l=0,a=0,b=0;
    
    unichar c;
    
    for(i=0;i<n;i++){
        
        c=[string characterAtIndex:i];
        
        if(isblank(c)){
            
            b++;
            
        }else if(isascii(c)){
            
            a++;
            
        }else{
            
            l++;
            
        }
    }
    
    if(a==0 && l==0) return 0;
    NSLog(@"字数是：%d",l+(int)ceilf((float)(a+b)/2.0));
    return l+(int)ceilf((float)(a+b)/2.0);
    
}

+ (BOOL)isPureInt:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
    
}

+ (NSString*)GetDicString:(NSDictionary*)dic Key:(NSString*)key
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]])
    {
        return @"";
    }
    
    NSString *str = [dic objectForKey:key];
    
    if (!str || ![str isKindOfClass:[NSString class]])
    {
        str = @"";
    }
    
    return str;
}

+ (BOOL)GetDicBool:(NSDictionary*)dic Key:(NSString*)key
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]])
    {
        return 0;
    }
    
    if (![dic objectForKey:key])
    {
        return 0;
    }
    
    if ([[dic objectForKey:key] isKindOfClass:[NSNull class]])
    {
        return 0;
    }
    
    return [[dic objectForKey:key] boolValue];
}

+ (int)GetDicInt:(NSDictionary*)dic Key:(NSString*)key
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]])
    {
        return 0;
    }
    
    if (![dic objectForKey:key])
    {
        return 0;
    }
    
    if ([[dic objectForKey:key] isKindOfClass:[NSNull class]])
    {
        return 0;
    }
    
    return [[dic objectForKey:key] intValue];
}

+ (long long)GetDicLongLong:(NSDictionary*)dic Key:(NSString*)key
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]])
    {
        return 0;
    }
    
    if (![dic objectForKey:key])
    {
        return 0;
    }
    
    if ([[dic objectForKey:key] isKindOfClass:[NSNull class]])
    {
        return 0;
    }
    
    return [[dic objectForKey:key] longLongValue];
}

+ (NSArray*)GetDicArray:(NSDictionary*)dic Key:(NSString*)key
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]])
    {
        return [NSArray array];
    }
    
    if (![dic objectForKey:key])
    {
        return [NSArray array];
    }
    
    if ([[dic objectForKey:key] isKindOfClass:[NSArray class]])
    {
        return [dic objectForKey:key];
    }
    else
        return [NSArray array];
}

@end
