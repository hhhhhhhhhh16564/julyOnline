//
//  NSArray+Extension.m
//  algorithm
//
//  Created by 周磊 on 17/4/25.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "NSArray+Extension.h"
#import "NSDictionary+Extension.h"

@implementation NSArray (Extension)


- (nullable NSData *)jsonDate{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        if (!error) return jsonData;
    }
    return nil;
    
}


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



-(NSMutableArray *)mutableArrayDeeoCopy{
    
    NSMutableArray *array = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        id objOject;
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            objOject = [obj mutableDicDeepCopy];
            
        }else if ([obj isKindOfClass:[NSArray class]]){
            
            objOject = [obj mutableArrayDeeoCopy];
            
        }else{
            
            objOject = obj;
        }
        
        [array addObject:objOject];
        
    }];
    
    return array;
    
    
    
}

@end
