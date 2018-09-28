//
//  JUDownloader.m
//  archiviewroot
//
//  Created by 周磊 on 16/6/6.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUDownloader.h"
#import "JUDateBase.h"
//#import "JUDownloadConst.h"
#import "RegexKitLite.h"
#import "NSString+Extern.h"



@interface JUDownloader ()
@property(nonatomic, strong) NSString *url_string;
@property(nonatomic, strong) NSString *destination_path;
@property(nonatomic, strong) NSFileHandle *writeHandle;

@property(nonatomic, assign) NSInteger lastSize;
@property(nonatomic, assign) NSInteger growth;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) NSURLSession *session;
@property(nonatomic, strong) NSURLSessionDownloadTask *task;

@property(nonatomic, strong) NSArray *suffixArray;

//文件总大小缓存
@property (nonatomic,assign) long long fileTotallength;

//文件下载进度缓存
@property (nonatomic,assign) CGFloat fileprogress;


//m3u8文件的字符串
@property(nonatomic, strong) NSString *m3u8String;

/**
 *正在下载的m3u8文件片段数
 */
@property(nonatomic, assign) NSInteger partID;

/**
 *
 m3u8文件的下载总片段数目
 */

@property(nonatomic, assign) NSInteger allPartID;


//下载.m3u8文件的ts文件的url
@property(nonatomic, strong) NSString *m3u8TSUrlstring;

//储存.m3u8文件的路径
@property(nonatomic, strong) NSString *m3u8tsdestination;

@property(nonatomic, assign) BOOL isCancelTask;

//下载ts文件时，如果是下载新的片段就不发送通知，刚开始下载第一个片段时发送通知
@property(nonatomic, assign) BOOL isfirstPart;

//防止快速刷新

@property(nonatomic, strong) NSDate *previousDate;

@property(nonatomic, strong) NSDate *nowDate;

@property(nonatomic, assign) NSTimeInterval timeInterVal;


@end



@implementation JUDownloader


-(NSArray *)suffixArray{
    
    if (![_suffixArray count]) {
        
        NSString *str = [NSString stringWithContentsOfFile:self.destination_path encoding:NSUTF8StringEncoding error:nil];
        
        NSString *  parm = @"(?<=,\n).*\\.ts";
        
        _suffixArray = [str componentsMatchedByRegex:parm];
        
        
//        JULog(@"%@\n\n  %@", str, _suffixArray );
        
        
    }
    
    return _suffixArray;
}

//储存下载信息的类
-(JUDownloadInfo *)downloadInfo
{
    if (_downloadInfo == nil) {
        _downloadInfo = [[JUDownloadInfo alloc]init];
    }
    
    
    return _downloadInfo;
    
}

//先前的时间
-(NSDate *)previousDate{
    
    if (_previousDate == nil) {
        _previousDate = [NSDate date];
    }
    
    return _previousDate;
    
}
//现在的时间
-(NSDate *)nowDate{
    
    
    return [NSDate date];
}

-(NSTimeInterval)timeInterVal{
    
    NSTimeInterval interVal = [self.nowDate timeIntervalSinceDate:self.previousDate];
    
    
    if (interVal >= 1) {
       
        self.previousDate = self.nowDate;
        
    }
    
    return interVal;
}


//这是用户的uid和下载资源的url作为数据库的一个字段（确定某个用户下载的某个视频,因为所有用户的下载视频都存贮在同一个表中

//现在已经改为UID+CourseID+lessonID
-(NSString *)uidDownloadrul
{
    NSString *str = self.lessonModel.databaseUidUrl;
    
    
    return str;
    
}

//计算一次文件大小增加的部分尺寸
-(void)getGrowthSize
{

    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSInteger size = 0;
        
        if ([weakSelf.url_string hasSuffix:@".mp4"]) {
            
            
            
            size=[[[[NSFileManager defaultManager] attributesOfItemAtPath:_destination_path error:nil] objectForKey:NSFileSize] integerValue];
        }else{
            //获得上一级目录，因为要计算的是整个目录的文件大小
            NSString *path = [self.m3u8tsdestination stringByDeletingLastPathComponent];
            
            //获得文件的总大小
            size = [path fileSize];
            
            
        }
        
        //每3秒计算一次，所以要除以3得到美妙增长多少
        _growth = (size - _lastSize)/3;
        
        _lastSize = size;
        

    });
    
    
}

