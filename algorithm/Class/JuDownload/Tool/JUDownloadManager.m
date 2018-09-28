//
//  JUDownloadManager.m
//  archiviewroot
//
//  Created by pro on 16/6/6.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUDownloadManager.h"
#import "JUDateBase.h"
#import "JUDetectNetworkingTool.h"
#import <AVFoundation/AVFoundation.h>



@interface JUDownloadManager ()
@property(nonatomic, strong) NSMutableDictionary *taskDict;

/**
 *  排队队列
 */

@property(nonatomic, strong) NSMutableArray *queue;

@property(nonatomic, strong) AVAudioPlayer  *audioPlayer;


@property(nonatomic, strong) NSTimer *timer;
//后台定时器

@end

@implementation JUDownloadManager
{

/**
 *  后台进程id
 */
UIBackgroundTaskIdentifier  _backgroudTaskId;

}

-(NSInteger)downloadingCount{
    return [_taskDict count];
    
}


-(instancetype)init
{

    if (self = [super init]) {
        
        
        //正在下载的个数
        _taskDict = [NSMutableDictionary dictionary];
        
        //等待下载的队列
        _queue = [NSMutableArray array];
        
        /**
         *  注册程序下载完成的通知
         */
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadTaskDidFinishDownloadingNotification:) name:JuDownloadTaskDidFinishDownloadingNotification object:nil];
        if ([JuuserInfo.showstring isEqualToString:@"1"]) {
            //注册程序即将失去焦点的通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadTaskWillResign:) name:UIApplicationWillResignActiveNotification object:nil];
            //注册程序获得焦点的通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadTaskDidBecomActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
            
            
            //程序进入后台的通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadTaskDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
            
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setCategory:AVAudioSessionCategoryPlayback error:nil];
            
            //激活后台任务
            [session setActive:YES error:nil];
        }
        
   
    }
    
    return self;
    
}

+(instancetype)shredManager{
    
    
    static dispatch_once_t onceToken;
    static JUDownloadManager *mgr = nil;
    dispatch_once(&onceToken, ^{
        mgr = [[JUDownloadManager alloc]init];
        
//    [mydatabase createTableWithDownload];
        
    });
    
    return mgr;
    
}

-(void)downloadWithUrlString:(NSString *)urlString
                      toPath:(NSString *)destinationPath
                     process:(ProcessHandle)process
                  completion:(CompletionHandle)completion
                     failure:(FailureHandle)failure
                 lessonModel:(JULessonModel *)lessonModel;
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
        //如果没有网路，返回
        if (networkingType == NotReachable) {
            
            GMToast *toast = [[GMToast alloc]initWithView:keywindow  text:@"请检查你的网络" duration:1.5];
            [toast show];
            
            return;
        }
        //如果没有网路，返回
        
        if (JuuserInfo.isLogin == NO) {
            
            GMToast *toast = [[GMToast alloc]initWithView:keywindow  text:@"请登录之后下载" duration:1.5];
            [toast show];
            
            return;
        }
        
        //下载任务时，创建一个表，用来存贮下载进度等信息
        //储存下载信息
        JUDownloadInfo *downloadInfo = [[JUDownloadInfo alloc]init];
        downloadInfo.destinationPath = destinationPath;
        downloadInfo.urlString = urlString;
        
        
        //主键，只能存一次,
        downloadInfo.downloadURL = lessonModel.databaseUidUrl;
        downloadInfo.partID = -1; //以后查询没有下载的就是 part=-1andprogress等于0
        downloadInfo.allPartID = 0;
        
        //加入队列，表示等待下载
        downloadInfo.downloadstatus = JUDownloadStateWillResume;
        
