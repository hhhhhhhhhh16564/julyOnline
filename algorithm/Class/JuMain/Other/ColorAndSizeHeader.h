//
//  ColorAndSizeHeader.h
//  七月算法_iPad
//
//  Created by 周磊 on 16/5/25.
//  Copyright © 2016年 zhl. All rights reserved.
//

#ifndef ColorAndSizeHeader_h
#define ColorAndSizeHeader_h



#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)



//颜色
#define kColorRGB(r, g, b, a) ([UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:a])

// 随机色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]
//颜色字符串
#define Kcolor16rgb(s, a)  ([UIColor colorWithHexString:s alpha:a]);



//字号大小
#define UIptfont(pt) [UIFont systemFontOfSize:pt]
#define UIpxfont(px) [UIFont systemFontOfSize:(px / 96.0 * 72)]

//几种主要的颜色

//主色蓝
#define Hmblue(a) (kColorRGB(0, 153, 255, a))
//主色黑
#define Hmblack(a) (kColorRGB(51, 51, 51, a))
//主色红
#define Hmred(a) kColorRGB(242, 76, 60, a)
//主色绿
#define Hmgreen(a) kColorRGB(29, 201, 136, a)
//主色紫
#define Hmpurple(a) kColorRGB(177, 114, 207, a)


//辅色灰
#define Hcgray(a) kColorRGB(153, 153, 153, a)

//button灰
#define Hbuttongray(a) kColorRGB(226, 226, 226, a)

//普通分割线
#define HCommomSeperatorline(a) kColorRGB(221, 221, 221, a)

//特殊分割线
#define HSpecialSeperatorline(a) kColorRGB(204, 204, 204, a)

//画布色
#define HCanvasColor(a) kColorRGB(244, 244, 244, a)


//橘黄色   #fffeea
#define HCOrange(a) Kcolor16rgb(@"#fa952f", a)

//青黄色
#define HClightYellow(a) Kcolor16rgb(@"#fffeea", a)


#define Kwidth [UIScreen mainScreen].bounds.size.width
#define Kheight [UIScreen mainScreen].bounds.size.height





#define KMultiplier 0.5 







//判断机型尺寸
#define ISIPhone4 ([UIScreen mainScreen].bounds.size.height == 480.0)
#define ISIPhone5 ([UIScreen mainScreen].bounds.size.height == 568.0)
#define ISIPhone6 ([UIScreen mainScreen].bounds.size.height == 667.0)
#define ISIPhone6P ([UIScreen mainScreen].bounds.size.height == 736.0)
#define ISIPad [UIScreen mainScreen].bounds.size.height >= 1024.0 | [UIScreen mainScreen].bounds.size.width >= 1024.0





#pragma mark 玄中心设计
//********************************************************************************************************************************************************************************************************************************************//



//********************************************************************************************************************************************************************************************************************************************//















































#endif /* ColorAndSizeHeader_h */
