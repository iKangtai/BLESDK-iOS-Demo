//
//  BLEThermometer.h
//  BLEThermometer
//
//  Created by 北京爱康泰科技有限责任公司 on 16/8/2.
//  Copyright © 2016年 北京爱康泰科技有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#if TARGET_OS_IPHONE
#import <CoreBluetooth/CoreBluetooth.h>
#else
#import <IOBluetooth/IOBluetooth.h>
#endif

#import "BLEThermometerDefines.h"
#import "BLEThermometerDelegate.h"

@interface BLEThermometer : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

///  call back delegate
@property (nonatomic, weak) id <BLEThermometerDelegate> delegate;
///  OAD Delegate
@property (nonatomic, weak) id <BLEThermometerOADDelegate> oadDelegate;
///  the active thermometer conencted to the local central
@property (nonatomic, strong) CBPeripheral *activeThermometer;
///  硬件版本信息
@property (nonatomic, copy) NSString *firmwareVersion;
///  ImageType，OAD 升级的时候使用
@property (nonatomic, assign) YCBLEFirmwareImageReversion image_type;
///  MAC Address
@property (nonatomic, copy) NSString *macAddress;
///  硬件名称
@property (copy, nonatomic) NSString *hardwareName;
///  是否正在 OAD
@property (assign, nonatomic) BOOL isOADing;

///  用于保存 “温度上传” 单元测试的返回值
@property (copy, nonatomic) NSString *testResult;

///  单例
+(instancetype)sharedThermometer;


/**
 * 返回当前设备的 BLE 状态
 */
-(YCBLEState)bleState;

/**
 * Conenct to the specified thermometer.
 *
 * @param thermometer the specified thermometer.
 */
-(void)connectThermometer:(CBPeripheral *) thermometer;

/**
 * 断开当前连接的设备
 */
-(void)disconnectActiveThermometer;

/**
 * 扫描并连接设备。 ⚠️YCShecareV2 必须添加到项目 info.plist 的 LSApplicationQueriesSchemes 白名单里⚠️
 *
 * @param connectType 连接类型：绑定时的连接（可以连接所有设备）；非绑定时的连接（只能连接 “已绑定” 的硬件）
 * @param macList 用户绑定的 MAC 地址列表，形式为逗号分隔的字符串，如 “C8:FD:19:02:92:8D,C8:FD:19:02:92:8E”
 *
 * @return 如果成功开始扫描，返回 true，否则返回 false
 */
-(BOOL)connectThermometerWithType:(YCBLEConnectType)connectType macList:(NSString *)macList;

/**
 *  停止扫描
 */
-(void)stopThermometerScan;

/**
 *  OAD 升级时读取固件 image 类型，必须在 (bleDidDiscoverThermometer:forService:firmwareImageCharacteristic:) 回调方法里调用
 */
-(void)bleThermometerReadFirmwareImageRevision;

/**
 *  OAD 开始的回调
 *
 * @param data 固件安装包的二进制数据
 * @param firmwareVersion 设备版本号
 * @param imageVersion 设备 image 类型
 */
-(void)updateThermometerFirmwareImage:(NSData *)data firmwareVersion:(NSString *)firmwareVersion imageVersion:(YCBLEFirmwareImageReversion)imageVersion;

/**
 *  停止正在进行的 OAD
 */
-(void)stopUpdateThermometerFirmwareImage;

/**
 * 清空温度、修改温度类型、获取电量、给硬件返回接收到的温度数量 和 开始获取温度 等指令
 *
 * @param cleanState 指令类型
 * @param value 指令附加数据，除 YCBLECommandTypeTempCount 类型指令外，其它指令都传入 0 即可
 */
-(void)setCleanState:(YCBLECommandType)cleanState value:(Byte)value;

/**
 * 绑定指令，二代设备专用
 *
 * @param bindValue 0 表示绑定
 */
-(void)setBindState:(NSInteger)bindValue;

/**
 * 同步设备时间
 *
 * @param date 时间
 */
-(void)asynchroizationTimeFromLocal:(NSDate *)date;

/**
 * 发送 “可怀孕期” 到硬件，二代设备专用
 *
 * @param startDate 可怀孕期开始时间
 * @param endDate 可怀孕期结束时间
 */
-(void)sendPregnancyWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

/**
 * 设置硬件闹钟，一代老设备专用
 */
-(void)setFirmwareAlarmTime:(NSDate *)date open:(BOOL)open;

@end
