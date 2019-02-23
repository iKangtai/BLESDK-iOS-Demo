//
//  YCAlertController.h
//  Shecare
//
//  Created by 罗培克 on 16/5/15.
//  Copyright © 2016年 北京爱康泰科技有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCAlertController : UIAlertController

///  普通弹窗
+ (void)showAlertWithTitle:(NSString * _Nullable)title
          message:(NSString * _Nullable)message
    cancelHandler:(void (^ __nullable)(UIAlertAction * _Nonnull action))cancelHandler
   confirmHandler:(void (^ __nullable)(UIAlertAction * _Nonnull action))confirmHandler;

///  显示警告框
+ (void)showAlertWithBody:(NSString * _Nullable)body autoDismiss:(BOOL)autoDismiss duration:(NSTimeInterval)duration finished:(void (^ __nullable)(void))finished;

@end