-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getGrowthSize) userInfo:nil repeats:YES];
        
//        [[NSRunLoop currentRunLoop] run];
    }
    return _timer;
}

-(instancetype)init
{
    if(self=[super init])
    {
        
        
    }
    return self;
}

/**
 * 获取对象的类方法
 */

/**
 *  断点下载
 *
 *  @param urlString        下载的链接
 *  @param destinationPath  下载的文件的保存路径
 *  @param  process         下载过程中回调的代码块，会多次调用
 *  @param  completion      下载完成回调的代码块
 *  @param  failure         下载失败的回调代码块
 */
-(void)downloadWithUrlString:(NSString *)urlString toPath:(NSString *)destinationPath process:(ProcessHandle)process completion:(CompletionHandle)completion failure:(FailureHandle)failure
{
    /**
     *  先取消之前的任务
     */
    


       [self timer];
    
    //因为如果文件夹之间有间隔时，就不能创建文件，所以先创建文件夹，再删除最后一个，就没有间隔了，
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:destinationPath]) {
        
        [fileManager createDirectoryAtPath:destinationPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager removeItemAtPath:destinationPath error:nil];
        
        if ([urlString hasSuffix:@".mp4"]) {
            [fileManager createFileAtPath:destinationPath contents:nil attributes:nil];
        }
    }
    
    
 NSInteger length=[[[fileManager attributesOfItemAtPath:destinationPath error:nil] objectForKey:NSFileSize] integerValue];
    
    if(urlString&&destinationPath)
    {
        _url_string=urlString;
        _destination_path=destinationPath;
        _process=process;
        _completion=completion;
        _failure=failure;
        
        if ([urlString hasSuffix:@".mp4"]) {
            NSURL *url=[NSURL URLWithString:urlString];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];

                NSString *rangeString=[NSString stringWithFormat:@"bytes=%ld-",(long)length];
                [request setValue:rangeString forHTTPHeaderField:@"Range"];
            
            dispatch_queue_t queue1 = dispatch_queue_create("xiazai", NULL);
            
            dispatch_async(queue1, ^{
                
                _con=[NSURLConnection connectionWithRequest:request delegate:self];
             
                [_con start];
                //开启运行循环
                [[NSRunLoop currentRunLoop] run];
            });
            
        }else if ([urlString hasSuffix:@".m3u8"]){
            //是第一个片段
            self.isfirstPart = YES;

            
//            JULog(@"%zd   %@", length, _lessonModel.ID);
            
            if (![fileManager fileExistsAtPath:destinationPath]) {//不存在.m3u8文件，重头开始下载
                    JULog(@"不存在.m3u8,重新下载");
                [self downloadFileOfm3u8WithUrlstring:urlString destinationpath:destinationPath];
                
                
                
                // 为了方便调试：
//                
//                if (DEBUG) {
//                    NSString *debugPath = [[destinationPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"11.txt"];
//                    NSString *content = [NSString stringWithFormat:@"couseID: %@ \n lessonID: %@ \n  name: %@", _lessonModel.course_id, _lessonModel.ID, _lessonModel.name];
//                    
//                    [content writeToFile:debugPath atomically:NSByteCountFormatterUseYBOrHigher encoding:NSUTF8StringEncoding error:nil];
//                    
//                }
                
           }else{//存在.m3u8文件，断点续传
               
           JULog(@"存在.m3u8,断点续传");
     
            [self m3u8DownloadTaskDidFinishDownloadingNotification:nil];
                
            }
            
        }
   
        
    }
}

/**
 *  取消下载
 */
