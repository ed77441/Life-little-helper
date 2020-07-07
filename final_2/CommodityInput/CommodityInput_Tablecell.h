//
//  CommodityInput_Tablecell.h
//  final_2
//
//  Created by mac16 on 2019/12/24.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommodityInput_Tablecell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lable_name;
@property (weak, nonatomic) IBOutlet UILabel *label_price;
@property (weak, nonatomic) IBOutlet UILabel *label_number;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *cell_labels;


@property (weak, nonatomic) IBOutlet UITextField *text_name;
@property (weak, nonatomic) IBOutlet UITextField *text_price;
@property (weak, nonatomic) IBOutlet UITextField *text_number;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *cell_texts;

@property (weak, nonatomic) IBOutlet UIButton *button_clear;
@property (weak, nonatomic) IBOutlet UILabel *label_num;

@end

NS_ASSUME_NONNULL_END
