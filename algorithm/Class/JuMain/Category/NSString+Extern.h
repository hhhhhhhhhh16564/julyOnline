

#import <Foundation/Foundation.h>

@interface NSString (Extern)
//一个文件夹或文件的总大小, 单位b
-(NSInteger)fileSize;
//一个文件夹或文件的总大小, 字符串
-(NSString *)fileTotalSize;
//将长度转化为内存大小
-(NSString *)convertSize:(NSInteger)length;

//将时间s转化
-(NSString *)convertedTimer:(NSInteger)second;
@end