-(void)cancel
{
    self.downloadInfo = self.lessonModel.downloadInfo;
    
    if (self.downloadInfo.downloadstatus == JUDownloadStateCompleted) {
        
        return;
    }
    self.downloadInfo.downloadstatus = JUDownloadStateSuspened;
    [mydatabase updateDownloadStatus:self.downloadInfo];
    [[NSNotificationCenter defaultCenter]postNotificationName:JUDownloadStateDidChangeNotification object:nil];
    
    [self.con cancel];
    self.con=nil;
    
    _isCancelTask = YES;
    
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}


/**
 * 获取上一次的下载进度
 */

#pragma mark 等会儿更正
-(float)lastProgress:(NSString *)url
{
    
    if (url) {

        JUDownloadInfo *downloadInfo = self.lessonModel.downloadInfo;
        self.downloadInfo = downloadInfo;
        float progress = self.downloadInfo.progress;
        return progress;
        
    }
    
    return 0;
    
}

/**获取文件已下载的大小和总大小,格式为:已经下载的大小/文件总大小,如：12.00M/100.00M
 */
-(NSString *)filesSize:(NSString *)url
{
//    NSString *str = [NSString stringWithFormat:@"%@%@", JuuserInfo.uid, url];

    self.downloadInfo = self.lessonModel.downloadInfo;
    long long totalLength = self.downloadInfo.totalLength;
    self.fileTotallength = totalLength;
    self.fileprogress = self.downloadInfo.progress;

    
    if(totalLength==0)
    {
        return @"0.00K/0.00K";
    }

    
    
    NSInteger currentLength=self.fileprogress*self.fileTotallength;
    
    NSString *currentSize=[self convertSize:currentLength];
    NSString *totalSize=[self convertSize:self.fileTotallength];
    
    
    return [NSString stringWithFormat:@"%@/%@",currentSize,totalSize];
    
}

-(NSString *)convertSize:(long long)length
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
#pragma mark - NSURLConnection
/**
 * 下载失败
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    if(_failure)
        _failure(error);
    
}


/**
 * 接收到响应请求
 */
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
       //拿到当前请求的url转换为字符串
   NSString *urlstring  = [connection.currentRequest.URL description];
