//
//  ViewController.h
//  final_2
//
//  Created by mac15 on 2019/12/10.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassingArgsAndUpdate.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, PassingArgsAndUpdate>
@property (strong, nonatomic) IBOutlet UICollectionView *myCollection;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UIButton *button_commodityInput;
@property (weak, nonatomic) IBOutlet UIButton *button_purchaseRecord;
@property (weak, nonatomic) IBOutlet UIButton *button_commodityInfo;
@property (weak, nonatomic) NSString *main_imagename;
@property (weak, nonatomic) IBOutlet UIImageView *main_image;
@property (weak, nonatomic) IBOutlet UIView *calendarView;

- (void) update:(nullable NSDictionary *)args;


- (void) passingArg:(NSDictionary*)args;

@end

