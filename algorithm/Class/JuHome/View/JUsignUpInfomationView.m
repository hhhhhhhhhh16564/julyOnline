//
//  JUsignUpInfomationView.m
//  algorithm
//
//  Created by 周磊 on 16/8/24.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUsignUpInfomationView.h"
#import "JUChooseView.h"
#import "JUButton.h"



@interface UserInformationView ()<UITextFieldDelegate>

@property(nonatomic, strong) UILabel *label;

@property(nonatomic, strong) UITextField *textfield;

@property(nonatomic, strong) UIView *lineView;

@end


@implementation UserInformationView

-(instancetype)initWithFrame:(CGRect)frame name:(NSString *)name placeholder:(NSString *)placeholder valueText:(NSString *)valueText{
    
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        UILabel *lable = [[UILabel alloc]init];
        lable.font = UIptfont(15);
        lable.text = name;
         lable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:lable];
        self.label = lable;
        
        
        
        UITextField *textfield = [[UITextField alloc]init];
        textfield.delegate = self;
        textfield.placeholder = placeholder;
        textfield.font = UIptfont(15);
//       textfield.textAlignment = NSTextAlignmentRight;
        textfield.returnKeyType = UIReturnKeyDone;
        
        
        [self addSubview:textfield];
        self.textfield = textfield;
        

        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = HCommomSeperatorline(1);
        [self addSubview:lineView];
        
        self.lineView = lineView;
              
        
        
    }
    
    return self;
    
}



-(NSString *)valueText{
    
    
    return self.textfield.text;
    
}

-(void)setValueText:(NSString *)valueText{
    
    self.textfield.text = valueText;
}


-(void)setLabelText:(NSString *)labelText{
    
    
    self.label.text = labelText;
    
    
}


-(NSString *)labelText{
    
    return self.label.text;
}






-(void)setPlaceholder:(NSString *)placeholder{
    
    _placeholder = placeholder;
    
    self.textfield.placeholder = placeholder;
    
    
}


-(void)setArray:(NSArray<NSString *> *)array{
    
    _array = array;
    
    self.labelText = array[0];
    
    self.placeholder = array[1];
    
    
}




-(void)layoutSubviews{
    [super layoutSubviews];

    
    self.label.frame = CGRectMake(0, 0, 65, self.height_extension);
    
    self.textfield.frame = CGRectMake(self.label.right_extension+38, 0, self.width_extension-self.label.right_extension-12, self.height_extension);
    
//    self.textfield.right_extension = self.width_extension-12;
    
    self.lineView.frame = CGRectMake(0, 0, self.width_extension, 0.5);
    self.lineView.bottom_extension = self.height_extension;
    

    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}



@end










@interface JUsignUpInfomationView ()

@property(nonatomic, strong)  UserInformationView  *nameView;
@property(nonatomic, strong)  UserInformationView  *phoneView;
@property(nonatomic, strong)  UserInformationView  *qqView;



@property(nonatomic, strong)  JUChooseView *sexView;

@property(nonatomic, strong) JUChooseView *workView;

//公司
@property(nonatomic, strong) UserInformationView *companyView;
//职位
@property(nonatomic, strong) UserInformationView *positionView;

//学校
@property(nonatomic, strong) UserInformationView *schoolView;

//专业
@property(nonatomic, strong) UserInformationView *majorView;




@property(nonatomic, strong)  UserInformationView  *activityView;

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIButton *sureButton;

@property(nonatomic, strong) UIView *topLineView;
@property(nonatomic, strong) UIView *bottomLineView;

@end




@implementation JUsignUpInfomationView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        
        self.backgroundColor = HCanvasColor(1);
        
        [self setupViews];
    }
    return self;
}

