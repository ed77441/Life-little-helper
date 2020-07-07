//
//  CommodityInput_QR.h
//  final_2
//
//  Created by eb211-22 on 2019/12/19.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassingArgsAndUpdate.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommodityInput_QR : UIViewController<PassingArgsAndUpdate>
@property (weak, nonatomic) IBOutlet UIView *QR_view;
-(void)changeViewSize:(float)w height:(float)h;
- (void)passingArg:(NSDictionary *)args;
- (void)update:(nullable NSDictionary *)args;

@end

NS_ASSUME_NONNULL_END
