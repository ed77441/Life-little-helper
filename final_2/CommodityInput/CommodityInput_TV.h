//
//  CommodityInput_TV.h
//  final_2
//
//  Created by eb211-22 on 2019/12/19.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassingArgsAndUpdate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommodityInput_TV : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, PassingArgsAndUpdate>
@property (weak, nonatomic) IBOutlet UITableView *inputtable;
@property (weak, nonatomic) IBOutlet UIButton *button_add;

@property (weak, nonatomic) IBOutlet UILabel *label_date;
@property (weak, nonatomic) IBOutlet UILabel *label_location;
@property (weak, nonatomic) IBOutlet UIButton *icon_date;
@property (weak, nonatomic) IBOutlet UILabel *text_date;
@property (weak, nonatomic) IBOutlet UITextField *text_location;


-(void)changeViewSize:(float)w height:(float)h;

- (void) update:(nullable NSDictionary *)args;
- (void) passingArg:(NSDictionary *)args;

@end

NS_ASSUME_NONNULL_END
