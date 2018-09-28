//
//  JUMyCouponViewCell.m
//  algorithm
//
//  Created by 周磊 on 17/1/22.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUMyCouponViewCell.h"
#import "NSDate+Extension.h"


@interface JUMyCouponViewCell ()
@property(nonatomic, strong) UIView *backView;
//优惠券种类
@property(nonatomic, strong) UILabel *couponCategoryLabel;
//有效期
@property(nonatomic, strong) UILabel *endDateLabel;
//优惠券的使用范围
@property(nonatomic, strong) UILabel *usingRangeLabel;
@property(nonatomic, strong) UILabel *willExpireLabel;
//优惠券种类View
@property(nonatomic, strong) UIView *couponCatergoryView;
//价格
@property(nonatomic, strong) UILabel *priceLabel;

@property(nonatomic, strong) UIButton *checkButton;

@property(nonatomic, strong) UIView  *coverView;

@end


@implementation JUMyCouponViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self set_subViews];
    }
    return self;
}

-(void)set_subViews{ 
    UIView *backView = [[UIView alloc]init];
    [self.contentView addSubview:backView];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.backView = backView;
    
    
    UILabel *couponCategoryLabel = [[UILabel alloc]init];
    couponCategoryLabel.textColor = [UIColor whiteColor];
    couponCategoryLabel.font = UIptfont(15);
    [self.backView addSubview:couponCategoryLabel];
    self.couponCategoryLabel = couponCategoryLabel;
    

    //    couponCatergoryView
    UIView *couponCatergoryView = [[UIView alloc]init];
    [self.backView addSubview:couponCatergoryView];
    self.couponCatergoryView = couponCatergoryView;
    
    UILabel *usingRangeLabel = [[UILabel alloc]init];
    usingRangeLabel.font = UIptfont(11);
    [self.backView addSubview:usingRangeLabel];
    self.usingRangeLabel = usingRangeLabel;

    UILabel *endDateLabel = [[UILabel alloc]init];
    endDateLabel.textColor = [UIColor whiteColor];
    endDateLabel.textAlignment = NSTextAlignmentRight;
    endDateLabel.font = UIptfont(11);
    [self.backView addSubview:endDateLabel];
    self.endDateLabel = endDateLabel;

    UILabel *willExpireLabel = [[UILabel alloc]init];
    willExpireLabel.text = @"即将过期";
    willExpireLabel.textColor = [UIColor whiteColor];
    willExpireLabel.font = UIptfont(14);
    [self.backView addSubview:willExpireLabel];
    self.willExpireLabel = willExpireLabel;

    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.font = UIptfont(16);
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:priceLabel];
    self.priceLabel = priceLabel;

    UIButton *checkButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [checkButton setImage:[UIImage imageNamed:@"daixuan@youhuiquan"] forState:(UIControlStateNormal)];
    [checkButton setImage:[UIImage imageNamed:@"choice@youhuiquan@icon"] forState:(UIControlStateSelected)];
//    [checkButton addTarget:self action:@selector(checkButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:checkButton];
    self.checkButton = checkButton;
    self.checkButton.userInteractionEnabled = NO;
    
    
    
    UIView *coverView = [[UIView alloc]init];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.18;
    [self.backView addSubview:coverView];
    self.coverView = coverView;
    self.coverView.hidden = YES;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];

    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
        
    }];
    
    [self.couponCategoryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(10);
    }];
    
    [self.endDateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(5);
    }];
    
    [self.couponCatergoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(27);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    
    [self.willExpireLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-5);
    }];
    
    
    [self.usingRangeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(-5);
        
        make.right.equalTo(self.willExpireLabel.mas_left).offset(30);
        
    }];
    
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backView);
       
        make.width.mas_equalTo(Kwidth-60);
        
    }];
    

    [self.checkButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.right.mas_equalTo(-24);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.right.and.left.and.bottom.mas_equalTo(0);
    }];
    
}


