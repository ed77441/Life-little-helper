//
//  CommodityInformation.h
//  final_2
//
//  Created by eb211-22 on 2019/12/29.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommodityInformation : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *label_filter;
@property (weak, nonatomic) IBOutlet UITableView *commodity_table;
@property (weak, nonatomic) IBOutlet UIButton *button_sectionDate;
@property (weak, nonatomic) IBOutlet UIButton *button_sectionLocation;


@end

NS_ASSUME_NONNULL_END
