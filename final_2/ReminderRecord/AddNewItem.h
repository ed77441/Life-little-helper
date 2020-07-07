//
//  AddNewItem.h
//  final_2
//
//  Created by eb211-22 on 2019/12/22.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassingArgsAndUpdate.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddNewItem : UIViewController<UITextViewDelegate, PassingArgsAndUpdate>
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *dialogIcon;
@property (weak, nonatomic) IBOutlet UIImageView *pencilIcon;
@property (weak, nonatomic) IBOutlet UIImageView *lineIcon;
@property (weak, nonatomic) IBOutlet UIImageView *thinkingIcon;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *my;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *unsetButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *infoBox;

- (void) shrinkInfoBox ;
- (void) expandInfoBox ;
- (void) shrinkAndExpandInfoBox ;
- (void) update:(nullable NSDictionary *)args;
- (void) passingArg:(NSDictionary *)args;



@end

NS_ASSUME_NONNULL_END
