//
//  JUReplayController.m
//  algorithm
//
//  Created by 周磊 on 16/11/24.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUReplayController.h"
#import "JUMediaPlayerTool.h"


//#import "JULessonModel.h"
@interface JUReplayController ()<UITextViewDelegate>

@property(nonatomic, strong) UITextView *textView;

@property(nonatomic, strong) UILabel *placeLabel;

@property(nonatomic, strong) NSString *urlString;

@property(nonatomic, strong) YBNetManager *manager;

@property(nonatomic, strong) UIButton *bt;


@end

@implementation JUReplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
 
    
 
    [self setupSubViews];
    
    
}





- (YBNetManager *)manager
{
    if (!_manager) {
        _manager = [[YBNetManager alloc]init];
    }
    return _manager;
}


-(void)setNav{
    
//    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelAction) title:@"取消"];
 
    
    self.navigationItem.title = @"评论";
    
    if (self.commentModel) {
        
        self.navigationItem.title = @"回复";
    }
    
    
  UIBarButtonItem *  leftItem = [[UIBarButtonItem alloc]initWithTitle:@" 取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(cancelAction)];
    
  self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *bt = [UIButton buttonWithType:(UIButtonTypeCustom)];
      [bt setTitle:@"发送" forState:(UIControlStateNormal)];
    bt.frame = CGRectMake(0, 0, 45, 24);
    bt.backgroundColor = [UIColor whiteColor];
    bt.layer.cornerRadius = 2;
    
  
    bt.layer.borderWidth = 0.5;
    UIColor *color = Kcolor16rgb(@"#e2e2e2", 1);
    bt.layer.borderColor = [color CGColor];
 
    bt.layer.masksToBounds = YES;
    
    
    [UIButton buttonWithTitle:@"发送" titlefont:14 normalTitleColor:color selectedTitleColor:[UIColor whiteColor] hightedColor:nil button:bt];
    
    
//    [UIButton buttonWithNormalBgImage:@"#000000" selectedBgImage:@"#0099ff" button:bt];
    [UIButton buttonWithNormalColor:@"#ffffff" hightedColor:nil selectedColor:@"#0099ff" Button:bt];
    

    [bt addTarget:self action:@selector(rightbuttonClicked) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bt];
    
    
    self.bt = bt;
}


-(void)setupSubViews{
  
    UITextView *textView = [[UITextView alloc]init];
    textView.font = UIptfont(16);
    textView.frame = CGRectMake(15, 12+64, Kwidth-30, 150);
    textView.backgroundColor = [UIColor whiteColor];
//    textView.backgroundColor = RandomColor;
    [self.view addSubview:textView];
    textView.delegate = self;
    [textView becomeFirstResponder];
    self.textView = textView;
    
    UILabel *placeLabel = [[UILabel alloc]init];
    placeLabel.textColor = Kcolor16rgb(@"#999999", 1);
    placeLabel.text = @"请输入...";
    placeLabel.font = UIptfont(16);

//    placeLabel.backgroundColor = RandomColor;
    
    placeLabel.frame = CGRectMake(5, 8, 70, 50);
    [placeLabel sizeToFit];
    [textView addSubview:placeLabel];
    self.placeLabel = placeLabel;
    
    
}




-(void)cancelAction{
    
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
}

-(void)rightbuttonClicked{
    


    
   __block NSString *showsString = nil;
    
    if (![self.textView.text length]) return;
    
        __weak typeof(self) weakSelf = self;
    
    
 
    
    self.bt.userInteractionEnabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                    
                       weakSelf.bt.userInteractionEnabled = YES;
                       
                       
                   });
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"content"] = self.textView.text;
    
    if (self.commentModel) {//回复评论
        showsString = @"回复";
        self.urlString = [NSString stringWithFormat:@"%@%@",ReplyCommentURL,self.commentModel.ID];
    }else{// 发表评论
        showsString = @"发表";
        self.urlString = [NSString stringWithFormat:@"%@/%@/%@",SumminCommentURL,self.lessonModel.course_id, self.lessonModel.ID];
    }
    
    [self.manager canceAllrequest];
    self.manager = nil;
    

    
    [self.manager POST:self.urlString parameters:dict headdict:JuuserInfo.headDit constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } progress:^(NSProgress * _Nonnull Progress) {
        
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([[responseObject[@"errno"] description] isEqualToString:@"0"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:JURepLySucceedNotification object:showsString];
            
            showsString = [NSString stringWithFormat:@"%@成功", showsString];
            
        }else{
            
          showsString = [NSString stringWithFormat:@"%@失败", showsString];
            
        }
        

        
        [weakSelf showWithView:weakSelf.view text:showsString duration:1.2];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           
                           [weakSelf cancelAction];
                           
                           
                       });

        
       
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [weakSelf showWithView:weakSelf.view text:@"请检查你的网络" duration:1.5];
        
        JULog(@"%@", error);
        
        
        
    }];

    JUlogFunction
}

#pragma mark 代理
- (void)textViewDidChange:(UITextView *)textView{
    

    
    
    if ([textView.text length]) {
        
        self.placeLabel.hidden = YES;
        self.bt.selected = YES;
        
        
        
    }else{
        
        self.placeLabel.hidden = NO;
        self.bt.selected = NO;
        
    }
    
    
    
//    JULog(@"%d  %d", [textView.text length], self.bt.selected);
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}


@end
