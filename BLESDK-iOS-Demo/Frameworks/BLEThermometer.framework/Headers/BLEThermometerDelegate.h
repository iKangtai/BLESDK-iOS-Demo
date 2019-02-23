//
//  BLEThermometerDelegate.h
//  BasalTemperatureShow
//
//  Created by ikangtai on 13-7-14.
//  Copyright (c) 2013年 ikangtai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class BLEThermometer;

/**
 *  The protocol of the BLEThermometer delegate.
 *
 *  The protocol of teh BLEThermometer delegate, encapsulated as the official Profile, http://developer.bluetooth.org/gatt/profiles/Pages/ProfileViewer.aspx?u=org.bluetooth.profile.health_thermometer.xml.
 */
@protocol BLEThermometerDelegate <NSObject>

@optional

#pragma mark link management

/**
 *  Invoked when system has connected the thermometer.
 */
-(void)bleDidConnectThermometer;
/**
 *  Invoked when system has failed to connect to the thermometer.
 */
-(void)bleDidFailedToConnectThermometer:(CBPeripheral *) thermometer;
/**
 *  Invoked when system has disconneted the conencted thermometer.
 */
-(void)bleDidDisconnectThermometer:(CBPeripheral *) thermometer error: (NSError*) error;


-(void)bleDidDiscoverThermometer:(CBPeripheral *)thermometer forService:(CBService *)service firmwareImageCharacteristic:(CBCharacteristic *)characteristic;

#pragma mark update value

/**
 *  Invoked when the temperature measurement has updated.
 *  @param  temperature the updated temperature measurement.
 *  @param  timestamp the timestamp of the measurement.
 *  @param  flag online/offline...
 *  @param  firmwareVersion the version of the firmware.
 */
-(void)thermometerDidUploadTemperature:(double)temperature timestamp:(NSDate*)timestamp endmeasureFlag:(YCBLEMeasureFlag)flag firmwareVersion:(NSString *)firmwareVersion;
/**
 *  Invoked when the firmware revision updated.
 *  @param firmwareRevision the firmware revision.
 */
-(void)bleThermometerDidUpdateFirmwareRevision:(NSString*) firmwareRevision;

-(void)bleThermometer:(BLEThermometer *)bleTherm didUpdateSynchronizationDateResult:(YCBLEWriteResult)type;

-(void)bleThermometerDidUpdateAlarmSettingResult:(YCBLEWriteResult)type;

#pragma mark Bluetooth State monitoring

/**
 *  monitoring the system bluetooth state. Once the system bluetooth state changes, this function will be invoked.
 *
 *  @param state the current state of the system bluetooth.
 *
 */
-(void)bleThermometerBluetoothDidUpdateState:(YCBLEState) state;

///  获取温度计电量结果的回调
-(void)bleThermometerDidGetThermometerPower:(float)powerValue;

///  温度类型结果的回调
-(void)bleThermometerDidChangeTempTypeSucceed:(BOOL)succeed;

///  Invoked when the macAddress updated.
-(void)bleThermometerDidGetMACAddress:(NSString*) macAddress;

@required

@end

@protocol BLEThermometerOADDelegate <NSObject>

@required

-(void)bleThermometerDidReadFirmwareImageType:(YCBLEFirmwareImageReversion)imgReversion;

-(void)bleThermometerDidBeginUpdateFirmwareImage;

-(void)bleThermometerDidUpdateFirmwareImage:(YCBLEOADResultType)type;

-(void)bleThermometerUpdateFirmwareImageProgress:(CGFloat)progress;

@optional

@end