#pragma mark 以后数据库扩充就加入这个model中吧，有时间的话就改一下吧，以后应该直接把lessonmodel存储进去（不知道效率会不会变低，因为数据库访问很频繁）
        downloadInfo.lessonModel = lessonModel;
        downloadInfo.user_id = JuuserInfo.uid;
        
        
        [mydatabase addDownloadData:downloadInfo];
        [[NSNotificationCenter defaultCenter]postNotificationName:JUDownloadStateDidChangeNotification object:nil];
        
        //若同时下载的任务数超过最大同时下载任务数，
        //则把下载任务存入对列，在下载完成后，自动进入下载。
        
        if (_taskDict.count >= KFJUDownloadMaxTaskCount) {
            
            NSDictionary *dict=@{@"urlString":urlString,
                                 @"destinationPath":destinationPath,
                                 @"process":process,
                                 @"completion":completion,
                                 @"failure":failure,
                                 @"lessonModel":lessonModel
                                 };
            [_queue addObject:dict];
            
            return;
            
        }
        
        JUDownloader *downloader = [[JUDownloader alloc]init];
        downloader.lessonModel = lessonModel;
        [_taskDict setObject:downloader forKey:urlString];
        [downloader downloadWithUrlString:urlString
                                   toPath:destinationPath
                                  process:process
                               completion:completion
                                  failure:failure];
        
        
        
        
        self.downloader = nil;
        self.downloader = downloader;
        
        if (urlString) {
            
            self.downloadingUrlstring = urlString;
        }

        
    });
}


/**
 *  取消下载任务
 *
 *  @param url 下载的链接
 */
-(void)cancelDownloadTask:(NSString *)url
{
    //下载暂停之后， 正在下载的url为空
    JUDownloader *downloader=[_taskDict objectForKey:url];
    [downloader cancel];
    if (self.downloader == downloader) {
        self.downloader = nil;
    }
    
    
    if (url) {
            [_taskDict removeObjectForKey:url];
    }
    
}



//传入下载文件的url和存放地址
-(void)removeForUrl:(NSString *)url file:(NSString *)path lessonModel:(JULessonModel *)lessonModel {
    
    JULessonModel *model = nil;

    //删除视频时，更改记录用户行为的数据库的视频为未播放
    
    if (lessonModel) {
        model = lessonModel;
    }else{
        
        model = [[JULessonModel alloc]init];
        model.play_url = url;
    }
    
    JULessonModel *returnModel = [lessonRecordDatabase getLessonModel:model];
    returnModel.isPlayed = NO;
    
    if (returnModel) {
        [lessonRecordDatabase updateLessonModel:returnModel];

    }
    
    
//    JULog(@"%@-----", returnModel.databaseUidUrl);
    
    //删除正在下载
    [self cancelDownloadTask:url];
    
    
    //删除排队的
    [self cancelWaittingTask:url];
    
    NSString *downloadURL = lessonModel.databaseUidUrl;
    
    if (!lessonModel) {
        downloadURL = returnModel.databaseUidUrl;
    }
    
    //删除数据库
    [mydatabase deleteDownloadTable:downloadURL];
    
    //返回上一级目录
    NSString *pathstring = [path stringByDeletingLastPathComponent];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL fileExist=[fileManager fileExistsAtPath:pathstring];
    if(fileExist){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [fileManager removeItemAtPath:path error:nil];
        });
    }
    
    //如果彻底删除的是正在下载的，从队列取出一个下载
    if ([self.downloadingUrlstring isEqualToString:url]) {
        [self downloadTaskFromWaitingTsaks];
    }
    //删除信息时发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:JUDidDeletedownloadedVides object:nil];
    //如果 一段时间后没有下载的任务，查看数据库，找出暂停的任务下载
 
    [self downloadTaskFromdataBases];
    [self deleteCashes];
    
}

//删除垃圾文件
-(void)deleteCashes{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                   dispatch_get_global_queue(0, 0), ^{
                       
                           if (_taskDict.count || _queue.count) return;
                       
                       NSFileManager *manager = [NSFileManager defaultManager];
                       NSString *cachesPath = NSSearchPathForDirectoriesInDomains(algorithmDowonloadMediaCachPath, NSUserDomainMask, YES)[0];
                       cachesPath = [NSString stringWithFormat:@"%@/com.july.edu.algorithm/fsCachedData", cachesPath];
                       [manager removeItemAtPath:cachesPath error:nil];
                       [manager createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:nil];
//                       JULog(@"%@", cachesPath);

                   });
    
}


-(void)cancelAllTasks
{
    __weak typeof(self) weakSelf = self;
    [_taskDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        JUDownloader *downloader=obj;
        
        [downloader cancel];
        
        if (downloader == weakSelf.downloader) {
            
            weakSelf.downloader = nil;
        }
        
    }];
    
    [_taskDict removeAllObjects];
    
}

-(float)lastProgress:(NSString *)url
{
    JUDownloader *downloader = [[JUDownloader alloc]init];
    return [downloader lastProgress:url];
}
-(NSString *)filesSize:(NSString *)url
{
    JUDownloader *downloader = [[JUDownloader alloc]init];

    return [downloader filesSize:url];
}

