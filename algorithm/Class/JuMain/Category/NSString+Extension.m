

#import "NSString+Extension.h"

#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
@implementation NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    
    // 获得系统版本
    if (iOS7) {
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        
    } else {
        return [self sizeWithFont:font constrainedToSize:maxSize];
    }
}
-(NSMutableAttributedString *)mutableAttributedString{
    
    return [[NSMutableAttributedString alloc]initWithString:self];
    
    
}

-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace fontsize:(CGFloat)font;
{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    
    UIFont *attrubutedfont = [UIFont systemFontOfSize:font];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributedString addAttribute:NSFontAttributeName value:attrubutedfont range:range];
    

    return attributedString;
    
}







//- (CGSize)sizeWithFont:(UIFont *)font
//{
//    return [self sizeWithFont:font maxW:MAXFLOAT];
//}

//邮箱的正则表达式
+ (BOOL) validateEmail:(NSString *)email;
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @".{6,20}";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}


//手机号码是否正确
+ (BOOL)valiMobile:(NSString *)mobile{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

+(BOOL)valiQQ:(NSString *)qq{
    
    NSString *qqRegex = @"^[1-9]\\d{4,10}$";
    
    NSPredicate *qqTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", qqRegex];
    
    return [qqTest evaluateWithObject:qq];
    
}


-(NSString *)md5String_detail{
    
    /*
     
     // 创建MD5
     CC_MD5_CTX md5;
     
     //初始化
     CC_MD5_Init(&md5);
     
     //更新加密参数
     
     //第一个参数：MD5加密的主题
     //第二个参数：需要加密的内容
     //第三个参数：需要加密的长度  有利于分组 例如 vip1 vip2 vip3  , BJS  BJH
     例子： bjs150844 和 bjs321434如果需要加密的长度选3，则加密结果完全相同
     
     
     CC_MD5_Update(&md5, string, (CC_LONG)strlen(string));
     
     //结束加密
     //第一个参数写加密结果的数组
     //第二个参数写MD5地址
     CC_MD5_Final(result, &md5);
     
     
     */
    
    // 创建 结果数组
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    // 加密
    CC_MD5([self UTF8String], (CC_LONG)self.length, result);
    
    
    NSMutableString *resulting = [[NSMutableString alloc]initWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        //将加密的结果数组以十六进制的形式拼接到可变字符串上
        [resulting appendFormat:@"%02X", result[i]];
        
    }
    return resulting;
    
}




- (NSString *)md2String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md2String];
}

- (NSString *)md4String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md4String];
}

- (NSString *)md5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5String];
}

- (NSString *)sha1String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1String];
}

- (NSString *)sha224String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha224String];
}

- (NSString *)sha256String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha256String];
}

- (NSString *)sha384String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha384String];
}

- (NSString *)sha512String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha512String];
}










@end