-(void)setupViews{
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;

    UIView *toplineView = [[UIView alloc]init];
    toplineView.backgroundColor = HCommomSeperatorline(1);
    [self.contentView addSubview:toplineView];
    self.topLineView = toplineView;
    
    
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = HCommomSeperatorline(1);
     [self.contentView addSubview:bottomLineView];
    self.bottomLineView = bottomLineView;

    
  
    
    
    UserInformationView *nameView = [[UserInformationView alloc]initWithFrame:CGRectZero name:@"姓名" placeholder:@"请输入您的真实姓名" valueText:@""];
    [self addSubview:nameView];
    self.nameView = nameView;
    
    
    
    
    UserInformationView *phoneView = [[UserInformationView alloc]initWithFrame:CGRectZero name:@"手机号码" placeholder:@"请输入您的手机号码" valueText:@""];
    [self addSubview:phoneView];
    self.phoneView = phoneView;
    
    
    
    UserInformationView *qqView = [[UserInformationView alloc]initWithFrame:CGRectZero name:@"QQ号码" placeholder:@"请输入您的QQ号码" valueText:@""];
    [self addSubview:qqView];
    self.qqView = qqView;
    
//    
//    JUChooseView *sexView = [[JUChooseView alloc]initWithFrame:CGRectZero categoryString:@"性别"];
//    sexView.array = @[@"男", @"女"];
//    
//    [self addSubview:sexView];
//    self.sexView = sexView;
//    
//    
//    JUChooseView *workView = [[JUChooseView alloc]initWithFrame:CGRectZero categoryString:@"是否工作"];
//    workView.array = @[@"是", @"否"];
//    
//    
//    [self addSubview:workView];
//    self.workView = workView;
//
//    
//    UserInformationView *companyView = [[UserInformationView alloc]initWithFrame:CGRectZero name:@"公司" placeholder:@"请输入您的公司" valueText:@""];
//    [self addSubview:companyView];
//    self.companyView = companyView;
//    
//    
//    UserInformationView *schoolView = [[UserInformationView alloc]initWithFrame:CGRectZero name:@"学校" placeholder:@"请输入您的学校" valueText:@""];
//    schoolView.hidden = YES;
//    [self addSubview:schoolView];
//    self.schoolView = schoolView;
//    
//    
//    
//    
//    
//    UserInformationView *positionView = [[UserInformationView alloc]initWithFrame:CGRectZero name:@"职位" placeholder:@"请输入您的职位" valueText:@""];
//    [self addSubview:positionView];
//    self.positionView = positionView;
//    
//    UserInformationView *majorView = [[UserInformationView alloc]initWithFrame:CGRectZero name:@"专业" placeholder:@"请输入您的专业" valueText:@""];
//    majorView.hidden = YES;
//    [self addSubview:majorView];
//    self.majorView = majorView;
//    
//    
//
//    
//    __weak typeof(self) weakSelf = self;
//    self.workView.block = ^(JUButton *button){
//        
//        NSString *title = [button titleForState:(UIControlStateNormal)];
//        
//        if ([title isEqualToString:@"是"]) {
//            
////            weakSelf.companyView.array = @[@"公司", @"请输入您的公司"];
////            weakSelf.positionView.array = @[@"职位", @"请输入您的职位"];
//
//            weakSelf.companyView.hidden = NO;
//            weakSelf.positionView.hidden = NO;
//            weakSelf.schoolView.hidden = YES;
//            weakSelf.majorView.hidden = YES;
//            
//
//        }else{
//            
//            
//            weakSelf.companyView.hidden = YES;
//            weakSelf.positionView.hidden = YES;
//            weakSelf.schoolView.hidden = NO;
//            weakSelf.majorView.hidden = NO;
//            
//        }
//   
//    };
//    
//
//    UserInformationView *activityView = [[UserInformationView alloc]initWithFrame:CGRectZero name:@"兴趣方向" placeholder:@"请输入您的兴趣方向" valueText:@""];
//    [self addSubview:activityView];
//    self.activityView = activityView;
//    

    
    
    UIButton *sureButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [sureButton.titleLabel setFont:UIptfont(17)];
    [sureButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [sureButton setTitle:@"确定" forState:(UIControlStateNormal)];
    UIColor *normalColor = Kcolor16rgb(@"#18b4ed", 1);
    [sureButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateNormal)];
    UIColor *selectedColor = Kcolor16rgb(@"#2ca6e0", 1);
    [sureButton setBackgroundImage:[UIImage imageWithColor:selectedColor] forState:(UIControlStateHighlighted)];
   
    [sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];

    sureButton.layer.cornerRadius = 5;
    sureButton.layer.masksToBounds = YES;
    [self addSubview:sureButton];
    
    self.sureButton = sureButton;
    
    
}



