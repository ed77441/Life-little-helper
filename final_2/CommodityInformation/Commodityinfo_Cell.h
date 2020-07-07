//
//  Commodityinfo_Cell.h
//  final_2
//
//  Created by eb211-22 on 2020/1/3.
//  Copyright © 2020 Yuntech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Commodityinfo_Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *value_name;
@property (weak, nonatomic) IBOutlet UILabel *value_filter;

@property (weak, nonatomic)NSString *commodity_name;
@property (weak, nonatomic)NSMutableDictionary *commodity_data;

- (void)cellInfoLoad;
- (void)changeSize:(float)w height:(float)h;
- (float)getSize_w;
- (float)getSize_h;


@end

NS_ASSUME_NONNULL_END
