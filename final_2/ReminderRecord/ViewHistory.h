//
//  ViewHistory.h
//  final_2
//
//  Created by mac15 on 2019/12/25.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassingArgsAndUpdate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewHistory : UIViewController<UITableViewDataSource, UITableViewDelegate, PassingArgsAndUpdate>
@property (strong, nonatomic) IBOutlet UITableView *history;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

- (void) reloadTable ;
- (void) update:(nullable NSDictionary *)args;
- (void) passingArg:(NSDictionary *)args;

@end

NS_ASSUME_NONNULL_END
