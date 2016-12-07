//
//  YXCustomActionSheet.h
//  YXCustomActionSheet
//
//  Created by Houhua Yan on 16/7/14.
//  Copyright © 2016年 YanHouhua. All rights reserved.
//
#import "Header.h"
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
