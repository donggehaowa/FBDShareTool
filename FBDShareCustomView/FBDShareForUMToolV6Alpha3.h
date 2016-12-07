//
//  FBDShareForUMToolV6Alpha3.h
//  newmedsci
//
//  Created by feng on 2016/11/22.
//  Copyright © 2016年 冯宝东. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Header.h"
#import <UMengUShare/UMSocialCore/UMSocialCore.h>
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


