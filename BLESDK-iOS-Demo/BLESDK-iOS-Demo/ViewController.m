//
//  ViewController.m
//  BLESDK-iOS-Demo
//
//  Created by mac on 2019/2/22.
//  Copyright © 2019 ikangtai. All rights reserved.
//

#import "ViewController.h"
#import <BLEThermometer/BLEThermometer.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "FURomTestModel.h"
#import "FUThemTestModel.h"
#import "FUConstants.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (strong, nonatomic) FUThemTestModel *periModel;
@property (strong, nonatomic) NSArray *testArray;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *lightView;

@end

@implementation ViewController

@synthesize periModel = _periModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectPeripheral:) name:kNotification_ConnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disConnectPeripheral:) name:kNotification_DisconnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTimeResult:) name:kNotification_SetTimeResult object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPowerResult:) name:kNotification_GetPowerResult object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTempTypeResult:) name:kNotification_SetTempTypeResult object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTemperature:) name:kNotification_GetTemperature object:nil];
    
    self.lightView.layer.masksToBounds = YES;
    self.lightView.layer.cornerRadius = 20.0f;
    
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 8.0f;
    self.textView.editable = false;
    
    [self periModel];
}

- (IBAction)startScan:(UIButton *)sender {
    [BLEThermometer sharedThermometer].activeThermometer = nil;
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) startScanThenMeasure];
    
    self.textView.attributedText = [[NSAttributedString alloc] init];
    [self.periModel.resultArray removeAllObjects];
}

-(void)setPeriModel:(FUThemTestModel *)periModel {
    _periModel = periModel;
    
    NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] init];
    if (_periModel.resultArray.count > 0) {
        for (NSAttributedString *strI in _periModel.resultArray) {
            [tempStr appendAttributedString:strI];
            [tempStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        }
    }
    
    self.textView.attributedText = tempStr.copy;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@--%s", [self class], __FUNCTION__);
}

#pragma mark - Help Method

-(void)refreshUIWithTestResult:(FUTestResult)testResult {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.periModel = self.periModel;
        switch (testResult) {
            case FUTestResultConnected:
                self.lightView.backgroundColor = [UIColor yellowColor];
                break;
            case FUTestResultNotConnected:
                self.lightView.backgroundColor = [UIColor darkGrayColor];
                break;
            case FUTestResultSucceed: {
                self.lightView.backgroundColor = [UIColor greenColor];
            }
                break;
            case FUTestResultFailed:
                self.lightView.backgroundColor = [UIColor redColor];
                break;
            default:
                break;
        }
    });
}

-(void)startTestWithModel:(FURomTestModel *)testM {
    NSString *typeStr = testM.title;
    
    if ([typeStr isEqualToString:kConst_SetTime]) {
        [[BLEThermometer sharedThermometer] asynchroizationTimeFromLocal:[NSDate date]];
    } else if ([typeStr isEqualToString:kConst_GetPower]) {
        [[BLEThermometer sharedThermometer] setCleanState:YCBLECommandTypeCurrentPower value:0];
    } else if ([typeStr isEqualToString:kConst_SetTemperatureTypeF]) {
        self.periModel.tempUnit = FUTempUnitF;
        [[BLEThermometer sharedThermometer] setCleanState:YCBLECommandTypeTempTypeF value:0];
    } else if ([typeStr isEqualToString:kConst_SetTemperatureTypeC]) {
        self.periModel.tempUnit = FUTempUnitC;
        [[BLEThermometer sharedThermometer] setCleanState:YCBLECommandTypeTempTypeC value:0];
    } else if ([typeStr isEqualToString:kConst_ClearAllData]) {
        [[BLEThermometer sharedThermometer] setCleanState:YCBLECommandTypeCleanAllData value:0];
    }
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:kConst_StartToDo, typeStr] attributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor]}];
    [self.periModel.resultArray addObject:attrStr];
    [self refreshUIWithTestResult:FUTestResultSucceed];
}

///  收到某个测试结果通知后，更新相应数据
-(void)getNotify:(FUTestType)type {
    FURomTestModel *model = [self modelForType:type];
    if (model != nil) {
        UIColor *resultColor = [UIColor greenColor];
        NSString *resultStr = @"";
        if ([model.title isEqualToString:kConst_GetPower]) {
            if (self.periModel.romTestResult.floatValue > 0) {
                resultStr = [NSString stringWithFormat:kConst_SuccessAndElecIs, self.periModel.romTestResult];
                self.periModel.romTestResult = @(FUTestResultSucceed);
            } else {
                resultColor = [UIColor redColor];
                resultStr = [NSString stringWithFormat:kConst_SuccessButIsTooFast, model.title, self.periModel.romTestResult];
                //  提前设置本次测试为：失败
                self.periModel.romTestResult = @(FUTestResultFailed);
            }
        } else {
            resultColor = (FUTestResultSucceed == self.periModel.romTestResult.integerValue ? [UIColor greenColor] : [UIColor redColor]);
            resultStr = [NSString stringWithFormat:@"%@ %@", model.title, (FUTestResultSucceed == self.periModel.romTestResult.integerValue ? kConst_Succeed : kConst_Fail)];
        }
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:resultStr  attributes:@{NSForegroundColorAttributeName : resultColor}];
        [self.periModel.resultArray addObject:attrStr];
        
    } else {
        [SVProgressHUD showErrorWithStatus:kConst_ErrorOccurred];
    }
    
    if (FUTestResultSucceed == self.periModel.romTestResult.integerValue) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self gotoNextStepWithType:type];
        });
    } else {
        //  测试失败
        NSLog(@"Test failed.");
        self.periModel.romTestResult = @(FUTestResultFailed);
    }
    [self refreshUIWithTestResult:(FUTestResult)self.periModel.romTestResult.integerValue];
}

