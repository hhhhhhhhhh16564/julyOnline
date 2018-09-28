//
//  JUMineHeaderReusableView.h
//  algorithm
//
//  Created by pro on 16/7/12.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUCourseCellView.h"


@class JUMineHeaderReusableView;
@protocol JUMineHeaderReusableViewDelegate <NSObject>

-(void)didClickedHeaderReusableView:(JUMineHeaderReusableView *)headerReusableView;


@end


@interface JUMineHeaderReusableView : UICollectionReusableView
//@property(nonatomic, strong) UIView *line;
@property(nonatomic, strong) JUCourseCellView *cellView;
@property(nonatomic, strong) NSIndexPath *indexPath;

@property(nonatomic, weak) id<JUMineHeaderReusableViewDelegate> delegate;
@end