#pragma mark 通知方法
//完成下载时执行的方法
-(void)downloadTaskDidFinishDownloadingNotification:(NSNotification *)notifi{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *urlString=[notifi.userInfo objectForKey:@"urlString"];

        //下载完成后，从任务列表中移除下载任务，若总任务数小于最大同时下载任务数，
        //则从排队对列中取出一个任务，进入下载
        NSString *MajorKey =[notifi.userInfo objectForKey:@"MajorKey"];
        
        //下载完成后，更新下载状态
        
  
        JUDownloadInfo *downloadinfo = [mydatabase findModelWithDownloadTable:MajorKey];
        
        if (downloadinfo.downloadstatus == JUDownloadStateCompleted) {
            
            return;
        }
        
        downloadinfo.downloadstatus = JUDownloadStateCompleted;
        [mydatabase updateDownloadStatus:downloadinfo];
        
        self.downloader = nil;
     
        JULog(@"已经下载完成 %@ ------", downloadinfo.lessonModel.ID);
        NSLog(@"清除前： 正在下载： %zd  队列个数： %zd", _taskDict.count, _queue.count);

        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:JUDownloadStateDidChangeNotification object:nil];
        [_taskDict removeObjectForKey:urlString];
        
        NSLog(@"清除后  正在下载： %zd  队列个数： %zd\n\n\n\n", _taskDict.count, _queue.count);
        
        if(_taskDict.count<KFJUDownloadMaxTaskCount){
            
            
            
            if(_queue.count>0){
                NSDictionary *first=[_queue objectAtIndex:0];
                //从排队对列中移除一个下载任务
                [_queue removeObjectAtIndex:0];
                
                    [self downloadWithUrlString:first[@"urlString"]
                                         toPath:first[@"destinationPath"]
                                        process:first[@"process"]
                                     completion:first[@"completion"]
                                        failure:first[@"failure"]
                                    lessonModel:first[@"lessonModel"]
                     ];
                    //因为lessonmodel之前已经存贮到数据库了，传空就可以
//
                JULessonModel *lessonModel = first[@"lessonModel"];
                NSLog(@" 开始下载新的视频: %@ %@",lessonModel.ID, lessonModel.course_id);
             
                return;

            }
        }
        
        
        
        [self downloadTaskFromdataBases];
        
        [self deleteCashes];
    });
}
//取消等待的任务
-(void)cancelWaittingTask:(NSString *)urlstring{
    
    for (NSDictionary *dict in _queue) {
        
        if ([dict[@"urlString"] isEqualToString:urlstring]) {
            
            
            // 等待的任务数据库在前面调用时，已经删除了，这儿不需要删除
            
            //删除数据库（应该删除downloadurl)
//            NSString *downloadURL = [NSString stringWithFormat:@"%@%@",JuuserInfo.uid,urlstring];
//            [mydatabase deleteDownloadTable:downloadURL];
            
            //            JULog(@"取消缓存任务 %lu",(unsigned long)_queue.count);
            
            [_queue removeObject:dict];
            
            //发送信息刷新UI
            [[NSNotificationCenter defaultCenter]postNotificationName:JUDownloadStateDidChangeNotification object:nil];
            
            break;
        }
    }
}
//从队列中取出一个下载： 当任务正在下载时，点击这个按钮让任务取消，需要从缓存任务中取出一个下载
-(void)downloadTaskFromWaitingTsaks{
    
    
    if(_taskDict.count<KFJUDownloadMaxTaskCount){
        
        if(_queue.count>0){
            
            NSDictionary *first=[_queue objectAtIndex:0];
            //从排队对列中移除一个下载任务
            [_queue removeObjectAtIndex:0];
            [self downloadWithUrlString:first[@"urlString"]
                                 toPath:first[@"destinationPath"]
                                process:first[@"process"]
                             completion:first[@"completion"]
                                failure:first[@"failure"]
                            lessonModel:first[@"lessonModel"]
             ];

        }
    }

}

// 当没有下载任务时，从数据库中查看，如果有的话，就下载

