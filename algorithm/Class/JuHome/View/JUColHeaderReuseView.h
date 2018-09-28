//
//  JUColHeaderReuseView.h
//  七月算法_iPad
//
//  Created by 周磊 on 16/5/31.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JUColHeaderReuseView;


@protocol JUColHeaderReuseViewDelegate <NSObject>

//已经点击了按钮
-(void)morebuttonDidClicked:(JUColHeaderReuseView *)reuseView;


@end


@interface JUColHeaderReuseView : UICollectionReusableView

//@property (nonatomic,strong) UIView *line;
@property(nonatomic, assign) id<JUColHeaderReuseViewDelegate> colHeadreuseViewDelegate;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *moreBtn;

@end
