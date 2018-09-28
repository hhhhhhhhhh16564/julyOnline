//
//  NSArray+Extension.h
//  algorithm
//
//  Created by 周磊 on 17/4/25.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extension)

//转换为date, 去掉空格和换行
- (nullable NSData *)jsonDate;

//转换为date,之前的格式保留
- (nullable NSData *)jsonPrettyDate;


- (nullable NSString *)jsonStringEncoded;
/**
 Convert object to json string formatted. return nil if an error occurs.
 */
- (nullable NSString *)jsonPrettyStringEncoded;


-(NSMutableArray *)mutableArrayDeeoCopy;

@end