-(void)downloadTaskFromdataBases{
    //如果下载队列或等待队列有值，就直接返回
    if (_taskDict.count || _queue.count) return;
    
    if (networkingType == ReachableViaWWAN || networkingType == NotReachable) {
        return;
    }
    
    
    //如果没有可供下载的队列，直接返回
    NSMutableArray *pauseDownloadedArray = [mydatabase findModelWithDownloading];
    if (!pauseDownloadedArray.count)return;
    
    
    JUDownloadInfo *downloadInfo = [pauseDownloadedArray firstObject];
    JULessonModel *lessonModel = downloadInfo.lessonModel;
    
    NSLog(@"正在暂停的任务取出下载: %@ %@",lessonModel.ID, lessonModel.course_id);

    
    [self downloadWithUrlString:lessonModel.play_url toPath:lessonModel.destinationPath process:^(float progress, NSString *sizeString, NSString *speedString) {
        
        
    } completion:^{
        
        
    } failure:^(NSError *error) {
        
        
    } lessonModel:lessonModel];

    
}




//程序将要退出
-(void)downloadTaskWillBeTerminate:(NSNotification *)notifi{
   
//    if (self.queue.count) {
//        
//        [self.queue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSDictionary *dic = obj;
//            NSString *urlstring = dic[@"urlString"];
//            NSString *downloadUidurl = [NSString stringWithFormat:@"%@%@",JuuserInfo.uid,urlstring];
//            
//            JUDownloadInfo *downloadinfo = [mydatabase findModelWithDownloadTable:downloadUidurl];
//            downloadinfo.downloadstatus = JUDownloadStateSuspened;
//            
//            [mydatabase updateDownloadStatus:downloadinfo];
//            
//            
//        }];
//    }
    
    
    
    self.queue = [NSMutableArray array];
    
    [[JUDownloadManager shredManager] cancelAllTasks];

}


#pragma mark 设置后台音乐播放













-(NSTimer *)timer{

    if (!_timer) {

        _timer = [NSTimer timerWithTimeInterval:600 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];


        JULog(@"%@",[NSThread currentThread]);

        }


    return _timer;

}



-(void)playMsic{
    
    JUlogFunction
    
    NSURL *fileUrl = [[NSBundle mainBundle]URLForResource:@"silent.mp3" withExtension:nil];
    
    if (fileUrl == nil) return;
    
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:nil];
    
    [self.audioPlayer setNumberOfLoops:-1];
    
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
     
}

#pragma makr 通知
/**
 *  收到程序即将失去焦点的通知，播放音乐，因为测试时在后台不能播放
 *
 *  @param sender 通知
 */
-(void)downloadTaskWillResign:(NSNotification *)sender{
    
    //如果不是wife， 或者没有网络， 就不进行后台下载
    
    if (networkingType != ReachableViaWiFi || networkingType == NotReachable) {
        
        return;
        
    }
    //开启定时器，后台任务提完成时可以提前结束后台任务
    [self timer];
    
    
    //后台任务
    [self playMsic];
    
    
    JULog(@"即将进入后台，播放音乐");

}

//程序已经进入后台

-(void)downloadTaskDidEnterBackground:(NSNotification *)sender{
    
    JULog(@"已经进入后台");
    __weak typeof(self) weakSelf = self;
    //开启后台任务
    _backgroudTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        JULog(@"后台任务已经完成，可以结束任务了");
        
        [weakSelf endTask];
        
    }];
    
}

/**
 *  收到程序重新得到焦点的通知，关闭后台
 *
 *  @param sender 通知
 */
-(void)downloadTaskDidBecomActive:(NSNotification *)sender{
    
    [self endTask];
}

//结束后台
-(void)endTask{
    
    if(_backgroudTaskId!=UIBackgroundTaskInvalid){
        
        [[UIApplication sharedApplication] endBackgroundTask:_backgroudTaskId];
        
        _backgroudTaskId=UIBackgroundTaskInvalid;
        
        
        self.audioPlayer = nil;
        
        [self.timer invalidate];
        self.timer = nil;
        JULog(@"后台任务已经结束关闭");
    
    }
 
    
    
}

-(void)timerAction{
    
    JULog(@"hhhh  %zd", _taskDict.count);
    
    // 下载一段时间后，如果不是wife,接结束任务
    
    if (networkingType != ReachableViaWiFi) {
        
          [self endTask];
        
    }
    
    
    
    
    
    if (_taskDict.count == 0) {
        
        [self endTask];
        
    }
    
    
}




-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}












@end
