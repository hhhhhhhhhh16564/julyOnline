//
//  JULoadingView.m
//  algorithm
//
//  Created by yanbo on 17/10/25.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JULoadingView.h"

@interface JULoadingView ()

@property(nonatomic, strong) UIImageView *imv;

@property(nonatomic, strong) UILabel *advertisementLabel;

@property(nonatomic, strong) UILabel *loadStateLabel;

@property(nonatomic, strong) UIButton *loadAgainButton;

@property (nonatomic,assign) LoadingState state;
@property(nonatomic, strong) NSMutableArray *imageArray;

@end


@implementation JULoadingView

-(NSMutableArray *)imageArray{
    
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
        
        for (int i = 1; i < 5; i++) {
            NSString *imageName = [NSString stringWithFormat:@"ic_loading_%d",i];
            
            UIImage *image = [UIImage imageNamed:imageName];
            
            NSLog(@"%@ %@", imageName, image);
            
            [_imageArray addObject:image];
            
        }
        
        for (int i = 3; i > 0; i--) {
            NSString *imageName = [NSString stringWithFormat:@"ic_loading_%d",i];
            
            UIImage *image = [UIImage imageNamed:imageName];
            
            NSLog(@"%@ %@", imageName, image);
            
            [_imageArray addObject:image];
            
        }
        
        
    }
    
    return _imageArray;
    
    
}
//使用单利类就会添加到UIWindow上
+(instancetype)shareInstance{
    
    static JULoadingView *loadingView = nil;
    
    CGRect frame =  CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);

    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        loadingView = [[JULoadingView alloc]initWithFrame:frame];
        
    });
    
    loadingView.frame = frame;
    loadingView.state = LoadingStateUnitiall;
   

    return loadingView;
    
}





-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
//    _loadingTime = 0.5;
//    _WaitingTime = 3;
    self.state = LoadingStateUnitiall;
    [self setuPSubViews];
    return self;
}




-(void)setuPSubViews{

    UIColor *blueColor = Kcolor16rgb(@"#0099ff", 1);
    
    UIImageView *imv = [[UIImageView alloc]init];
    imv.animationImages = self.imageArray;
    imv.animationDuration = 0.8;
    imv.animationRepeatCount = 0;
    [self addSubview:imv];
    self.imv = imv;
    
    
    UILabel *advertisementLabel = [[UILabel alloc]init];
    advertisementLabel.text = @"国内领先的人工智能教育平台";
    advertisementLabel.textColor = kColorRGB(153, 153, 153, 1);
    advertisementLabel.textAlignment = NSTextAlignmentCenter;
    advertisementLabel.font = [UIFont systemFontOfSize:10];
    advertisementLabel.textColor = [UIColor grayColor];
    [self addSubview:advertisementLabel];
    self.advertisementLabel = advertisementLabel;
    
    
    UILabel *loadStateLabel = [[UILabel alloc]init];
    loadStateLabel.textAlignment = NSTextAlignmentCenter;
    loadStateLabel.font = [UIFont systemFontOfSize:11];
    loadStateLabel.text = @"加载失败";
    loadStateLabel.textColor = blueColor;
    [self addSubview:loadStateLabel];
    self.loadStateLabel = loadStateLabel;
    
    UIButton *loadAgainButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [loadAgainButton setTitle:@"重新加载" forState:(UIControlStateNormal)];
    [loadAgainButton setTitleColor:blueColor forState:(UIControlStateNormal)];
    [loadAgainButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
    loadAgainButton.layer.cornerRadius = 2;
    loadAgainButton.layer.borderWidth = 0.5;
    loadAgainButton.layer.borderColor = [blueColor CGColor];
    [loadAgainButton addTarget:self action:@selector(loadAgainButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:loadAgainButton];
    self.loadAgainButton = loadAgainButton;
    
 
}


-(void)setupFrame{
    
    CGFloat topHeight = 140;

    CGFloat width = self.bounds.size.width;
    //    CGFloat Height = self.bounds.size.height;
    self.imv.frame = CGRectMake(width*0.5-25, topHeight, 40, 80);
    topHeight += CGRectGetHeight(self.imv.frame)+5;
    
    self.imv.backgroundColor = [UIColor redColor];
    
    
    self.advertisementLabel.frame = CGRectMake(0, topHeight, width, 10);
    topHeight += 10 + 10;
    
    
    self.loadStateLabel.frame = CGRectMake(0, topHeight, width, 11);
    topHeight += 11 + 10;
    
    
    self.loadAgainButton.frame = CGRectMake(width*0.5-35, topHeight, 70, 20);
}


-(void)setState:(LoadingState)state{
    
    _state = state;
    
    switch (state) {
        case LoadingStateUnitiall:{
            self.hidden = YES;
            
            break;
            
        }
          
        case LoadingStateSuccess:{
            self.hidden = YES;
            
            
            break;
            
        }
        
        case LoadingStateFailure:{
            self.hidden = NO;
            self.loadStateLabel.text = @"加载失败";
            self.loadAgainButton.hidden = NO;
            
            break;
            
        }
        
        case LoadingStateLoading:{
            self.hidden = NO;
            
            self.loadStateLabel.text = @"正在加载中";
            self.loadAgainButton.hidden = YES;

            
            break;
            
        }
            
        case LoadingStateLoadAgain:{
            self.hidden = NO;
            self.loadStateLabel.text = @"正在加载中";
            
            self.loadAgainButton.hidden = YES;
            break;
            
        }
        default:
            break;
    }

}



-(void)beginLoad{
    
    if (![[NSThread currentThread] isMainThread]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self beginLoad];
        });
    }
    
    if (self.state == LoadingStateLoading) {
        return;
    }
    
    [self beginAnimate];
}

-(void)loadSuccess{
    
    if (![[NSThread currentThread] isMainThread]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadSuccess];
        });
    }
    

    self.state = LoadingStateSuccess;
 
    [self endAnimate];
    
}



-(void)loadFailure{
    
    if (![[NSThread currentThread] isMainThread]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadFailure];
        });
    }
    
    
    

    self.state = LoadingStateFailure;
    [self endAnimate];

    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
        [self setupFrame];
    
}



-(void)beginAnimate{

       self.state = LoadingStateLoading;
       [self romoteAction];
    

}

-(void)romoteAction{

  
    [self.imv startAnimating];
}

-(void)endAnimate{
    
 
    [self.imv stopAnimating];
    
    
    UIImage *image = self.imageArray[3];
    self.imv.image = image;
    
}


-(void)loadAgainButton:(UIButton *)sender{
    
    self.state = LoadingStateLoadAgain;
    
    if (self.failureBlock) {
        self.failureBlock();
    }
    

}

-(void)removeFromSuperview{
    
    self.state = LoadingStateUnitiall;
    [super removeFromSuperview];
    
    
}





@end
