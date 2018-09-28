//
//  JUDiscountRulesController.m
//  algorithm
//
//  Created by 周磊 on 16/8/25.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUDiscountRulesController.h"

#import "JUPriceLevelInfoModel.h"

@interface DiscountRulesCellView ()




@property(nonatomic, strong) UIView *topLineView;
@property(nonatomic, strong) UIView *bottomLineView;

@end



@implementation DiscountRulesCellView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
   
        UILabel *categoryLabel = [[UILabel alloc]init];
        categoryLabel.font = UIptfont(15);
        categoryLabel.textAlignment = NSTextAlignmentLeft;
        categoryLabel.textColor = [UIColor blackColor];
        [self addSubview:categoryLabel];
        
        self.categoryLabel = categoryLabel;
        
        

        UILabel *priceLabel = [[UILabel alloc]init];
        priceLabel.font = UIptfont(15);
        
        priceLabel.textAlignment = NSTextAlignmentRight;
        
        priceLabel.textColor = [UIColor blackColor];
        
        [self addSubview:priceLabel];
        
        self.priceLabel = priceLabel;
        
        
        UIView *topLineView = [[UIView alloc]init];
        topLineView.backgroundColor = HCommomSeperatorline(1);
        [self addSubview:topLineView];
        self.topLineView = topLineView;
        
        
        UIView *bottomLineView = [[UIView alloc]init];
        bottomLineView.backgroundColor = HCommomSeperatorline(1);
        [self addSubview:bottomLineView];
        self.bottomLineView = bottomLineView;
        

        _space = 12;
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    CGFloat kspacing = _space;
    

    self.categoryLabel.frame = CGRectMake(kspacing, 0, 150, self.height_extension);
    self.priceLabel.frame = CGRectMake(kspacing, 0, 250, self.height_extension);
    self.priceLabel.right_extension = self.width_extension-kspacing;
    
    
    
    self.topLineView.frame = CGRectMake(0, 0, self.width_extension, 0.5);
    self.bottomLineView.frame = CGRectMake(0, self.height_extension-0.5, self.width_extension, 0.5);
    
    if (self.isHiddenLine) {
        self.topLineView.hidden = YES;
        self.bottomLineView.hidden = YES;
    }

    
//    self.categoryLabel.backgroundColor = RandomColor;
//    self.priceLabel.backgroundColor = RandomColor;
//
    
}





@end




















@interface JUDiscountRulesController ()




@property(nonatomic, strong) UIView *topView;

@property(nonatomic, strong) JUPriceLevelInfoModel *priceLevelInfoModel;
@property(nonatomic, strong) NSArray *categoryArray;

@end




@implementation JUDiscountRulesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        return;
    }
    
    [self setupViews];
    
    [self makeData];
}


-(void)setupViews{
    
   NSArray *array = @[@"新学员",@"单重学员",@"双重不同类",@"三重不同类",@"第二次报同类",@"第三次报同类"];
 self.categoryArray = array;
    
    
    self.title = @"优惠规则";
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = HCanvasColor(1);
    contentView.frame = CGRectMake(0, 64, Kwidth, Kheight-64);
    [self.view addSubview:contentView];
    
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = HCommomSeperatorline(1);
    topView.frame = CGRectMake(20, 20, Kwidth-40, 44*6+1);
    self.topView = topView;
    
    [contentView addSubview:topView];
    
    
 
    for (int i = 0; i < array.count; i++) {
        
        CGFloat x = 0.5;
        CGFloat y = 44*i;
        CGFloat width = Kwidth-41;
        CGFloat height = 44;
        
        
        DiscountRulesCellView *cellView = [[DiscountRulesCellView alloc]init];
        cellView.isHiddenLine = YES;
        cellView.space = 20;
        
        cellView.frame = CGRectMake(x, y+0.5, width, height);
        
        cellView.tag = 1000+i;
        
        [topView addSubview:cellView];
        
        if (i % 2){
            continue;
        }
            
        cellView.backgroundColor = Kcolor16rgb(@"#f8f8f8", 1);
        

    }
    
    
    
    
    
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    
    //行高为14   行数为2  行间距为30
    // label的高度 = label的行高 * 行数 + 行间距 *(行数-1) + 行高 *0.64 = 14*3+30*2+14*0.6
    
    label.frame = CGRectMake(20, self.topView.bottom_extension+20, Kwidth-40, 110.4);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[NSFontAttributeName] = UIptfont(14);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 30;
    dict[NSParagraphStyleAttributeName] = paragraphStyle;
    
    label.attributedText = [[NSAttributedString alloc]initWithString:@"如有疑问请联系\n客服QQ:919439335\n客服电话:18910848502" attributes:dict];
    
    [contentView addSubview:label];
    
}


//请求数据
-(void)makeData{
    
    
    
    YBNetManager *mannger = [[YBNetManager alloc]init];
 
    NSString *urlStrign = [NSString stringWithFormat:@"%@%@",priceLevelInfoURL, self.course_id];
    
    [mannger GET:urlStrign parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *responobject) {
        
       JULog(@"%@", responobject[@"data"][@"info"]);
        NSDictionary *dictionary = responobject[@"data"][@"info"];
        
        if (!dictionary) return ;
        
        
        self.priceLevelInfoModel = [JUPriceLevelInfoModel mj_objectWithKeyValues:dictionary];
        
        //请求到数据后改变数据
        
        
//        [NSObject createPropertyCodeWithDict:dictionary];
        
        [self.priceLevelInfoModel logObjectExtension_YanBo];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
}

-(void)setPriceLevelInfoModel:(JUPriceLevelInfoModel *)priceLevelInfoModel{
    
    _priceLevelInfoModel = priceLevelInfoModel;
    
    
    for (int i = 0; i < self.categoryArray.count; i++) {
        
      DiscountRulesCellView *rulesCellView = (DiscountRulesCellView *)[self.topView viewWithTag:1000+i];
        
        
        NSString *price = [priceLevelInfoModel priceWithNumber:i+1];
        
        rulesCellView.priceLabel.text = [NSString stringWithFormat:@"¥%@", price];
    
        rulesCellView.categoryLabel.text = self.categoryArray[i];
        
    
        NSUInteger leveal = [self.price_level integerValue];
        
        if (leveal-1==i) {
            
            rulesCellView.categoryLabel.textColor = Hmblue(1);
            rulesCellView.priceLabel.textColor = Hmblue(1);
            
        }
        
        
 
    }
    
    
    
    
  
}


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
//    // 提供uin, 你所要联系人的QQ号码
//    NSString *qqstr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",@"3583514482"];
//    NSURL *url = [NSURL URLWithString:qqstr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
//    [self.view addSubview:webView];
//}







@end
