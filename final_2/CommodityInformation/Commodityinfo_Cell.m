//
//  Commodityinfo_Cell.m
//  final_2
//
//  Created by eb211-22 on 2020/1/3.
//  Copyright © 2020 Yuntech. All rights reserved.
//

#import "Commodityinfo_Cell.h"

@implementation Commodityinfo_Cell
{
    float size_w;
    float size_h;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //create label

    //price
    UILabel *price_label = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 1*44.0f, 60.0f, 40.0f)];
    price_label.text = @"Price:";
    price_label.textColor = [UIColor blackColor];
    [self addSubview:price_label];
    //date
    UILabel *date_label = [[UILabel alloc]initWithFrame:CGRectMake(220.0f, 1*44.0f, 60.0f, 40.0f)];
    date_label.text = @"Date:";
    date_label.textColor = [UIColor blackColor];
    [self addSubview:date_label];
    //location
    UILabel *location_label = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 1*88.0f, 80.0f, 40.0f)];
    location_label.text = @"Location:";
    location_label.textColor = [UIColor blackColor];
    [self addSubview:location_label];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)changeViewSize{
    
}


//for other code to use
- (void)cellInfoLoad{
    self.value_name.text = self.commodity_data[@"name"];
    [self.value_name setFrame:CGRectMake(30.0f, 5.0f, size_w-110.0f, 40.0f)];
    [self.value_filter setFrame:CGRectMake(size_w - 100.0f, 20.0f, 90.0f, 22.0f)];
    //create value label
    //price
    UILabel *price_value = [[UILabel alloc]initWithFrame:CGRectMake(100.0f, 1*44.0f, 100.0f, 40.0f)];
    NSString *value = [[NSString alloc]initWithString:self.commodity_data[@"price"]];
    price_value.text = [value stringByAppendingString:@"$"];
    price_value.textColor = [UIColor blackColor];
    [self addSubview:price_value];
    //date
    UILabel *date_value = [[UILabel alloc]initWithFrame:CGRectMake(280.0f, 1*44.0f, size_w - 280.0f, 40.0f)];
    date_value.text = self.commodity_data[@"date"];
    date_value.textColor = [UIColor blackColor];
    [self addSubview:date_value];
    //location
    UILabel *location_value = [[UILabel alloc]initWithFrame:CGRectMake(100.0f, 1*88.0f, size_w - 100.0f, 40.0f)];
    location_value.text = self.commodity_data[@"location"];
    location_value.textColor = [UIColor blackColor];
    [self addSubview:location_value];
}

- (void)changeSize:(float)w height:(float)h{
    size_w = w;
    size_h = h;
}

- (float)getSize_w{
    return size_w;
}

-(float)getSize_h{
    return size_h;
}
@end
