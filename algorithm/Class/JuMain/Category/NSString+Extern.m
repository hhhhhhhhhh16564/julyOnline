

#import "NSString+Extern.h"

@implementation NSString (Extern)
-(NSInteger)fileSize{
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    //判断是否诶文件
    BOOL dir =  NO;
    BOOL exists = [mgr fileExistsAtPath:self isDirectory:&dir];
    
    //文件或文件夹不存在
    if (exists == NO) {
        return 0;
    }
    if (dir) {//self 是一个文件夹
        
        //获得caches里的所有内容---直接和简接内容
        NSArray *subpaths = [mgr subpathsAtPath:self];
        NSInteger totalByteSize = 0;
        for (NSString *subpath in subpaths) {
            //获得全路径
            NSString *fullsubpath = [self stringByAppendingPathComponent:subpath];
            //判断是否为文件
            BOOL dir = NO;
            [mgr fileExistsAtPath:fullsubpath isDirectory:&dir];
            if (dir == NO) {//文件
                totalByteSize += [[mgr attributesOfItemAtPath:fullsubpath error:nil][NSFileSize] integerValue];
            }
                
        }
        
        return totalByteSize;
        
    }else{//self是一个文件
       return[[mgr attributesOfItemAtPath:self error:nil][NSFileSize] integerValue];
    
    }
    
  
    return 0;
    
}






-(NSString *)convertSize:(NSInteger)length
{
    
    
    if(length<1024)
        return [NSString stringWithFormat:@"%ldB",(long)length];
    else if(length>=1024&&length<1024*1024)
        return [NSString stringWithFormat:@"%.1fK",(float)length/1024];
    else if(length >=1024*1024&&length<1024*1024*1024)
        return [NSString stringWithFormat:@"%.2fM",(float)length/(1024*1024)];
    else
        return [NSString stringWithFormat:@"%.2fG",(float)length/(1024*1024*1024)];
    
}

-(NSString *)fileTotalSize{
    
    NSInteger totalLength = [self fileSize];
    
    NSString *size = [self convertSize:totalLength];
    
    return size;
   
    
}


// 将时间s转化为小时分钟天
-(NSString *)convertedTimer:(NSInteger)second{
    if (second < 60) {
        
        return [NSString stringWithFormat:@"%ld秒",(long)second];
        
    }else if (second < 60*60){
        
        NSInteger minute = second/60;
        NSInteger secs = second % 60;
        return [NSString stringWithFormat:@"%ld分钟%ld秒",(long)minute, (long)secs];
        
    }else if (second < 60 * 60 * 24){
        
        NSInteger hour = second/3600;
        NSInteger minute = second%3600/60;
        NSInteger secs = second/60;
        
        return [NSString stringWithFormat:@"%ld时%ld分%ld秒",(long)hour, (long)minute, (long)secs];
        
    }else{
        
        return [NSString stringWithFormat:@"超过1天"];
    }
    
    
}






@end
