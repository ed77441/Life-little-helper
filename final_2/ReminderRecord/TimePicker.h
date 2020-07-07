//
//  TimePicker.h
//  final_2
//
//  Created by eb211-22 on 2019/12/24.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassingArgsAndUpdate.h"
NS_ASSUME_NONNULL_BEGIN

@interface TimePicker : UIViewController<UIPopoverControllerDelegate, PassingArgsAndUpdate>
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

- (void) update:(nullable NSDictionary *)args;
- (void) passingArg:(NSDictionary *)args;
@end

NS_ASSUME_NONNULL_END