-(void)sureButtonAction:(UIButton *)button{
    
    

    
    if (![self checkInformation]) {
        
        return;
    }
    
    YBNetManager *manager = [[YBNetManager alloc]init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"real_name"] = self.nameView.valueText;
    
    dict[@"cellphone"] = self.phoneView.valueText;
    
    dict[@"qq"] = self.qqView.valueText;
    
//    if (self.sexView.seletedIndex==0) {
//        
//        dict[@"sex"] = @"1";
//        
//    }else{
//        
//        dict[@"sex"] = @"2";
//
//        
//    }
//    
//    if (self.workView.seletedIndex==0) {
//        
//        dict[@"is_work"] = @"1";
//        
//    }else{
//        
//        dict[@"is_work"] = @"0";
//    }
//    
//    dict[@"company"] = self.companyView.valueText;
//    dict[@"position"] = self.positionView.valueText;
//    dict[@"collage"] = self.schoolView.valueText;
//    dict[@"major"] = self.majorView.valueText;
//    dict[@"interest"] = self.activityView.valueText;
//  
    
    [manager POST:saveUserInformationURL parameters:dict headdict:JuuserInfo.headDit constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } progress:^(NSProgress * _Nonnull Progress) {
        
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        JULog(@"%@", responseObject);

  
        if ([[responseObject[@"errno"] description] isEqualToString:@"0"]) {
          
            
            //保存成功，退出
            self.block();

        }else{
            
            [self showToolTipbox:@"保存信息失败"];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
            [self showToolTipbox:@"保存信息失败"];
   
        
    }];
    
}




-(void)layoutSubviews{
    
    
    [super layoutSubviews];
    
    
    //    @property(nonatomic, strong)  UserInformationView  *nameView;
    //    @property(nonatomic, strong)  UserInformationView  *phoneView;
    //    @property(nonatomic, strong)  UserInformationView  *qqView;
    //    @property(nonatomic, strong)  UserInformationView  *activityView;
    
//    @property(nonatomic, strong) UserInformationView *companyView;
//    @property(nonatomic, strong) UserInformationView *positionView;
    
    
    CGFloat cellHeitht = 44;
    CGFloat cellWidth = Kwidth - 12;
    
    self.nameView.frame = CGRectMake(12, 0, cellWidth, cellHeitht);
    self.phoneView.frame = CGRectMake(12, cellHeitht, cellWidth, cellHeitht);
    self.qqView.frame = CGRectMake(12, cellHeitht*2, cellWidth, cellHeitht);
    
//    self.sexView.frame = CGRectMake(12, cellHeitht*3, cellWidth, cellHeitht);
//    self.workView.frame = CGRectMake(12, cellHeitht*4, cellWidth, cellHeitht);
//    
//    
//    self.companyView.frame = CGRectMake(25, cellHeitht*5, cellWidth-12, cellHeitht);
//    
//    self.schoolView.frame = CGRectMake(25, cellHeitht*5, cellWidth-12, cellHeitht);
//
//    self.positionView.frame = CGRectMake(25, cellHeitht*6, cellWidth-12, cellHeitht);
//    self.majorView.frame = CGRectMake(25, cellHeitht*6, cellWidth-12, cellHeitht);
//
//
//    self.activityView.frame = CGRectMake(12, cellHeitht*7, cellWidth, cellHeitht);
    
    self.contentView.frame = CGRectMake(0, 0, Kwidth, self.qqView.bottom_extension);
    
    
    self.sureButton.frame = CGRectMake(20, self.qqView.bottom_extension+10, Kwidth - 40, 44);
    
    
    
    //
    
    self.topLineView.frame = CGRectMake(0, -0.5, Kwidth, 0.5);
    self.bottomLineView.frame = CGRectMake(0, self.contentView.height_extension-0.5, Kwidth, 0.5);
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
 
    [self endEditing:YES];
    
    
}