//   NSLog(@"------%@:%@",@"开始任务", urlstring);

    self.downloadInfo = self.lessonModel.downloadInfo;
    if (self.downloadInfo.downloadstatus == JUDownloadStateCompleted){
        return;
    }
    

    if ([urlstring hasSuffix:@".mp4"]) {
        
        self.downloadInfo.downloadstatus = JUDownloadStateResumed;
        //更新下载状态，到这一步，表示开始下载
        [mydatabase updateDownloadStatus:self.downloadInfo];
        [[NSNotificationCenter defaultCenter]postNotificationName:JUDownloadStateDidChangeNotification object:nil];
        


        //没有查到
        if (self.downloadInfo.totalLength == 0) {
            
            //将文件的总长度,存贮在数据库
            JUDownloadInfo *downloadInfo = self.downloadInfo;
            
            downloadInfo.totalLength = (long long)response.expectedContentLength;
           
           
            [mydatabase updateSizeofile:downloadInfo];
            
            
            
        }
        
        _writeHandle=[NSFileHandle fileHandleForWritingAtPath:_destination_path];
        

        
    }else if([self.m3u8TSUrlstring containsString:@".ts"]){
       
        
     
        if (self.isfirstPart) {//是第一个片段，发送通知
            self.downloadInfo.downloadstatus = JUDownloadStateResumed;
            //更新下载状态，到这一步，表示开始下载
            [mydatabase updateDownloadStatus:self.downloadInfo];

            
            [[NSNotificationCenter defaultCenter]postNotificationName:JUDownloadStateDidChangeNotification object:nil];
            
            //之后就不是第一个片段
            self.isfirstPart = NO;

            
        }
        if (self.downloadInfo.totalLength == 0) {//当这个片段下载完成后，将总长度改为0，下一次下载使用(下载成功后更改)
            
            //将文件的总长度,存贮在数据库
            JUDownloadInfo *downloadInfo = self.downloadInfo;
            
            downloadInfo.totalLength = (int)response.expectedContentLength;
            
            [mydatabase updateSizeofile:downloadInfo];
            
        }
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        BOOL fileExist=[fileManager fileExistsAtPath:self.m3u8tsdestination];
        if(!fileExist){
            [fileManager createFileAtPath:self.m3u8tsdestination contents:nil attributes:nil];
            
        }
        _writeHandle=[NSFileHandle fileHandleForWritingAtPath:self.m3u8tsdestination];

        
    }
    
    
}
/**
 * 下载过程，会多次调用
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{


    NSString *urlstring  = [connection.currentRequest.URL description];
    
    
    if ([urlstring hasSuffix:@".mp4"]) {
        [_writeHandle seekToEndOfFile];
        [_writeHandle writeData:data];
        
        if (self.timeInterVal < 1.0)return;
            
            
        NSInteger length=[[[[NSFileManager defaultManager] attributesOfItemAtPath:_destination_path error:nil] objectForKey:NSFileSize] integerValue];
        
        //将文件的总大小缓存起来用
        self.downloadInfo = self.lessonModel.downloadInfo;
        long long totalLength = self.downloadInfo.totalLength;
            //计算下载进度,并存贮在数据库
        float progress=(float)length/totalLength;
        self.downloadInfo.progress = progress;
        [mydatabase updateDownloadTable:self.downloadInfo];
        //获取文件大小，格式为：格式为:已经下载的大小/文件总大小,如：12.00M/100.00M
        

        
        NSString *sizeString=[self filesSize:_url_string];
        //计算网速
        NSString *speedString=@"0.00Kb/s";
        NSString *growString=[self convertSize:_growth];
        
        speedString=[NSString stringWithFormat:@"%@/s",growString];
        
        growString = [NSString stringWithFormat:@"%.6f",(_growth/1024.0/1024)];
        
        
//        NSLog(@"%@  %@", speedString, growString);

        //回调下载过程中的代码块
        if(_process){

            _process(progress,sizeString,growString);
        
        }
        
    }else if([self.m3u8TSUrlstring containsString:@".ts"]){
        [_writeHandle seekToEndOfFile];
        [_writeHandle writeData:data];

        if (self.timeInterVal < 1.0)return;
        NSInteger length=[[[[NSFileManager defaultManager] attributesOfItemAtPath:_m3u8tsdestination error:nil] objectForKey:NSFileSize] integerValue];


        //将文件的总大小缓存起来用
        self.downloadInfo = self.lessonModel.downloadInfo;

        
        long long totalLength = self.downloadInfo.totalLength;
        //计算下载进度,并存贮在数据库
        float progress=(float)length/totalLength;
        self.downloadInfo.progress = progress;
        [mydatabase updateDownloadTable:self.downloadInfo];

        
        //在这儿不能得到sizetring，因为不知道总文件的大小，可以算出但是很麻烦，就用后台告诉的吧，文件总大小*下载进度
        //计算网速
        NSString *speedString=@"0.00Kb/s";
        NSString *growString=[self convertSize:_growth];
        
        //因为要计算多长时间，还是传递一个网速过去吧  单位是M
        
        
        speedString=[NSString stringWithFormat:@"%@/s",growString];
        
        growString = [NSString stringWithFormat:@"%.6f",(_growth/1024.0/1024)];

         float totalProgress = (progress+self.partID)/self.allPartID ;
        
        
//        NSLog(@"------%lf-----allpartID: %lu-----partID: %lu", progress,self.allPartID, self.partID);
        //回调下载过程中的代码块
        
//    JULog(@"***********%f***********%d***********%d***********",progress,self.partID, self.allPartID);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_process)
                _process(totalProgress,@"00/00",growString);
            
        });
        

        
        
    }else{
        
    }
    
    
    
   }
/**
 * 下载完成
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //拿到当前请求的url转换为字符串
    NSString *urlstring  = [connection.currentRequest.URL description];
    
    
    if ([urlstring hasSuffix:@".mp4"]) {
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:JuDownloadTaskDidFinishDownloadingNotification object:nil userInfo:@{@"urlString":_url_string, @"MajorKey":self.lessonModel.databaseUidUrl}];
        if(_completion)
            _completion();
        
        [_timer invalidate];
        
    }else if([urlstring containsString:@".ts"]){//176.m3u8.0.ts,  这儿不能写有后缀
//        NSLog(@"----任务成功: %@", urlstring);
        //下载成功后，更新片段数
        self.partID = self.partID + 1;
        
        self.downloadInfo =self.lessonModel.downloadInfo;
        JUDownloadInfo *downloadinfo = self.downloadInfo;
        downloadinfo.partID = self.partID;
        [mydatabase updatepartIdAndAllPartID:downloadinfo];
        
        
        //将下载进度更改为0,因为下一个片段下载时初始值为0
        downloadinfo.totalLength = 0;
        [mydatabase updateSizeofile:downloadinfo];
        
        if (self.partID >= self.allPartID) {
//            NSLog(@"文件全部下载成功");
            
            _process(1,@"00/00",@"0kb");
            
            //向通知中心发送消息，
     [[NSNotificationCenter defaultCenter] postNotificationName:JuDownloadTaskDidFinishDownloadingNotification object:nil userInfo:@{@"MajorKey":self.lessonModel.databaseUidUrl,@"urlString":_url_string}];
            
            if(_completion){
                _completion();
            }
            
            [_timer invalidate];
            
        }
   
        
    }else{
        
        
    }
    
    
}

//下载.m3u8文件,因为是小文件，没必要用NSurlconnection
-(void)downloadFileOfm3u8WithUrlstring:(NSString *)urlstring destinationpath:(NSString *)destinationpath{
    
//    NSLog(@"%@", [NSThread currentThread]);
    JULog(@"%@   %@",[NSThread currentThread],@"开始下载m3u8文件");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:urlstring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
      dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
        NSURLSessionDataTask *ttask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           
            if (data) {
                
              JULog(@"下载m3u8文件---------------%@--",[NSThread currentThread]);
                [data writeToFile:destinationpath atomically:YES];
                dispatch_semaphore_signal(sem);
            }
        }];
    
    [ttask resume];
    
     dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    [self m3u8DownloadTaskDidFinishDownloadingNotification:nil];
        
}

#pragma mark 接受到m3u8文件下载完成后执行的方法

-(void)m3u8DownloadTaskDidFinishDownloadingNotification:(NSNotification *)notification{
    
    dispatch_queue_t queue1 = dispatch_queue_create("sssss", NULL);

    dispatch_async(queue1, ^{

        //处理.m3u8文件，然后下载.ts文件
        NSString *m3u8string = [NSString stringWithContentsOfFile:self.destination_path encoding:NSUTF8StringEncoding error:nil];
        self.m3u8String = m3u8string;
        //将.ts文件的总片段数更新数据库
        JUDownloadInfo *downloadInfo = self.lessonModel.downloadInfo;
        if (downloadInfo.allPartID == 0) {//总片段数为0,说明m3u8文件没下载过也没有经过处理
            
            //第一次下载要对m3u8文件进行一些处理
            [self dealWithM3u8];
            
            
            self.partID = -1;
            downloadInfo.allPartID = self.allPartID; //更改总片段数
            downloadInfo.partID = self.partID;//-1代表还没有开始下载
            
            [mydatabase updatepartIdAndAllPartID:downloadInfo];
            
            
        }else{//断点续传，此时.m3u8文件已经处理过了，总片段数不为0
            
            //获得此时下载的片段数和总片段数
            self.downloadInfo = downloadInfo;
            self.allPartID = self.downloadInfo.allPartID;
            self.partID = self.downloadInfo.partID;
        }
        JULog(@"%zd         %zd", self.partID, self.allPartID);
        
        //    //下载.ts文件
        while (self.partID < self.allPartID) {
            if (_partID == -1) {//因为下载的第一个片段为0
                self.partID = 0;
                JUDownloadInfo *downloadinfo = self.lessonModel.downloadInfo;
                downloadinfo.partID = 0;
                [mydatabase updatepartIdAndAllPartID:downloadinfo];
            }
            
            //这个用于判断.m3u8文件的暂停，否则只能取消本次片段，下个片段任然可以下载,直接return可以暂停整个下载文件
            if (_isCancelTask == YES) {
                return;
            }
            
            NSURL *url=[NSURL URLWithString:self.m3u8TSUrlstring];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
            NSFileManager *fileManager=[NSFileManager defaultManager];
            BOOL fileExist=[fileManager fileExistsAtPath:self.m3u8tsdestination];
            if(fileExist)
            {
                NSInteger length=[[[fileManager attributesOfItemAtPath:self.m3u8tsdestination error:nil] objectForKey:NSFileSize] integerValue];
                NSString *rangeString=[NSString stringWithFormat:@"bytes=%ld-",(long)length];
                [request setValue:rangeString forHTTPHeaderField:@"Range"];
                //如果存在就删除那个片段重新下载
                //            [fileManager removeItemAtPath:self.m3u8tsdestination error:nil];
                
            }
            // 如果将代理回调设置到非主线程中,会开启多条线程下载任务!
            // 如果不设置这个属性,会在单条线程中下载! 慢!
            _con=[NSURLConnection connectionWithRequest:request delegate:self];
            
            //如果有bug，把这句话注释掉
//              [_con setDelegateQueue:[[NSOperationQueue alloc]init]];
            
            [_con start];
            
            [[NSRunLoop currentRunLoop]run];

            //更新到数据库
        }

    });
    
}

//是否是新样式的m3u8文件
- (BOOL)isNewM3u8{
    // 156_-1_0.ts?x-bce-range=951104-1287631
    //旧的格式含有range,以此作为判别,如果包含有，则数组的个数大于0
    NSArray *array = [self.m3u8String componentsMatchedByRegex:@"\\.ts\\?x-bce-range=\\d{1,11}-\\d{1,11}"];
    
    if (array.count == 0) {
        //新样式
        return YES;
    }
    //旧样式
    return NO;
}
//m3u8文件的处理，处理的母的 1.旧的m3u8中内容有重复,需要删除一些 2.获得总的片段数
-(void)dealWithM3u8{
    if ([self isNewM3u8]) { //新的m3u8格式
        
        //匹配类似144.m3u8.452.ts这种格式，但是只提取452
        //        NSArray *array = [self.m3u8String componentsMatchedByRegex:@"(?<=[a-zA-Z0-9]{1,5}\\.m3u8\\.)\\d{1,5}(?=\\.ts)"];
//        NSArray *array = [self.m3u8String componentsMatchedByRegex:@"\\d{1,}(?=\\.ts)"];
//        
//        self.allPartID = [[array lastObject] intValue] - [[array firstObject] intValue] +1;
        
        [self.m3u8String writeToFile:self.lessonModel.sourcePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        //装换规则
        /*
         装换为
         #EXTINF:12,
         http://v2.julyedu.com/ts/4ac25e8f/b32739f9/9f93723b.m3u8.0.ts
         #EXTINF:12,
         http://v2.julyedu.com/ts/4ac25e8f/b32739f9/9f93723b.m3u8.1.ts
         #EXTINF:12,
         http://v2.julyedu.com/ts/4ac25e8f/b32739f9/9f93723b.m3u8.2.ts
         #EXTINF:14,
         
         转换为
         #EXTINF:12,
         9f93723b.m3u8.0.ts
         #EXTINF:12,
         9f93723b.m3u8.1.ts
         #EXTINF:12,
         9f93723b.m3u8.2.ts
         
         */

        NSString *parm = @",\nhttp.*/(?=.*\\.ts)";
        NSString *string  = [self.m3u8String stringByReplacingOccurrencesOfRegex:parm withString:@",\n"];
        [string writeToFile:self.destination_path atomically:YES encoding:NSUTF8StringEncoding error:nil];

        parm = @"(?<=,\n).*\\.ts";
        self.suffixArray = [string componentsMatchedByRegex:parm];
        
        self.allPartID = [self.suffixArray count];
        
     //旧的m3u8文件格式处理
    }else{
        //旧版
        NSArray *array = [self.m3u8String componentsMatchedByRegex:@"\\d{1,4}+(?=\\.ts)"];
        self.allPartID = [[array lastObject] intValue]+1;
        //修改m3u8文件，去重复，片段文件数组
        NSArray *tsArray = [self.m3u8String componentsSeparatedByString:@",\n"];
        
        //        NSLog(@"%@",array);
        
        //muArray1 放重复的地方 ，muArray2放整个文件
        NSMutableArray *muArray1 = [NSMutableArray array];
        NSMutableArray *muArray2 = [NSMutableArray array];
        for (NSString *str in tsArray) {
            NSString *key = [str substringToIndex:[str rangeOfString:@"?"].location];
            if (![muArray1 containsObject:key]) {
                [muArray1 addObject:key];
                [muArray2 addObject:str];
            }
        }

        /**
         *  最终得到的字符串
         */
        NSString *needString = [muArray2 componentsJoinedByString:@",\n"];
    
        needString =[needString stringByReplacingOccurrencesOfRegex:@"(?<=EXTINF:)10" withString:@"60"];
        //加上m3u8结束标识，，还有点东西没删不知道有没有影响
        needString = [needString stringByAppendingString:@"\n#EXT-X-ENDLIST\n"];
        
        
        NSError *error = nil;
        [needString writeToFile:self.destination_path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            JULog(@"错误：%@", error);
            
            return;
        }
    }
    
     
    
}

