//
//  JUapplicantViewController.h
//  algorithm
//
//  Created by 周磊 on 16/8/22.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUBaseTableViewController.h"
#import "JULiveDetailModel.h"
@interface JUapplicantViewController : JUBaseTableViewController

@property(nonatomic, strong) NSString *course_id;

//从上一个页面中传来的 JULiveDetailModel
@property(nonatomic, strong) JULiveDetailModel *lastliveDetailModel;

@end
