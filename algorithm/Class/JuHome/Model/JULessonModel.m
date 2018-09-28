//
//  JULessonModel.m
//  七月算法_iPad
//
//  Created by 周磊 on 16/6/1.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JULessonModel.h"
#import "JUDownloadInfo.h"
#import "JUDateBase.h"

@implementation JULessonModel

-(instancetype)init{
    
    if (self = [super init]) {
        //id是特殊类型，需要在这里声明一下
      [JULessonModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
       
          return @{
                   
                   @"ID" : @"id"
                   
                   };
          
          
      }];
        
        
    }
    return self;
    
}

//下载文件的存放路径

-(NSString *)destinationPath{
    
    
     NSString *cachesPath = NSSearchPathForDirectoriesInDomains(algorithmDowonloadMediaCachPath, NSUserDomainMask, YES)[0];
    
    NSString *lastpath = self.play_url.lastPathComponent;
    NSString *suffixPath = [NSString stringWithFormat:@"downloadVedio/%@/%@/%@/%@",JuuserInfo.uid,self.course_id,self.ID, lastpath];

    return [cachesPath stringByAppendingPathComponent:suffixPath];
    
}



-(NSString *)sourcePath{

    NSString *parentPath = [self.destinationPath stringByDeletingLastPathComponent];
    NSString *sourcePath = [parentPath stringByAppendingPathComponent:@"source11.m3u8"];
    
    return sourcePath;
        
}


//总时间

-(CGFloat)totalTime{
    
    JULog(@"%@", _duration);

    
    if (![_duration containsString:@":"]){
        return 0;
    }
    
    
    
    if (_totalTime == 0) {
       
      NSArray *array = [_duration componentsSeparatedByString:@":"];
        
        if (array.count == 2) {
            
            _totalTime = [array[0] intValue]*60+[array[1] intValue];

        }else{
            
            _totalTime = [array[0] integerValue] * 3600 + [array[1] intValue]*60+[array[2] intValue];
            
        }
        
    }
    
    return _totalTime;
    
}


-(BOOL)isPlayCompleted{
    
   

    
    
    if (self.totalTime - self.lessonModel.timeRecord <= 35) {
        
        return YES;
        
        
    }else{
        
        return NO;
    }
    
    
    
}


-(NSString *)perCentageString{
    
    
    if (!JuuserInfo.isLogin) {
        return @"0%";
    }
    
    
    

    NSString *string = [NSString stringWithFormat:@"%.0f%%", self.lessonModel.timeRecord *100 / self.totalTime];
    
    if ([string isEqualToString:@"-0%"]) {
        string = @"0%";
    }
    
    return string;
    
}



//删除某一视频
-(NSString *)deletelessonPath{
    
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(algorithmDowonloadMediaCachPath, NSUserDomainMask, YES)[0];
    

    NSString *suffixPath = [NSString stringWithFormat:@"downloadVedio/%@/%@/%@",JuuserInfo.uid,self.course_id,self.ID];
    
    return [cachesPath stringByAppendingPathComponent:suffixPath];

    
}


//某一个课程的路径
-(NSString *)courseDestinationPath{
    
    
    
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(algorithmDowonloadMediaCachPath, NSUserDomainMask, YES)[0];
    
    NSString *suffixPath = [NSString stringWithFormat:@"downloadVedio/%@/%@",JuuserInfo.uid,self.course_id];
    
    return [cachesPath stringByAppendingPathComponent:suffixPath];
    
    
    
}
////与.m3u8视频的播放有关
//@property(nonatomic, strong) NSString *documnetrootString;
//@property(nonatomic, strong) NSString *contentUrlString;



-(NSString *)documnetrootString{
    
     NSString *cachesPath = NSSearchPathForDirectoriesInDomains(algorithmDowonloadMediaCachPath, NSUserDomainMask, YES)[0];
    
    NSString *suffixPath = [NSString stringWithFormat:@"downloadVedio/%@",JuuserInfo.uid];
    
    return [cachesPath stringByAppendingPathComponent:suffixPath];
    

    
}

-(NSString *)contentUrlString{

        NSString *lastpath = self.play_url.lastPathComponent;
    NSString *contentUrlstring = [NSString stringWithFormat:@"http://127.0.0.1:9327/%@/%@/%@",self.course_id,self.ID,lastpath];
    
    return contentUrlstring;
}


//存入数据库的字段
-(NSString *)databaseUidUrl{
    NSString *uidDownloadurl = [NSString stringWithFormat:@"%@%@%@",JuuserInfo.uid,self.course_id,self.ID];

    return uidDownloadurl;
    
}

//课程对应的downloadinfo
-(JUDownloadInfo *)downloadInfo{
    
    if (!JuuserInfo.isLogin) {
        return nil;
    }
    
    

    
  JUDownloadInfo *info = [mydatabase findModelWithDownloadTable:self.databaseUidUrl];

    return info;
    
}


-(JULessonModel *)lessonModel{
    
    if (!JuuserInfo.isLogin) return self;
    JULessonModel *createLessonModel = [[JULessonModel alloc]init];
    createLessonModel.play_url = self.play_url;
    createLessonModel.ID = self.ID;
    JULessonModel *lessonModel = [lessonRecordDatabase getLessonModel:createLessonModel];
    return lessonModel;
}

-(BOOL)isM3u8Video{
    
    return ([self.play_url  containsString:@".m3u8"] || [self.play_url containsString:@".M3U8"]);
}

@end
