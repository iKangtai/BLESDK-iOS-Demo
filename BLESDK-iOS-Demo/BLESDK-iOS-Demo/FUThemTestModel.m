//
//  FUThemTestModel.m
//  A31_FU
//
//  Created by 北京爱康泰科技有限责任公司 on 2016/12/8.
//  Copyright © 2016年 北京爱康泰科技有限责任公司. All rights reserved.
//

#import "FUThemTestModel.h"

@implementation FUThemTestModel

-(instancetype)init {
    if (self = [super init]) {
        self.resultArray = [NSMutableArray array];
        self.cellTitle = @"";
        self.romTestResult = @(FUTestResultNotConnected);
        self.canAddNewPeripheral = YES;
    }
    return self;
}

@end
