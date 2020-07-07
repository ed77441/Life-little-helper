//
//  PurchaseRecord.h
//  final_2
//
//  Created by eb211-22 on 2019/12/29.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseRecord : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *shoppingRecTable;

@end

NS_ASSUME_NONNULL_END
