//
//  BLEThermometerDefines.h
//  BasalTemperatureShow
//
//  Created by ikangtai on 13-6-30.
//  Copyright (c) 2013年 ikangtai. All rights reserved.
//

#ifndef BasalTemperatureShow_BLEThermometerDefines_h
#define BasalTemperatureShow_BLEThermometerDefines_h

///  the gap and gatt service uuid
#define GENERIC_ACCESS_SERVICE_UUID @"1800"
#define GENERIC_ATTRIBUTE_SERVICE_UUID @"1801"

///  standard healthy thermometer service uuid
#define BLE_HEALTHY_THERMOMETER_SERVICE_UUID                                    @"1809"
#define IKT_THEMOMETER_TEMPERATURE_UUID                                         @"2A1C"

#define BLE_DEVICE_INFORMATION_SERVICE_UUID                                     @"180A"
#define IKT_DEVICEINFO_MAC_ADDRESS_UUID                                         @"2A23"
#define IKT_DEVICEINFO_HARDWAREVERSION_UUID                                     @"2A27"
#define IKT_DEVICEINFO_FIRMWAREVERSION_UUID                                     @"2A26"
#define IKT_THEMOMETER_SET_TIME_UUID                                            @"3031"
#define BLE_DEVICE_INFORMATION_ALARM_SETTING_CHARACTERISTIC_UUID                @"3032"
///  清空温度和关机、获取电量、设置温度类型
#define IKT_THEMOMETER_CLEAN_ALL_DATA_UUID                                      @"3033"
///  设置温度单位（A31 专用）
#define IKT_THEMOMETER_A31_SET_TEMPERATURE_TYPE_UUID                            @"3034"
#define IKT_THEMOMETER_BIND_UUID                                                @"303C"
///  发送 “可怀孕期” 到硬件
#define IKT_THEMOMETER_SEND_PREGNANCY_UUID                                      @"3035"

#define BLE_DEVICE_INFORMATION_OAD_IMAGE_REVISION_CHARACTERISTIC_UUID           @"0xF000FFC1-0451-4000-B000-000000000000"
///  OAD Service UUID
#define BLE_DEVICE_INFORMATION_OAD_SERVICE_UUID                                 @"0xF000FFC0-0451-4000-B000-000000000000"
///  OAD Image Block Request UUID
#define BLE_DEVICE_INFORMATION_OAD_IMAGE_BLOCK_REQUEST_CHARACTERISTIC_UUID      @"0xF000FFC2-0451-4000-B000-000000000000"

///  CBCentralManagerOptionRestoreIdentifierKey
#define BLE_RESTORE_IDENTIFIER_KEY      @"YCBLECentralManagerRIK"

///  向硬件发送的指令类型
typedef NS_ENUM(NSInteger, YCBLECommandType) {
    ///  清空数据
    YCBLECommandTypeCleanAllData = 0,
    ///  关机
    YCBLECommandTypeShutDown,
    ///  OAD
    YCBLECommandTypeOAD,
    ///  获取电量
    YCBLECommandTypeCurrentPower,
    ///  温度类型°C
    YCBLECommandTypeTempTypeC,
    ///  温度类型°F
    YCBLECommandTypeTempTypeF,
    ///  返回接收到的温度数量
    YCBLECommandTypeTempCount,
    ///  通知温度计传输温度
    YCBLECommandTypeTransmitTemp
};

///  用户硬件镜像版本
typedef NS_ENUM(NSInteger, YCBLEFirmwareImageReversion) {
    ///  未知版本
    YCBLEFirmwareImageReversionUnknown,
    ///  A 版本
    YCBLEFirmwareImageReversionA,
    ///  B 版本
    YCBLEFirmwareImageReversionB,
};

///  蓝牙连接类型
typedef NS_ENUM(NSInteger, YCBLEConnectType) {
    ///  绑定时的连接（可以连接所有设备）
    YCBLEConnectTypeBinding     = 0,
    ///  非绑定时的连接（只能连接 “已绑定” 的硬件）
    YCBLEConnectTypeNotBinding  = 1
};

///  温度测量标志位
typedef NS_ENUM(NSInteger, YCBLEMeasureFlag) {
    ///  在线测量
    YCBLEMeasureFlagOnline,
    ///  离线测量开始（批量上传时的第一条数据）
    YCBLEMeasureFlagOfflineBegin,
    ///  离线测量结束（批量上传时的最后一条数据）
    YCBLEMeasureFlagOfflineEnd,
    ///  未知状态
    YCBLEMeasureFlagUnknownFlag
};

///  蓝牙状态定义
typedef NS_ENUM(NSInteger, YCBLEState) {
    ///  有效
    YCBLEStateValid = 0,
    ///  未知状态
    YCBLEStateUnknown,
    ///  不支持 BLE
    YCBLEStateUnsupported,
    ///  用户未授权
    YCBLEStateUnauthorized,
    ///  BLE 关闭
    YCBLEStatePoweredOff,
    ///  Resetting
    YCBLEStateResetting
};

///  指令发送结果
typedef NS_ENUM(NSInteger, YCBLEWriteResult) {
    ///  成功
    YCBLEWriteResultSuccess,
    ///  发生错误
    YCBLEWriteResultError,
    ///  未知结果
    YCBLEWriteResultUnknowValue,
    ///  异常错误
    YCBLEWriteResultUnexecpetedErrow
};

///  OAD 错误类型
typedef NS_ENUM(NSInteger, YCBLEOADResultType) {
    ///  OAD 成功结束
    YCBLEOADResultTypeSucceed   = 0,
    ///  PAD 失败（指令发送结束 2s 后，还没有断开连接）
    YCBLEOADResultTypeFailed    = 1,
    ///  OAD 正在运行
    YCBLEOADResultTypeIsRunning = 2,
};

//  把 BLEInfo 宏定义放到这里，并不能控制静态库的日志输出。因为 “宏” 是编译前替换，不是运行时判断
///  定义日志输出等级
#ifdef DEBUG
#define kDefaultBLEDebugLevel 3
#else
#define kDefaultBLEDebugLevel 2
#endif

#define BLEInfo(format, ...)                                                \
do{                                                                         \
    if (kDefaultBLEDebugLevel >= 2){                                        \
        NSLog(@" <%@:(%d)> %@\n",                                           \
        [[NSString stringWithUTF8String:__FILE__] lastPathComponent],       \
        __LINE__,                                                           \
        [NSString stringWithFormat:(format),## __VA_ARGS__]);               \
    }                                                                       \
}while(0)

#define BLEDebug(format, ...)                                               \
do{                                                                         \
    if (kDefaultBLEDebugLevel >= 3){                                        \
        NSLog(@"\nDebugLog <%@:(%d)> %@\n",                                 \
        [[NSString stringWithUTF8String:__FILE__] lastPathComponent],       \
        __LINE__,                                                           \
        [NSString stringWithFormat:(format),## __VA_ARGS__]);               \
    }                                                                       \
}while(0)

#endif
