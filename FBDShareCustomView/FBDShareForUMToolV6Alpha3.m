//
//  FBDShareForUMToolV6Alpha3.m
//  newmedsci
//
//  Created by feng on 2016/11/22.
//  Copyright © 2016年 冯宝东. All rights reserved.
//
#define APPShareImage [UIImage imageNamed:@"Icon-Small-40.png"]
#define SHOW_ALERTdiss(msg) UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];\
[alert show];\
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
[alert dismissWithClickedButtonIndex:0 animated:YES];\
});

#import "FBDShareForUMToolV6Alpha3.h"
static FBDShareForUMToolV6Alpha3* sigleShareTon;
@implementation FBDShareForUMToolV6Alpha3
{
    NSString* removeURLContent;
}

/**
 *      @author 冯宝东
 *
 *      类构造方法
 *
 *      @return 友盟Tool分享实例
 */
+(instancetype)defaultTools
{
    sigleShareTon=[[self alloc] init];
    return sigleShareTon;
}

/**
 开始分享 带有成功回调
 
 @param platformType 平台名称
 @param delegate 代理
 @param successBlock 成功回调
 */
-(void)begainShareToPlanmsName:(UMSocialPlatformType)platformType withDelegate:(id)delegate  withSuccessed:(UMSocialRequestCompletionHandler)successBlock
{
    [self begainShareToPlanmsName:platformType withDelegate:delegate withSuccessed:successBlock failed:nil] ;
}
/**
 开始分享 带有成功回调和失败回调
 
 @param platformType 平台名称
 @param delegate 代理
 @param successBlock 成功回调
 */
-(void)begainShareToPlanmsName:(UMSocialPlatformType)platformType withDelegate:(id)delegate  withSuccessed:(UMSocialRequestCompletionHandler)successBlock failed:(UMSocialRequestCompletionHandler)failedBlock
{
    [self shareWebPageToPlatformType:platformType withDeleagte:delegate];
    self.shareSuccessBlock=successBlock!=nil?successBlock:nil;
    self.shareFailedBlock=(failedBlock!=nil)?failedBlock:nil;
    //优化代码
    //    if (successBlock)
    //    {
    //        self.shareSuccessBlock=successBlock;
    //    }else
    //    {
    //        self.shareSuccessBlock=nil;
    //    }
    //    if (failedBlock) {
    //        self.shareFailedBlock=failedBlock;
    //    }else
    //    {
    //        self.shareFailedBlock=nil;
    //    }
    
    
    
    
}



//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withDeleagte:(id)toolDelegate
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    //    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享标题" descr:@"分享内容描述" thumImage:[UIImage imageNamed:@"icon"]];
    
    id thumbURL=nil;
    // V2.2  对NSLog变成相应的提示 去掉：适配iOS 的ATS https的问题
    
    // V2.1  优化ShareImage的逻辑
    // 空 nil的情况
    if (!_shareImage)
    {
        if (APPShareImage)
        {
            thumbURL=APPShareImage;
        }else
        {
            //本地APP的图标
            NSString* appBundleId=[[NSBundle mainBundle] bundleIdentifier];
            NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
            NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
            UIImage *thumbImage =[UIImage imageNamed:icon];
            thumbURL=thumbImage;
        }
        
    }else
    {
        //如果是字符串
        if ([_shareImage isKindOfClass:[NSString class]])
        {
            //网络地址
            if (([_shareImage isKindOfClass:[NSString class]]&&[_shareImage hasPrefix:@"http://"])||([_shareImage isKindOfClass:[NSString class]]&&[_shareImage hasPrefix:@"https://"]))
            {
                thumbURL=_shareImage;
            }
            //本地地址 图片名字
            else
            {
                thumbURL=[UIImage imageNamed:_shareImage];
            }
            
            //二进制图片
        }else if([_shareImage isKindOfClass:[UIImage class]]||[_shareImage isKindOfClass:[NSData class]])
        {
            thumbURL=_shareImage;
        }
        
    }
    
    if (!thumbURL) {
        SHOW_ALERTdiss(@"请选择一张分享的图片logo");
        return;
    }
    if (!_shareContent) {
        SHOW_ALERTdiss(@"请设置:分享内容描述");
        return;
    }
    if (!_shareTitle)
    {
        SHOW_ALERTdiss(@"请设置:分享标题title");
        return;
    }
    if (!_shareWebURL) {
        SHOW_ALERTdiss(@"请设置:分享的链接URL");
        return;
    }
    //V2.3把分享内容里面的链接去掉文章的URL  思路：用http分割 祛除掉文章的链接 再用http拼接
    removeURLContent=self.shareContent;
    NSArray*contentArray=[removeURLContent componentsSeparatedByString:@"http"];
    //如果有两个URL就去除掉最后的文章的URL
    if (contentArray.count>2)
    {
        NSMutableArray* tempContentArray=[NSMutableArray arrayWithArray:contentArray];
        [tempContentArray removeLastObject];
        removeURLContent=[tempContentArray componentsJoinedByString:@"http"];
    }
    
    //UMSocialPlatformType_Sina 新浪 pod 避免提示重定义
    if (platformType==0) {
        messageObject.text=_shareContent;
    }else
    {
        messageObject.text=removeURLContent;
    }
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_shareTitle descr:removeURLContent thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl =_shareWebURL;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:toolDelegate completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            
            if (self.shareFailedBlock)
            {
                self.shareFailedBlock(data,error);
            }
            
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
            
            if (self.shareSuccessBlock)
            {
                self.shareSuccessBlock(data,nil);
            }
        }
        [self alertWithError:error];
    }];
}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }
    else{
        if (error) {
            NSInteger errorCode= (NSInteger)error.code;
            result=[[self class]  getErrorMsgByErrorCode:errorCode];
        }
        else
        {
            result = [NSString stringWithFormat:@"分享失败"];
        }
        
    }
    SHOW_ALERTdiss(result);
    
}
-(void)fbdShareUM_AboutTitle:(NSString*)title
{
    self.shareTitle=title;
}
-(void)fbdShareUM_AboutContent:(NSString*)content
{
    self.shareContent=content;
}
-(void)fbdShareUM_AboutImage:(id)image
{
    self.shareImage=image;
}
-(void)fbdShareUM_AboutWebURL:(NSString*)webURL
{
    self.shareWebURL=webURL;
}

+(NSString*)getErrorMsgByErrorCode:(NSInteger)code
{
    NSString*resultErrorMSG=@"分享失败";
    NSArray*errorTitleArray=@[@"未知错误",@"未知错误",@"授权失败",
                              @"分享失败",@"请求用户信息失败",@"分享内容为空",
                              @"分享内容不支持",@"schema url fail",@"应用未安装",
                              @"取消操作",@"网络异常",@"第三方错误"];
    NSArray*errorKeyArray=@[@2000,@2001,@2002,@2003,@2004,@2005,@2006,@2007,@2008,@2009,@2010,@2011];
    
    NSDictionary*codeMsgDic=[NSDictionary dictionaryWithObjects:errorTitleArray forKeys:errorKeyArray];
    
    NSString * tempErrorMsg=[codeMsgDic objectForKey:[NSNumber numberWithInteger:code]];
    //需要判断一下 这里的code 是根据友盟code得来的
    if (tempErrorMsg)
    {
        resultErrorMSG=tempErrorMsg;
    }
    return resultErrorMSG;
}


@end
