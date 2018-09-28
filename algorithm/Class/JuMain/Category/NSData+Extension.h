//
//  NSData+Extension.h
//  七月算法_iPad
//
//  Created by 周磊 on 17/2/14.
//  Copyright © 2017年 zhl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Extension)
- (NSString *)md2String;

/**
 Returns an NSData for md2 hash.
 */
- (NSData *)md2Data;

/**
 Returns a lowercase NSString for md4 hash.
 */
- (NSString *)md4String;

/**
 Returns an NSData for md4 hash.
 */
- (NSData *)md4Data;

/**
 Returns a lowercase NSString for md5 hash.
 */
- (NSString *)md5String;

/**
 Returns an NSData for md5 hash.
 */
- (NSData *)md5Data;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (NSString *)sha1String;

/**
 Returns an NSData for sha1 hash.
 */
- (NSData *)sha1Data;

/**
 Returns a lowercase NSString for sha224 hash.
 */
- (NSString *)sha224String;

/**
 Returns an NSData for sha224 hash.
 */
- (NSData *)sha224Data;

/**
 Returns a lowercase NSString for sha256 hash.
 */
- (NSString *)sha256String;

/**
 Returns an NSData for sha256 hash.
 */
- (NSData *)sha256Data;

/**
 Returns a lowercase NSString for sha384 hash.
 */
- (NSString *)sha384String;

/**
 Returns an NSData for sha384 hash.
 */
- (NSData *)sha384Data;

/**
 Returns a lowercase NSString for sha512 hash.
 */
- (NSString *)sha512String;

/**
 Returns an NSData for sha512 hash.
 */
- (NSData *)sha512Data;
@end
