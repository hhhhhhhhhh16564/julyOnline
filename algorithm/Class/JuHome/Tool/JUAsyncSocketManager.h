//
//  JUAsyncSocketManager.h
//  selfSocket
//
//  Created by 周磊 on 17/4/13.
//  Copyright © 2017年 zhl. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, JUAsyncSocketStatus){
    
    JUAsyncSocketStatusUnKnow,   //未知状态
    JUAsyncSocketStatusConnected,// 已连接
    JUAsyncSocketStatusFailed,// 失败
    JUAsyncSocketStatusClosedByServer,// 系统关闭
    JUAsyncSocketStatusClosedByUser,// 用户关闭
    JUAsyncSocketStatusReceived// 接收消息
    //    JUAsyncSocket
    
};

typedef NS_ENUM(NSInteger, JUAsyncSocketReceiveType) {
    JUAsyncSocketReceiveTypeForMessage
};
//连接成功回调
typedef void(^JUAsyncSocketConnectBlock)();
//连接失败回调
typedef void(^JUAsyncSocketFaileBlock)(NSError *error);
//关闭回调
typedef void(^JUAsyncSocketDidCloseBlock)();

//发送消息成功回调
typedef void(^JUAsyncSocketSendSuccessBlock)(long tag);



//消息接收回调
typedef void(^JUAsyncSocketReceiveBlock)(id data, long tag);



@interface JUAsyncSocketManager : NSObject

//重连时间  默认1秒
@property (nonatomic,assign) NSTimeInterval overtime;
//重连次数  默认5次
@property (nonatomic,assign) NSTimeInterval reconnectCount;

@property (nonatomic,copy) JUAsyncSocketConnectBlock connect;
@property (nonatomic,copy) JUAsyncSocketFaileBlock failure;
@property (nonatomic,copy) JUAsyncSocketSendSuccessBlock send;
@property (nonatomic,copy) JUAsyncSocketReceiveBlock receive;

@property (nonatomic,assign, readonly) BOOL isDisconnected;
@property (nonatomic,assign, readonly) BOOL isConnected;


@property (nonatomic,assign, readonly) JUAsyncSocketStatus ju_socketStatus;

+ (instancetype)shareManager;


-(void)ju_connentToHost:(NSString *)host
              onPort:(uint16_t)port
       delegateQueue:(dispatch_queue_t)dq
             connect:(JUAsyncSocketConnectBlock)connect
             failure:(JUAsyncSocketFaileBlock)failure
         sendSuccess:(JUAsyncSocketSendSuccessBlock)send
         receiveData:(JUAsyncSocketReceiveBlock)receive;




//连接到socket
-(void)connectTohost:(NSString *)host onPort:(uint16_t)port delegateQueue:(dispatch_queue_t)queqe;

//-(void)ju_sendSuccess:(JUAsyncSocketSendSuccessBlock)send receiveData:(JUAsyncSocketReceiveBlock)receive;


//用户退出登录时，手动断开连接
-(void)ju_disconnect:(JUAsyncSocketDidCloseBlock)closeConnect;

// 重新连接socket
-(void)ju_reconnnect;


//发送数据
-(void)ju_sendData:(id)message withTimeout:(NSTimeInterval)timeout tag:(long)tag sendSuccess:(JUAsyncSocketSendSuccessBlock)send receiveData:(JUAsyncSocketReceiveBlock)receive;



@end
