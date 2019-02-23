//
//  AppDelegate.m
//  BLEThermometer-Demo
//
//  Created by 北京爱康泰科技有限责任公司 on 2017/5/17.
//  Copyright © 2017年 北京爱康泰科技有限责任公司. All rights reserved.
//

#import "AppDelegate.h"
#import <BLEThermometer/BLEThermometer.h>
#import "YCAlertController.h"
#import "FUConstants.h"

@interface AppDelegate ()<BLEThermometerDelegate>

@property (nonatomic, assign) NSInteger tempCount;
///  蓝牙连接类型
@property (nonatomic, assign) YCBLEConnectType connectType;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.connectType = YCBLEConnectTypeBinding;
#if !TARGET_OS_SIMULATOR
    [BLEThermometer sharedThermometer].delegate = self;
    // The first call of BLE 'state' will return '.unknown', so call once before scan.
    NSLog(@"Current state: %@", @([BLEThermometer sharedThermometer].bleState));
    
    NSArray *centraManagerIdentifiers = launchOptions[UIApplicationLaunchOptionsBluetoothCentralsKey];
    for (NSString *identifier in centraManagerIdentifiers) {
        if ([identifier isEqualToString:BLE_RESTORE_IDENTIFIER_KEY]) {
            NSLog(@"Get YCBLECentralManagerRIK!");
        }
    }
#endif
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%@---%s", [self class], __FUNCTION__);
    
    //  后台执行任务
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Help Methods

- (void)startScanThenMeasure {
    NSString *state = @"";
    switch ([BLEThermometer sharedThermometer].bleState) {
        case YCBLEStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case YCBLEStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case YCBLEStatePoweredOff:
            state = @"Turn on the Bluetooth on your phone to allow Shecare to be connected.\niOS 11 or above please set Bluetooth 'Allow New Connections'";
            break;
        case YCBLEStateValid:
            if ([BLEThermometer sharedThermometer].activeThermometer != nil) {
                NSLog(@"Connected.");
                return;
            }
            //  start to scan the peripheral
            if ([[BLEThermometer sharedThermometer] connectThermometerWithType:self.connectType macList:@""]) {
                NSLog(@"Has start to scan.");
            } else {
                NSLog(@"Start scan Failed!");
            }
            break;
        case YCBLEStateUnknown:
            break;
        default:
            break;
    }
    if (state.length > 0) {
        [YCAlertController showAlertWithTitle:@"Tips"
                                      message:state
                                cancelHandler:nil
                               confirmHandler:^(UIAlertAction * _Nonnull action) {
                                   
                               }];
    }
}

#pragma mark - BLEThermometerDelegate

- (void)bleThermometerBluetoothDidUpdateState:(YCBLEState)state {
    NSLog(@"state changed %@",@(state));
    //  set the bt state tag
    if (state != CBManagerStatePoweredOn) {
        [BLEThermometer sharedThermometer].activeThermometer = nil;
    }
}

- (void)bleDidConnectThermometer {
    self.tempCount = 0;
    [YCAlertController showAlertWithBody:@"Connected" autoDismiss:YES duration:1.0 finished:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_ConnectPeripheral object:nil];
}

-(void)bleDidFailedToConnectThermometer:(CBPeripheral *) thermometer {
    NSLog(@"%s, thermometer: %@", __FUNCTION__, thermometer);
}

- (void)bleDidDisconnectThermometer:(CBPeripheral *)thermometer error:(NSError *)error {
    NSLog(@"%s, error: %@", __FUNCTION__, error);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_DisconnectPeripheral object:nil];
    [self startScanThenMeasure];
}

- (void)thermometerDidUploadTemperature:(double)temperature timestamp:(NSDate *)timestamp endmeasureFlag:(YCBLEMeasureFlag)flag firmwareVersion:(NSString *)firmwareVersion {
    self.tempCount++;
    NSString *tempStr = [NSString stringWithFormat:@"temp: %.2f, time: %@", temperature, [timestamp descriptionWithLocale:[NSLocale currentLocale]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_GetTemperature object:tempStr];
    
    if (flag == YCBLEMeasureFlagOfflineBegin) {
        
    } else if (flag == YCBLEMeasureFlagOfflineEnd) {
        [[BLEThermometer sharedThermometer] setCleanState:YCBLECommandTypeTempCount value:(Byte)self.tempCount];
        self.tempCount = 0;
    } else if (YCBLEMeasureFlagOnline == flag) {
        self.tempCount = 0;
    }
}

- (void)bleThermometerDidGetThermometerPower:(float)powerValue {
    NSLog(@"%s %@", __FUNCTION__, @(powerValue));
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_GetPowerResult object:@(powerValue)];
}

-(void)bleThermometerDidChangeTempTypeSucceed:(BOOL)succeed {
    NSLog(@"%s %@", __FUNCTION__, succeed ? @"succeed" : @"failed");
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_SetTempTypeResult object:@(succeed)];
}

- (void)bleThermometer:(BLEThermometer *)bleTherm didUpdateSynchronizationDateResult:(YCBLEWriteResult)type {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_SetTimeResult object:@(type)];
    if (type == YCBLEWriteResultSuccess) {
        NSLog(@"%@ Synchronization time success.", [self class]);
    } else {
        NSLog(@"%@ Synchronization time failed.", [self class]);
    }
}
- (void)bleThermometerDidUpdateFirmwareRevision:(NSString *)firmwareRevision {
    NSLog(@"%s, firmware version: %@", __FUNCTION__, firmwareRevision);
}

@end
