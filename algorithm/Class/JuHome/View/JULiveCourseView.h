//
//  JULiveCourseView.h
//  algorithm
//
//  Created by 周磊 on 16/8/22.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JUOrderModel;
@class JULiveDetailModel;
@interface JULiveCourseView : UIView
@property(nonatomic, strong)  JULiveDetailModel *liveDetailModel;


//3.1版本改版的，但是之前的还有用，就重新建了一个
@property(nonatomic, strong) JULiveDetailModel *newliveDetailModel;

@property(nonatomic, strong) JUOrderModel *orderModel;

@end
