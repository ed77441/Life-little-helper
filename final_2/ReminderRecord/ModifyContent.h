//
//  ModifyContent.h
//  final_2
//
//  Created by eb211-22 on 2019/12/30.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewHistory.h"
#import "PassingArgsAndUpdate.h"
NS_ASSUME_NONNULL_BEGIN

@interface ModifyContent : UIViewController<PassingArgsAndUpdate>
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *unsetButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIImageView *eraserIcon;
@property (weak, nonatomic) IBOutlet UIImageView *lineIcon;
@property (weak, nonatomic) IBOutlet UIImageView *thoughtsIcon;

@property (weak, nonatomic) IBOutlet UIImageView *hmmIcon;


- (void) update:(nullable NSDictionary *)args;
- (void) passingArg:(NSDictionary *)args ;


@end

NS_ASSUME_NONNULL_END
