//
//  JUDownloadingViewCell.h
//  七月算法_iPad
//
//  Created by pro on 16/6/19.
//  Copyright © 2016年 zhl. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SDPieLoopProgressView.h"
#import "SDDemoItemView.h"
@class JUDownloadInfo;
@interface JUDownloadingViewCell : UITableViewCell

@property(nonatomic, strong) JUDownloadInfo *downloadinfo;
@property(nonatomic, strong) UILabel *lessonNameLabel;
@property(nonatomic, strong) UIButton *downStatuesButton;


//圆圈进度条的view
@property(nonatomic, strong) SDDemoItemView *domoItemView;

@property(nonatomic,copy)void (^downloadBlock)(UIButton *sender);

@property(nonatomic, strong) UILabel *statusLabel;


@end