//下载.m3u8文件的ts文件的url
//下载.m3u8文件的ts文件的url
-(NSString *)m3u8TSUrlstring{
    
    NSString *tsString = nil;
    if ([self.url_string hasSuffix:@".m3u8"]) {
        
        if ([self isNewM3u8]) {
            /*
             
             //老版本
             //           m3u8地址    http://v2.julyedu.com/ts/df0bf7e9/5628e31e/1339046c.m3u8
             //            ts地址      http://v2.julyedu.com/ts/df0bf7e9/5628e31e/1339046c.m3u8.0.ts
             
             
             NSString *appendstring = [NSString stringWithFormat:@".%lu.ts", (long)_partID];
             tsString  = [self.url_string stringByAppendingString:appendstring];
             //设置下载文件的存放路径
             self.m3u8tsdestination = [NSString stringWithFormat:@"%@%@",self.destination_path,appendstring];
             */
            
            
            
            
            //新版本兼容老版本
            //最新版本  注意：最新版本从1开始 有占位0，而且有-，但是，老版本从0开始
            // m3u8地址     http://v3.julyedu.com/video/61/504/dd2f1cbc0f.m3u8
            
            // ts   地址     http://v3.julyedu.com/video/61/504/dd2f1cbc0f-00001.ts
            
            NSString *hrefString = [self.url_string stringByDeletingLastPathComponent];
            
            //            JULog(@"%@", self.suffixArray);
            
            NSString *sufString = self.suffixArray[_partID];
            
            tsString = [hrefString stringByAppendingPathComponent:sufString];
            
            //            JULog(@"%zd  %@  ", _partID,  tsString);
            
            NSString *lessonRootPath = [self.destination_path stringByDeletingLastPathComponent];
            
            self.m3u8tsdestination = [lessonRootPath stringByAppendingPathComponent:sufString];
            
            
            
            
        }else{
            
            tsString  = [self.url_string stringByReplacingOccurrencesOfString:@".m3u8" withString:[NSString stringWithFormat:@"_-1_%lu.ts",(long)_partID]];
            
            //设置下载文件的存放路径
            
            self.m3u8tsdestination = [self.destination_path stringByReplacingOccurrencesOfString:@".m3u8" withString:[NSString stringWithFormat:@"_-1_%lu.ts",(long)_partID]];
            
            
        }
        
        
        
    }
    return tsString;//下载  .ts 片段文件
    
}



#pragma dealloc
-(void)dealloc{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.process = nil;
    self.con = nil;
    self.downloadInfo = nil;
  
    [_timer invalidate];
    _timer = nil;
    
    JULog(@"****************销毁下载的类**********************");
    
    
}

@end
