
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSData+Extension.h"
#import <CommonCrypto/CommonCrypto.h>

@interface NSString (Extension)

//普通字体，返回高度
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
//- (CGSize)sizeWithFont:(UIFont *)font;

//邮箱的正则表达式
+ (BOOL) validateEmail:(NSString *)email;
+ (BOOL) validatePassword:(NSString *)passWord;

//手机号码正则表达式
+ (BOOL)valiMobile:(NSString *)mobile;

//是否是QQ号码
+(BOOL)valiQQ:(NSString *)qq;



-(NSMutableAttributedString *)mutableAttributedString;

//普通字体转变为富文本字体，有行高的属性
-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace fontsize:(CGFloat)font;





//加密用的

// MD5加密的具体原理
-(NSString *)md5String_detail;









/**
 Returns a lowercase NSString for md2 hash.
 */
- (nullable NSString *)md2String;

/**
 Returns a lowercase NSString for md4 hash.
 */
- (nullable NSString *)md4String;

/**
 Returns a lowercase NSString for md5 hash.
 */
- (nullable NSString *)md5String;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (nullable NSString *)sha1String;

/**
 Returns a lowercase NSString for sha224 hash.
 */
- (nullable NSString *)sha224String;

/**
 Returns a lowercase NSString for sha256 hash.
 */
- (nullable NSString *)sha256String;

/**
 Returns a lowercase NSString for sha384 hash.
 */
- (nullable NSString *)sha384String;

/**
 Returns a lowercase NSString for sha512 hash.
 */
- (nullable NSString *)sha512String;
@end
