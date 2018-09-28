//
//  NSDictionary+Extension.m
//  algorithm
//
//  Created by 周磊 on 17/4/25.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "NSDictionary+Extension.h"
#import "NSArray+Extension.h"

@implementation NSDictionary (Extension)

- (nullable NSData *)jsonDate{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        
        if (!error) return jsonData;
    }
    
    
    return nil;
    
}

//转换为date,空格换行去掉
- (nullable NSData *)jsonPrettyDate{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) return jsonData;
    }
    return nil;
    
    
}

- (NSString *)jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

- (NSString *)jsonPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

-(NSMutableDictionary *)mutableDicDeepCopy
{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithCapacity:[self count]];
    //新建一个NSMutableDictionary对象，大小为原NSDictionary对象的大小
    NSArray *keys=[self allKeys];
    for(id key in keys)
    {//循环读取复制每一个元素
        id value=[self objectForKey:key];
        id copyValue;
        if ([value isKindOfClass:[NSDictionary class]]) {
            
            copyValue=[value mutableDicDeepCopy];
            
        }else if([value isKindOfClass:[NSArray class]])
            
        {
            copyValue=[value mutableArrayDeeoCopy];
        }
        
        
        if(copyValue==nil){
            copyValue=[value copy];
        }
        
        if ([copyValue isKindOfClass:[NSString class]]) {
            copyValue = [copyValue copy];
        }
        
        [dict setObject:copyValue forKey:key];
        
    }
    return dict;
}
 
@end
