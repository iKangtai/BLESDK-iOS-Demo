//
//  YCAlertController.m
//  Shecare
//
//  Created by 罗培克 on 16/5/15.
//  Copyright © 2016年 北京爱康泰科技有限责任公司. All rights reserved.
//

#import "YCAlertController.h"
#import "YCViewController+Extension.h"

#pragma mark - YCAlertContainer implementation

@interface YCAlertContainer : NSObject

///  alertController 组成的数组
@property (strong, nonatomic) NSMutableArray<YCAlertController *> *alertControllers;

@end

@implementation YCAlertContainer

+ (instancetype)sharedContainer {
    static YCAlertContainer *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YCAlertContainer alloc] init];
    });
    return instance;
}

#pragma mark - lazy load

-(NSMutableArray *)alertControllers {
    if (_alertControllers == nil) {
        _alertControllers = [[NSMutableArray alloc] init];
    }
    return _alertControllers;
}

@end

#pragma mark - YCAlertController implementation

@interface YCAlertController ()

///  auto dismiss
@property (assign, nonatomic) BOOL autoDismiss;
///  call back
@property (nonatomic, copy) void (^finished)(void);

@end

@implementation YCAlertController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //  使用 alertControllers 数组引用所有的弹窗，在弹窗互相影响的时候做出处理
    if (![[YCAlertContainer sharedContainer].alertControllers containsObject:self]) {
        [[YCAlertContainer sharedContainer].alertControllers addObject:self];
    }
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
             cancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler
            confirmHandler:(void (^ __nullable)(UIAlertAction *action))confirmHandler {
    YCAlertController *alertC = [YCAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelHandler != nil) {
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:cancelHandler];
        [alertC addAction:cancelAct];
    }
    
    UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:confirmHandler];
    [alertC addAction:confirmAct];
    
    //  避免重复弹出同一个弹窗
    UIViewController *currentVC = [UIViewController currentViewController];
    if ([currentVC isKindOfClass:[YCAlertController class]]) {
        YCAlertController *currentAlertC = (YCAlertController *)currentVC;
        if ([currentAlertC.title isEqualToString:title] && [currentAlertC.message isEqualToString:message]) {
            return;
        }
    }
    
    NSLog(@"Show alert with title :%@, message: %@", title, message);
    dispatch_async(dispatch_get_main_queue(), ^{
        [currentVC presentViewController:alertC animated:YES completion:nil];
    });
}

+ (void)showAlertWithBody:(NSString *)body autoDismiss:(BOOL)autoDismiss duration:(NSTimeInterval)duration finished:(void (^)(void))finished {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = @"Tips";
        YCAlertController *alertC;
        if (autoDismiss) {
            alertC = [YCAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAct = [UIAlertAction actionWithTitle:body style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alertC dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertC addAction:alertAct];
        } else {
            alertC = [YCAlertController alertControllerWithTitle:title message:body preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (alertC.finished != nil) {
                    alertC.finished();
                    alertC.finished = nil;
                }
                [alertC dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertC addAction:alertAct];
        }
        
        alertC.autoDismiss = autoDismiss;
        alertC.finished = finished;
        [[UIViewController currentViewController] presentViewController:alertC animated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (autoDismiss) {
                if (alertC.finished != nil) {
                    alertC.finished();
                    alertC.finished = nil;
                }
                [alertC dismissViewControllerAnimated:YES completion:nil];
            }
        });
    });
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if (self.autoDismiss) {
        NSUInteger count = [YCAlertContainer sharedContainer].alertControllers.count;
        NSInteger idx = [self indexInSharedArray];
        if (idx == -1) {
            [self removeFromArray];
            [super dismissViewControllerAnimated:flag completion:completion];
        } else if (idx == count - 1) {
            [self removeFromArray];
            [super dismissViewControllerAnimated:flag completion:completion];
        } else {
            for (int i = (int)count - 1; i >= 0 && [YCAlertContainer sharedContainer].alertControllers.count != 0; i--) {
                YCAlertController *alertC = [YCAlertContainer sharedContainer].alertControllers[i];
                if ([alertC isEqual:self]) {
                    [self removeFromArray];
                    [super dismissViewControllerAnimated:flag completion:completion];
                } else {
                    [[YCAlertContainer sharedContainer].alertControllers removeObject:alertC];
                    if (alertC.finished != nil) {
                        alertC.finished();
                        alertC.finished = nil;
                    }
                    [alertC dismissViewControllerAnimated:YES completion:nil];
                }
            }
        }
    } else {
        [self removeFromArray];
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}

-(void)removeFromArray {
    if ([[YCAlertContainer sharedContainer].alertControllers containsObject:self]) {
        [[YCAlertContainer sharedContainer].alertControllers removeObject:self];
    }
}

-(NSInteger)indexInSharedArray {
    __block NSInteger result = -1;
    [[YCAlertContainer sharedContainer].alertControllers enumerateObjectsUsingBlock:^(YCAlertController *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqual:self]) {
            result = idx;
            *stop = YES;
        }
    }];
    return result;
}

-(void)dealloc {
    NSLog(@"%@--%s", self.class, __func__);
}

#pragma mark - InterfaceOrientations

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