-(BOOL)checkInformation{
    
    NSString *showInformation = @"";
    
    if (!self.nameView.valueText.length) {
        
        showInformation = @"请输入姓名";
        
        [self showToolTipbox:showInformation];
        
        return NO;
        
    }
    
    if (![NSString valiMobile:self.phoneView.valueText]) {
        
        showInformation = @"手机号码格式有误";
        
        [self showToolTipbox:showInformation];

        return NO;
        
    }
    
    
    if (![NSString valiQQ:self.qqView.valueText]) {
        
        showInformation = @"QQ号码格式有误";
        [self showToolTipbox:showInformation];

        return NO;
        
    }
    
//    if (self.workView.seletedIndex == 0) {//选择已经工作
//        
//        if (!self.companyView.valueText.length) {
//            
//            showInformation = @"请输入你的公司";
//
//            [self showToolTipbox:showInformation];
//            
//            return NO;
//        }
//        if (!self.positionView.valueText.length) {
//            
//            showInformation = @"请输入你的职位";
//            
//            [self showToolTipbox:showInformation];
//            
//            return NO;
//            
//        }
// 
//    }else{//选择没有工作
//
//        if (!self.schoolView.valueText.length) {
//            
//            showInformation = @"请输入你的学校";
//            
//            [self showToolTipbox:showInformation];
//            
//            return NO;
//        }
//        if (!self.majorView.valueText.length) {
//            
//            showInformation = @"请输入你的专业";
//            
//            [self showToolTipbox:showInformation];
//            
//            return NO;
//            
//        }
// 
//        
//    }
//
//    if (!self.activityView.valueText.length) {
//        
//        showInformation = @"请输入你的兴趣方向";
//        [self showToolTipbox:showInformation];
//
//       return NO;
//    }
    

    return YES;
    
}



-(void)showToolTipbox:(NSString *)showString{
    
    if (showString.length) {
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        GMToast *toasts = [[GMToast alloc]initWithView:window text:showString duration:1.5];
        [toasts show];
    }
    
}

-(void)setUserInfoModel:(JUUserInfoModel *)userInfoModel{
    
    _userInfoModel = userInfoModel;
    
    if ([userInfoModel.cellphone isEqualToString:@"0"])return;
    
    self.qqView.valueText = userInfoModel.qq;
    self.phoneView.valueText = userInfoModel.cellphone;
    self.nameView.valueText = userInfoModel.real_name;
//    self.activityView.valueText = userInfoModel.interest;

//    //1  男    2女
//    
//    if ([userInfoModel.sex isEqualToString:@"1"]) {
//        
//        self.sexView.seletedIndex = 0;
//        
//    }else if ([userInfoModel.sex isEqualToString:@"2"]){
//        
//        self.sexView.seletedIndex = 1;
//        
//    }
//
//
//    
//    
//    //是否工作
//    if ([userInfoModel.is_work isEqualToString:@"1"]) {//代表已经工作
//        self.workView.seletedIndex = 0;
//    }else if ([userInfoModel.is_work isEqualToString:@"0"]){//代表不工作了
//        self.workView.seletedIndex = 1;
//    }
//
//    self.companyView.valueText = userInfoModel.company;
//    self.positionView.valueText = userInfoModel.position;
//    
//    //学校
//    self.schoolView.valueText = userInfoModel.collage;
//    //专业
//    self.majorView.valueText = userInfoModel.major;

}




- (void)dealloc
{
    JUlogFunction
}







@end
