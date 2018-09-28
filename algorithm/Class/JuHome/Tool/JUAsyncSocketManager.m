//
//  JUAsyncSocketManager.m
//  selfSocket
//
//  Created by 周磊 on 17/4/13.
//  Copyright © 2017年 zhl. All rights reserved.
//
#ifdef DEBUG
#define JULog(...) NSLog(@"%s %d \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define JULog(...)
#endif
#import "JUAsyncSocketManager.h"
#import "GCDAsyncSocket.h"

@interface JUAsyncSocketManager ()<GCDAsyncSocketDelegate>
{
    NSString *_host;
    uint16_t _port;
    dispatch_queue_t _dq;
    NSInteger _connectCounter;

    
}

@property(nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign) JUAsyncSocketStatus ju_socketStatus;

@end
@implementation JUAsyncSocketManager
+ (instancetype)shareManager{
    
    static JUAsyncSocketManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
        manager.overtime = 1;
        manager.reconnectCount = 2;

        
    });
    return manager;
    
}


-(void)ju_connentToHost:(NSString *)host
              onPort:(uint16_t)port
       delegateQueue:(dispatch_queue_t)dq
             connect:(JUAsyncSocketConnectBlock)connect
             failure:(JUAsyncSocketFaileBlock)failure
         sendSuccess:(JUAsyncSocketSendSuccessBlock)send
         receiveData:(JUAsyncSocketReceiveBlock)receive{
    
    if (host)  _host = host;
    if (port)  _port = port;
    if (dq)  _dq = dq;
    
    _connectCounter = 0;
    self.connect = connect;
    self.failure = failure;
    self.send = send;
    self.receive = receive;
    
    if (self.isConnected) {
        return;
    }
    
    [self connectTohost:_host onPort:_port delegateQueue:dq];
}

//-(void)ju_sendSuccess:(JUAsyncSocketSendSuccessBlock)send receiveData:(JUAsyncSocketReceiveBlock)receive{
//    
//    self.send = send;
//    self.receive = receive;
//}

-(void)connectTohost:(NSString *)host onPort:(uint16_t)port delegateQueue:(dispatch_queue_t)queqe{
 
    if (host)  _host = host;
    if (port)  _port = port;
    if (queqe)  _dq = queqe;
    [self.socket disconnect];
    self.socket = nil;
    self.socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:_dq];
    
    NSError *error = nil;
    [self.socket connectToHost:_host onPort:_port error:&error];   
}
//包装一下，避免定时器传递多个参数崩溃
-(void)reconnectConnetToSerVer{
    [self connectTohost:nil onPort:0 delegateQueue:NULL];
}

-(void)ju_disconnect:(JUAsyncSocketDidCloseBlock)closeConnect{
    
    
    self.ju_socketStatus = JUAsyncSocketStatusClosedByUser;
    [self.socket disconnect];
    
    [self.timer invalidate];
    self.timer = nil;
    
}

-(void)ju_sendData:(id)message withTimeout:(NSTimeInterval)timeout tag:(long)tag sendSuccess:(JUAsyncSocketSendSuccessBlock)send receiveData:(JUAsyncSocketReceiveBlock)receive{
    if (self.isDisconnected) {
        JULog(@"连接已经断开");
        return;
    }
    
    
    self.send = send;
    self.receive = receive;
    NSData *data = nil;
    if ([message isKindOfClass:[NSData class]]) {
        data = message;
    }
    if ([message isKindOfClass:[NSString class]]) {
        
        data = [message dataUsingEncoding:NSUTF8StringEncoding];
    }
    if ([NSJSONSerialization isValidJSONObject:message]) {
        data = [NSJSONSerialization dataWithJSONObject:message options:NSJSONWritingPrettyPrinted error:nil];
    }
    if (!data) return;
    [self.socket writeData:data withTimeout:timeout tag:tag];
    
}

-(void)ju_reconnnect{
    _connectCounter = 0;
    [self reconnect];
}

-(void)reconnect{
    if (self.isConnected) {
        return;
    }
    
    if (_connectCounter < self.reconnectCount) {
        _connectCounter ++;
        
        JULog(@"第%zd次连接", _connectCounter);
     
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.overtime target:self selector:@selector(reconnectConnetToSerVer) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }else{
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
    
}
//是否断开

- (BOOL)isDisconnected{
    return [self.socket isDisconnected];
    
}

//是否连接
- (BOOL)isConnected{
    
    return [self.socket isConnected];
}





#pragma makr 代理方法

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    _connectCounter = 0;
    
    self.ju_socketStatus = JUAsyncSocketStatusConnected;
    
    
    if (self.connect) {
        self.connect();
    }
    
    JULog(@"连接主机成功");
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
    if(err){
        
        self.ju_socketStatus = JUAsyncSocketStatusClosedByServer;
        [self reconnect];
        JULog(@"断开连接 %@",err);
        
    }else{
        JULog(@"用户手动断开连接诶");
        
        self.ju_socketStatus = JUAsyncSocketStatusClosedByUser;
    }
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
//    JULog(@"数据成功发送到服务器");
    if (self.send) {
        self.send(tag);
    }
    
    //数据发送成功后，自己调用一下读取数据的方法，接着_socket才会调用下面的代理方法
    [self.socket readDataWithTimeout:-1 tag:tag];
}

#pragma mark 服务器有数据，会调用这个方法
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    // 从服务器接收到的数据
    NSString *recStr =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (self.receive) {
        self.receive(recStr, tag);
    }
    
//    JULog(@"收到服务器发送数据:   %@",recStr);
   
}







@end
