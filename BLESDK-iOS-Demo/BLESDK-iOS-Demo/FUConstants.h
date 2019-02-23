//
//  FUConstants.h
//  A31_FU
//
//  Created by 北京爱康泰科技有限责任公司 on 2016/12/7.
//  Copyright © 2016年 北京爱康泰科技有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kConst_RomTest NSLocalizedString(@"kConst_RomTest", nil)
#define kConst_TemperatureTest NSLocalizedString(@"kConst_TemperatureTest", nil)
#define kConst_TestResultUpload NSLocalizedString(@"kConst_TestResultUpload", nil)
#define kConst_GetMACAddress NSLocalizedString(@"kConst_GetMACAddress", nil)
#define kConst_SetTime NSLocalizedString(@"kConst_SetTime", nil)
#define kConst_GetPower NSLocalizedString(@"kConst_GetPower", nil)
#define kConst_SetTemperatureTypeF NSLocalizedString(@"kConst_SetTemperatureTypeF", nil)
#define kConst_SetTemperatureTypeC NSLocalizedString(@"kConst_SetTemperatureTypeC", nil)
#define kConst_ClearAllData NSLocalizedString(@"kConst_ClearAllData", nil)
#define kConst_HomepageTitle NSLocalizedString(@"kConst_HomepageTitle", nil)
#define kConst_HomepageTitleEH NSLocalizedString(@"kConst_HomepageTitleEH", nil)
#define kConst_OK NSLocalizedString(@"kConst_OK", nil)
#define kConst_Cancel NSLocalizedString(@"kConst_Cancel", nil)
#define kConst_Warning NSLocalizedString(@"kConst_Warning", nil)
#define kConst_GoToNextSet NSLocalizedString(@"kConst_GoToNextSet", nil)
#define kConst_StartToDo NSLocalizedString(@"kConst_StartToDo", nil)
#define kConst_SuccessAndElecIs NSLocalizedString(@"kConst_SuccessAndElecIs", nil)
#define kConst_SuccessButIsTooFast NSLocalizedString(@"kConst_SuccessButIsTooFast", nil)
#define kConst_Succeed NSLocalizedString(@"kConst_Succeed", nil)
#define kConst_Fail NSLocalizedString(@"kConst_Fail", nil)
#define kConst_ErrorOccurred NSLocalizedString(@"kConst_ErrorOccurred", nil)
#define kConst_ResultsNotUploaded NSLocalizedString(@"kConst_ResultsNotUploaded", nil)
#define kConst_Uploading NSLocalizedString(@"kConst_Uploading", nil)
#define kConst_NoTemperature NSLocalizedString(@"kConst_NoTemperature", nil)

#define kConst_Number NSLocalizedString(@"kConst_Number", nil)
#define kConst_ScanFailed NSLocalizedString(@"kConst_ScanFailed", nil)

extern NSString *const kNotification_GetMACAddress;
extern NSString *const kNotification_ConnectPeripheral;
extern NSString *const kNotification_DisconnectPeripheral;
extern NSString *const kNotification_SetTimeResult;
extern NSString *const kNotification_SetAlarmResult;
extern NSString *const kNotification_BindingResult;
extern NSString *const kNotification_GetPowerResult;
extern NSString *const kNotification_SetTempTypeResult;
extern NSString *const kNotification_GetTemperature;

typedef NS_ENUM(NSInteger, FUTestType) {
    FUTestTypeNone,
    FUTestTypeGetPower,
    FUTestTypeTransmitTemp,
    FUTestTypeSetTime,
    FUTestTypeSetTempTypeF,
    FUTestTypeSetTempTypeC,
    FUTestTypeGetFirmwareVersion
};

typedef NS_ENUM(NSInteger, FUTestResult) {
    FUTestResultNotConnected,
    FUTestResultConnected,
    FUTestResultSucceed,
    FUTestResultFailed
};

typedef NS_ENUM(NSInteger, FUTempUnit) {
    FUTempUnitC,
    FUTempUnitF
};

#define RGBA(R,G,B,A) ((UIColor*)[UIColor colorWithRed:(R/255.0) green:(G/255.0) blue:(B/255.0) alpha:(A)])