-(void)setAllCouponModel:(JUMyCouponModel *)allCouponModel{
    
    _allCouponModel = allCouponModel;
    
    NSString *ctype = allCouponModel.ctype;
    NSString *categoryString = @"";
    NSString *priceString =allCouponModel.amount;
    NSString *usingRangeString = @"";
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[allCouponModel.expire_time integerValue]];
    UIColor *backColor = nil;
    UIColor *imvColor = nil;
    UIColor *usingRangeColor = nil;
    
    if ([ctype isEqualToString:@"1"]) {
        categoryString = @"代金券";
        priceString = [NSString stringWithFormat:@"%@ 元", allCouponModel.amount];
        NSMutableAttributedString *attributString = priceString.mutableAttributedString;

        [attributString customFont:[UIFont boldSystemFontOfSize:30] color:[UIColor whiteColor]];
        [attributString customFont:[UIFont boldSystemFontOfSize:16] color:[UIColor whiteColor] str:@" 元"];
        self.priceLabel.attributedText = attributString;        
        usingRangeString = @"可用于购买任意课程";
        backColor = Kcolor16rgb(@"#18b4ed", 1);
        imvColor = [UIColor colorWithPatternImage:[self imageWithColor:@"#00a6e3"]];
        usingRangeColor = Kcolor16rgb(@"#ffff66", 1);
     
        //代金券有时也限定课程
        if (![allCouponModel.limit_course isEqualToString:@"0"]) {
            usingRangeString = [NSString stringWithFormat:@"仅可用于购买 《%@》", allCouponModel.course_title];
        }
        
    }else if ([ctype isEqualToString:@"2"]){
        categoryString = @"课程劵";
        priceString = allCouponModel.course_title;
        self.priceLabel.font = [UIFont boldSystemFontOfSize:16];
         self.priceLabel.text = priceString;
        usingRangeString = [NSString stringWithFormat:@"仅可用于购买 《%@》", priceString];
        backColor = Kcolor16rgb(@"#feb2b2", 1);
        imvColor = [UIColor colorWithPatternImage:[self imageWithColor:@"#ffa1a1"]];
        usingRangeColor = Kcolor16rgb(@"#996699", 1);
    }else{
//        categoryString = @"满减卷";
//        priceString = @"满900元减100元";
//        usingRangeString = @"可用于购买任意课程";
//        backColor = Kcolor16rgb(@"#e9c37d", 1);
//        imvColor = [UIColor colorWithPatternImage:[self imageWithColor:@"#e4b05f"]];
//        usingRangeColor = Kcolor16rgb(@"#ffff66", 1);
        
    }
    
    self.endDateLabel.text = [NSString stringWithFormat:@"有效期至: %@", [endDate stringWithFormat:@"yyyy-MM-dd"]];
    self.backView.backgroundColor = backColor;
    self.couponCatergoryView.backgroundColor = imvColor;
    self.usingRangeLabel.text = usingRangeString;
    self.usingRangeLabel.textColor = usingRangeColor;
   
    self.couponCategoryLabel.text = categoryString;
    self.checkButton.hidden = !allCouponModel.isCanUsed;
    
    NSTimeInterval interVal = [endDate timeIntervalSinceNow];
    
    self.willExpireLabel.hidden = (interVal >= 24*3600*3);

      
}


-(void)setUsingCouponModel:(JUMyCouponModel *)usingCouponModel{
    _usingCouponModel = usingCouponModel;
    [self setAllCouponModel:usingCouponModel];
    if (!usingCouponModel.isCanUsed) {
        self.usingRangeLabel.textColor = [UIColor whiteColor];
        self.backView.backgroundColor = Kcolor16rgb(@"cccccc", 1);
        self.couponCatergoryView.backgroundColor = [UIColor colorWithPatternImage:[self imageWithColor:@"aaaaaa"]];
    }
    
    if (usingCouponModel.selected) {
        self.checkButton.selected = YES;
        self.coverView.hidden = YES;
    }else{
        self.checkButton.selected = NO;
        self.coverView.hidden = NO;
    }
    
}


-(UIImage *)imageWithColor:(NSString *)colorString{
    //高  45+9
    //宽  20+18
    
    UIColor *color = Kcolor16rgb(colorString, 1);
    
    //开启图片类型的图形上下文
    UIGraphicsBeginImageContext(CGSizeMake(19, 27));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, 0, 4.5);
    CGContextAddLineToPoint(ctx, 10, 4.5);
    
    CGContextAddArc(ctx,14.5, 4.5, 4.5, -M_PI, 0, 0);
    
    CGContextAddLineToPoint(ctx, 19, 27);
    CGContextAddLineToPoint(ctx, 0, 27);
    CGContextSetLineWidth(ctx, 0);
    
    [color setFill];
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     //关闭
    UIGraphicsEndImageContext();
    return image;
    
}



