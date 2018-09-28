//
//  JUYUtil.h
//  七月算法_iPad
//
//  Created by pro on 16/5/28.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifndef GETDICVALUE
#define GETDICVALUE(Dic, key) \
([[Dic objectForKey:key] isKindOfClass:[NSNull class]] ? nil : [Dic objectForKey:key])
#endif


@interface JUYUtil : NSObject

+ (BOOL)isPureInt:(NSString *)string;
+(int)wordsCount:(NSString *)string;
+ (NSString*)GetDicString:(NSDictionary*)dic Key:(NSString*)key;
+ (BOOL)GetDicBool:(NSDictionary*)dic Key:(NSString*)key;
+ (int)GetDicInt:(NSDictionary*)dic Key:(NSString*)key;
+ (long long)GetDicLongLong:(NSDictionary*)dic Key:(NSString*)key;
+ (NSArray*)GetDicArray:(NSDictionary*)dic Key:(NSString*)key;


@end
