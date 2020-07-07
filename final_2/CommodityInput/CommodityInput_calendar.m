//
//  CommodityInput_calendar.m
//  final_2
//
//  Created by eb211-22 on 2020/1/6.
//  Copyright © 2020 Yuntech. All rights reserved.
//

#import "CommodityInput_calendar.h"

@interface CommodityInput_calendar () {
    id <PassingArgsAndUpdate> parent;
}

@end

@implementation CommodityInput_calendar
@synthesize datePicker;
@synthesize confirmButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)confirm:(id)sender {
    NSDate *date = datePicker.date;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];

    [parent update: @{@"action": @"datePicker" ,@"year": @(year), @"month": @(month), @"day": @(day)}];
    
    
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

- (void) update:(nullable NSDictionary *)args {};
- (void) passingArg:(NSDictionary *)args {
    parent = args[@"parent"];
};
@end
