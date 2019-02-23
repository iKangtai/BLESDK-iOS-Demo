//
//  FURomTestModel.h
//  A31_FU
//
//  Created by 北京爱康泰科技有限责任公司 on 2016/12/8.
//  Copyright © 2016年 北京爱康泰科技有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FURomTestModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *type;

+(instancetype)modelWithTitle:(NSString *)title type:(NSNumber *)type;

@end
