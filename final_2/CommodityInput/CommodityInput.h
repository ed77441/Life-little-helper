//
//  CommodityInput.h
//  final_2
//
//  Created by eb211-22 on 2019/12/16.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "CommodityInput_QR.h"
#include "CommodityInput_TV.h"
#include "PassingArgsAndUpdate.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommodityInput : UIViewController<PassingArgsAndUpdate>

@property (weak, nonatomic) IBOutlet UIButton *choose_input;
@property (weak, nonatomic) IBOutlet UIButton *choose_qrcode;
@property (weak, nonatomic) IBOutlet UIView *input_view;


- (void) update:(nullable NSDictionary *)args;
- (void) passingArg:(NSDictionary *)args;
@end

NS_ASSUME_NONNULL_END
