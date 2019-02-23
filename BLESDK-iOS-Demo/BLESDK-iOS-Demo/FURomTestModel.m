//
//  FURomTestModel.m
//  A31_FU
//
//  Created by 北京爱康泰科技有限责任公司 on 2016/12/8.
//  Copyright © 2016年 北京爱康泰科技有限责任公司. All rights reserved.
//

#import "FURomTestModel.h"

@interface FURomTestModel()

@end

@implementation FURomTestModel

-(instancetype)initWithTitle:(NSString *)title type:(NSNumber *)type {
    if (self = [super init]) {
        self.title = title;
        self.type = type;
    }
    return self;
}

+(instancetype)modelWithTitle:(NSString *)title type:(NSNumber *)type {
    return [[self alloc] initWithTitle:title type:type];
}

@end