-(FURomTestModel *)nextTestModelWithType:(NSNumber *)type {
    FURomTestModel *model = [self modelForType:type.integerValue];
    if (model != nil) {
        NSInteger index = [self.testArray indexOfObject:model];
        if (index >= self.testArray.count - 1) {
            NSLog(@"Test Finish!");
            return nil;
        }
        NSInteger nextIndex = index + 1;
        return self.testArray[nextIndex];
    } else {
        [SVProgressHUD showErrorWithStatus:kConst_ErrorOccurred];
    }
    return nil;
}

///  进行下一步测试
-(void)gotoNextStepWithType:(FUTestType)type {
    FURomTestModel *model = [self nextTestModelWithType:@(type)];
    if (model != nil) {
        [self startTestWithModel:model];
    } else {
        if (self.periModel.romTestResult.integerValue != FUTestResultFailed) {
            self.periModel.romTestResult = @(FUTestResultSucceed);
            //  测试成功
            NSLog(@"Test succeed.");
        } else {
            //  测试失败
            NSLog(@"Test failed.");
        }
        //  通知温度计传输温度
        [[BLEThermometer sharedThermometer] setCleanState:YCBLECommandTypeTransmitTemp value:0];
    }
}

-(FURomTestModel *)modelForType:(FUTestType)type {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"type = %@", @(type)];
    NSArray *resultArr = [self.testArray filteredArrayUsingPredicate:pred];
    return resultArr.firstObject;
}

#pragma mark - Notification

-(void)connectPeripheral:(NSNotification *)notify {
    ///  外设添加到模型成功 3s 后，开始测试
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *resultStr = [NSString stringWithFormat:@"%@ %@", kConst_GetMACAddress, kConst_Succeed];
        resultStr = [NSString stringWithFormat:@"%@: %@", resultStr, [BLEThermometer sharedThermometer].macAddress];
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:resultStr  attributes:@{NSForegroundColorAttributeName : [UIColor greenColor]}];
        [self.periModel.resultArray addObject:attrStr];
        [self refreshUIWithTestResult:FUTestResultSucceed];
        
        [self startTestWithModel:self.testArray.firstObject];
    });
}

-(void)disConnectPeripheral:(NSNotification *)notify {
    [self refreshUIWithTestResult:FUTestResultNotConnected];
}

-(void)setTimeResult:(NSNotification *)notify {
    YCBLEWriteResult result = (YCBLEWriteResult)((NSNumber *)notify.object).integerValue;
    FUTestResult testResult = YCBLEWriteResultSuccess == result ? FUTestResultSucceed : FUTestResultFailed;
    self.periModel.romTestResult = @(testResult);
    [self getNotify:FUTestTypeSetTime];
}

///  获取电量不会失败
-(void)getPowerResult:(NSNotification *)notify {
    self.periModel.romTestResult = (NSNumber *)notify.object;
    [self getNotify:FUTestTypeGetPower];
}

-(void)setTempTypeResult:(NSNotification *)notify {
    FUTestResult testResult = true == ((NSNumber *)notify.object).boolValue ? FUTestResultSucceed : FUTestResultFailed;
    self.periModel.romTestResult = @(testResult);
    if (self.periModel.tempUnit == FUTempUnitC) {
        [self getNotify:FUTestTypeSetTempTypeC];
    } else {
        [self getNotify:FUTestTypeSetTempTypeF];
    }
}

-(void)getTemperature:(NSNotification *)notify {
    NSAttributedString *tempStr = [[NSAttributedString alloc] initWithString:(NSString *)notify.object];
    [self.periModel.resultArray addObject:tempStr];
    self.periModel.romTestResult = @(FUTestResultSucceed);
    [self refreshUIWithTestResult:FUTestResultSucceed];
}

#pragma mark - Lazy Load

-(FUThemTestModel *)periModel {
    if (_periModel == nil) {
        _periModel = [[FUThemTestModel alloc] init];
    }
    return _periModel;
}

-(NSArray *)testArray {
    if (_testArray == nil) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        [arrM addObject:[FURomTestModel modelWithTitle:kConst_SetTime type:@(FUTestTypeSetTime)]];
        [arrM addObject:[FURomTestModel modelWithTitle:kConst_GetPower type:@(FUTestTypeGetPower)]];
        [arrM addObject:[FURomTestModel modelWithTitle:kConst_SetTemperatureTypeF type:@(FUTestTypeSetTempTypeF)]];
        [arrM addObject:[FURomTestModel modelWithTitle:kConst_SetTemperatureTypeC type:@(FUTestTypeSetTempTypeC)]];
        
        _testArray = arrM.copy;
    }
    return _testArray;
}

@end