/*
 
 
 #import "JUMyCouponViewCell.h"
 
 @interface JUMyCouponViewCell ()
 //优惠码
 @property(nonatomic, strong) UILabel *couponLabel;
 //价格
 @property(nonatomic, strong) UILabel *priceLabel;
 //有效期
 @property(nonatomic, strong) UILabel *endDateLabel;
 
 @property(nonatomic, strong) UILabel *goUseLabel;
 @property(nonatomic, strong) UIButton *identifierView;
 //将要过期
 @property(nonatomic, strong) UIImageView *willOverdueImv;
 //过期的
 @property(nonatomic, strong) UIImageView *overdueImv;
 
 @end
 
 
 @implementation JUMyCouponViewCell
 
 
 
 -(instancetype)initWithFrame:(CGRect)frame{
 
 self = [super initWithFrame:frame];
 
 if (self) {
 self.backgroundColor = Kcolor16rgb(@"fffee2", 1);
 
 [self set_subViews];
 }
 return self;
 }
 
 -(void)set_subViews{
 
 UILabel *couponLabel = [[UILabel alloc]init];
 couponLabel.textColor = Kcolor16rgb(@"24BCCA", 1);
 couponLabel.font = UIptfont(12);
 [self.contentView addSubview:couponLabel];
 self.couponLabel = couponLabel;
 
 
 
 UILabel *priceLabel = [[UILabel alloc]init];
 priceLabel.textColor = Kcolor16rgb(@"24BCCA", 1);
 priceLabel.font = UIptfont(50);
 priceLabel.textAlignment = NSTextAlignmentCenter;
 [self.contentView addSubview:priceLabel];
 self.priceLabel = priceLabel;
 
 
 
 UILabel *endDateLabel = [[UILabel alloc]init];
 endDateLabel.textColor = Kcolor16rgb(@"24BCCA", 1);
 endDateLabel.textAlignment = NSTextAlignmentCenter;
 
 endDateLabel.font = UIptfont(12);
 [self.contentView addSubview:endDateLabel];
 self.endDateLabel = endDateLabel;
 
 
 
 UIButton *identifierView = [UIButton createButton];
 [identifierView setTitle:@"去使用 >" forState:(UIControlStateNormal)];
 [identifierView setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
 [identifierView addTarget:self action:@selector(buttonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
 
 [identifierView.titleLabel setFont:UIptfont(16)];
 [self.contentView addSubview:identifierView];
 self.identifierView = identifierView;
 
 
 UIImageView *willOverdueImv = [[UIImageView alloc]init];
 willOverdueImv.alpha =0.5;
 
 willOverdueImv.image = [UIImage imageNamed:@"youhuiquan@pased"];
 [self.contentView addSubview:willOverdueImv];
 self.willOverdueImv = willOverdueImv;
 
 
 
 
 UIImageView *overdueImv = [[UIImageView alloc]init];
 overdueImv.image = [UIImage imageNamed:@"pasted"];
 [self.priceLabel addSubview:overdueImv];
 self.overdueImv = overdueImv;
 
 
 willOverdueImv.hidden = YES;
 overdueImv.hidden = YES;
 
 }
 
 -(void)layoutSubviews{
 [super layoutSubviews];
 
 CGFloat cellWidth = self.width_extension;
 CGFloat cellHeight = self.height_extension;
 
 
 self.couponLabel.frame = CGRectMake(5, 10, cellWidth, 12);
 self.priceLabel.frame = CGRectMake(0, cellHeight * 0.5 -40, cellWidth, 50);
 
 
 self.endDateLabel.frame = CGRectMake(0, self.priceLabel.bottom_extension+20, cellWidth, 12);
 self.identifierView.frame = CGRectMake(0, cellHeight-46, cellWidth, 46);
 
 
 self.willOverdueImv.frame = CGRectMake(cellWidth-70, 0, 70, 70);
 self.overdueImv.frame = CGRectMake(0, 0, 73.5, 74);
 [self.overdueImv XY_centerInSuperView];
 
 
 }
 
 -(NSMutableAttributedString *)arrtibuteString{
 
 NSString *priceString = [NSString stringWithFormat:@"%@元",self.couponModel.amount];
 NSMutableAttributedString *atrtibueString = [[NSMutableAttributedString alloc]initWithString:priceString];
 UIColor *textColor = Kcolor16rgb(@"24BCCA", 1);
 [atrtibueString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, priceString.length)];
 [atrtibueString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50] range:NSMakeRange(0, priceString.length)];
 NSRange range = [priceString rangeOfString:@"元"];
 [atrtibueString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:range];
 
 return atrtibueString;
 
 
 }
 
 
 -(void)buttonClicked:(UIButton *)sender{
 
 if (self.goUseBlcok) {
 
 self.goUseBlcok(self.couponModel);
 }
 
 
 JUlogFunction
 
 
 }
 
 -(void)setCouponModel:(JUMyCouponModel *)couponModel{
 
 _couponModel = couponModel;
 
 self.priceLabel.attributedText = [self arrtibuteString];
 self.endDateLabel.text = [NSString stringWithFormat:@"有效期至：  %@",self.couponModel.expire_time];
 self.couponLabel.text = [NSString stringWithFormat:@"优惠码：  %@",self.couponModel.code];
 
 
 self.identifierView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"youhuiquan@bj@nor"]];
 
 }

 
 */


@end
