# *FBDShareTool的工具类*
# 使用说明：

#### 1.在pod 文件中直接写一句话：pod 'FBDShareTool', :git => 'https://github.com/donggehaowa/FBDShareTool.git'
#### 2.然后 在命令行中 pod install ；

#### 3.pod 成功之后 回到xcode中直接 COM+R 键组合；

#### 4.需要调用分享的文件中导入头文件：#import FBDShareHeader.h和#import FBDShareForUMToolV6Alpha3.h

#### 5.写代码

```
    FBDShareForUMToolV6Alpha3*shareUMTools=[FBDShareForUMToolV6Alpha3 defaultTools];
    shareUMTools.shareImage=nil;
    shareUMTools.shareTitle=@"梅斯医学开通病例讨论了";
    shareUMTools.shareContent=contentStr;
    shareUMTools.shareWebURL=strUrl;
    //分享的UI部分
    YXCustomActionSheet *cusSheet = [[YXCustomActionSheet alloc] init];
    //        cusSheet.isShowMoreCostomPlatform=YES;
    [cusSheet showInView:[UIApplication sharedApplication].keyWindow contentArray:nil itemClickBlock:^(id obj) {
        YXActionSheetButton* btn=(YXActionSheetButton*)obj;
        NSDictionary* indexDic=[cusSheet.costomPlatformArray objectAtIndex:btn.tag];
        NSString* indexItemName=[indexDic objectForKey:@"name"];
        NSInteger platformIndex=[[indexDic objectForKey:@"UMSocialPlatformType"] integerValue];
        //分享的逻辑部分
        [shareUMTools  begainShareToPlanmsName:platformIndex withDelegate:self withSuccessed:^(id result, NSError *error) {
            
        }];
    }];
```

# 详细分析
FBDShareHeader 头文件里面包含主要的UI控件的类
```
#ifndef FBDShareHeader_h
#define FBDShareHeader_h
#import "YXCustomActionSheet.h"
#import "YXScrollowActionSheet.h"
#endif /* FBDShareHeader_h */
```
YXCustomActionSheet 类是主要的UI类 提供了Block的点击回调 也可以用常规的Delegate 回调协议;
```
//
//  YXCustomActionSheet.h
//  YXCustomActionSheet
//
//  Created by Houhua Yan on 16/7/14.
//  Copyright © 2016年 YanHouhua. All rights reserved.
//
//#import "Header.h"
#define SHOW_ALERTdiss  
typedef void(^ActionIdBlock)(id obj);
#import <UIKit/UIKit.h>
#import "YXActionSheetButton.h"

@protocol YXCustomActionSheetDelegate <NSObject>

@optional

- (void) customActionSheetButtonClick:(YXActionSheetButton *) btn;

@end


@interface YXCustomActionSheet : UIView

@property (nonatomic,copy)ActionIdBlock clickedItemBlock;

//冯宝东自定义的Alert数据数组 (具有检测APP安装的功能)
@property (nonatomic,strong)NSMutableArray*costomPlatformArray;
@property (assign)  BOOL  isShowMoreCostomPlatform; //是否显示更多的自定义平台


/**展示*/
- (void)showInView:(UIView *)superView contentArray:(NSArray *)contentArray;
/*
 展示带有block 的回调
 */
- (void)showInView:(UIView *)superView contentArray:(NSArray *)contentArray itemClickBlock:(ActionIdBlock)itemBlock;

@property (nonatomic) id<YXCustomActionSheetDelegate> delegate;

@end

```
FBDShareForUMToolV6Alpha3 是基于 UM 友盟的ShareCore的进行分享的逻辑，具体API请看下面的代码；

```
//
//  FBDShareForUMToolV6Alpha3.h
//  newmedsci
//
//  Created by feng on 2016/11/22.
//  Copyright © 2016年 冯宝东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>
@protocol FBDShareForUMToolV6Alpha3ShareProtocol <NSObject>
@required
-(void)fbdShareUM_AboutTitle:(NSString*)title;
-(void)fbdShareUM_AboutContent:(NSString*)content;
-(void)fbdShareUM_AboutImage:(id)image;
-(void)fbdShareUM_AboutWebURL:(NSString*)webURL;

@end
@interface FBDShareForUMToolV6Alpha3 : NSObject<FBDShareForUMToolV6Alpha3ShareProtocol>

//分享成功失败的回调
@property (nonatomic,copy)UMSocialRequestCompletionHandler shareSuccessBlock;
@property (nonatomic,copy)UMSocialRequestCompletionHandler shareFailedBlock;


//分享的 标题 内容 图片
@property (nonatomic,strong)NSString*shareTitle;
@property (nonatomic,strong)NSString*shareContent;
@property (nonatomic,strong)id shareImage;
@property (nonatomic,strong)NSString*shareWebURL;






/**`
 *      @author 冯宝东
 *
 *      类构造方法
 *
 *      @return 友盟Tool分享实例
 */
+(instancetype)defaultTools;

/**
 开始分享 带有成功回调

 @param platformType 平台名称
 @param delegate 代理
 @param successBlock 成功回调
 */
-(void)begainShareToPlanmsName:(UMSocialPlatformType)platformType withDelegate:(id)delegate  withSuccessed:(UMSocialRequestCompletionHandler)successBlock;

/**
 开始分享 带有成功回调和失败回调
 
 @param platformType 平台名称
 @param delegate 代理
 @param successBlock 成功回调
 */
-(void)begainShareToPlanmsName:(UMSocialPlatformType)platformType withDelegate:(id)delegate  withSuccessed:(UMSocialRequestCompletionHandler)successBlock failed:(UMSocialRequestCompletionHandler)failedBlock;


@end



```
###  更新说明：
#### // V2.2  对NSLog变成相应的提示 去掉：适配iOS 的ATS https的问题


