//
//  YearMonthPicker.h
//  final_2
//
//  Created by eb211-22 on 2020/1/5.
//  Copyright © 2020 Yuntech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassingArgsAndUpdate.h"
NS_ASSUME_NONNULL_BEGIN

@interface YearMonthPicker : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverControllerDelegate, PassingArgsAndUpdate>
@property (weak, nonatomic) IBOutlet UIPickerView *yearMonthPicker;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
- (void) update:(nullable NSDictionary *)args;
- (void) passingArg:(NSDictionary *)args;

@end

NS_ASSUME_NONNULL_END
