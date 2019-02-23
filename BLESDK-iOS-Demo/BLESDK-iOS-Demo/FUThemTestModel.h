//
//  FUThemTestModel.h
//  A31_FU
//
//  Created by 北京爱康泰科技有限责任公司 on 2016/12/8.
//  Copyright © 2016年 北京爱康泰科技有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "FUConstants.h"

@interface FUThemTestModel : NSObject

///  Cell 标题
@property (nonatomic, copy) NSString *cellTitle;
///  温度字符串组成的数组
@property (nonatomic, strong) NSMutableArray *resultArray;
///  ROM 测试结果/模型状态
@property (strong, nonatomic) NSNumber *romTestResult;
///  获取到的固件版本信息
@property (copy, nonatomic) NSString *firmwareVersion;

@property (assign, nonatomic) FUTempUnit tempUnit;

@property (assign, nonatomic) BOOL canAddNewPeripheral;

@property(strong, nonatomic)CBCharacteristic *setTime;
@property(strong, nonatomic)CBCharacteristic *setTemperatureType;
@property(strong, nonatomic)CBCharacteristic *commandOfBind;
@property(strong, nonatomic)CBCharacteristic *adjustedTemp;
@property(strong, nonatomic)CBCharacteristic *cleanAllData;
@property(strong, nonatomic)CBCharacteristic *getFirmwareVersion;

@end
