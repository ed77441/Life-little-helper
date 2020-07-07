//
//  YearMonthPicker.m
//  final_2
//
//  Created by eb211-22 on 2020/1/5.
//  Copyright © 2020 Yuntech. All rights reserved.
//

#import "YearMonthPicker.h"

@interface YearMonthPicker () {
    NSArray *years, *months;
    id <PassingArgsAndUpdate> parent;
}
@end

@implementation YearMonthPicker

@synthesize yearMonthPicker;
@synthesize confirmButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    months = @[@"Jan.", @"Feb.", @"Mar.", @"Apr.", @"May", @"June", @"July", @"Aug.", @"Sep.", @"Oct.", @"Nov.", @"Dec."];
    
    NSMutableArray *marr = [[NSMutableArray alloc] init];
    
    for (int i = 1000; i < 5000; ++i) {
        [marr addObject: [[NSString alloc] initWithFormat: @"%d", i]];
    }
    
    years = marr;
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents *currentdayComponents =
    [cal components:(NSCalendarUnitDay |
                     NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
    
    NSInteger year = currentdayComponents.year;
    NSInteger month = currentdayComponents.month;
    
    NSString *yearStr = [[NSString alloc] initWithFormat: @"%ld", year];
    NSInteger yIdx = [years indexOfObject: yearStr];

    yearMonthPicker.delegate = self;
    yearMonthPicker.dataSource = self;
    
    
    [yearMonthPicker selectRow:month-1 inComponent:0 animated:NO];
    [yearMonthPicker selectRow:yIdx inComponent:1 animated:NO];
    
    [self.view setBackgroundColor: [UIColor colorWithRed: 60/255.0 green: 60/255.0 blue: 60/255.0 alpha:1]];
    [yearMonthPicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    [yearMonthPicker setBackgroundColor: [UIColor clearColor]];
    [confirmButton.titleLabel setFont : [UIFont fontWithName: @"AvenirNext-MediumItalic" size: 20] ];
    [confirmButton setBackgroundColor: [UIColor colorWithRed: 0 green: 179/255.0 blue:134/255.0 alpha: 1]];
    [confirmButton.layer setMasksToBounds: true];
    [confirmButton.layer setCornerRadius: 5.0f];
    [confirmButton setTitleColor: [UIColor whiteColor
                                   ] forState:UIControlStateNormal];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return component == 0 ? [months count] : [years count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return component == 0 ? [months objectAtIndex: row] : [years objectAtIndex: row];
}

- (IBAction)confirm:(id)sender {
    NSInteger m = [yearMonthPicker selectedRowInComponent: 0] ;
    NSInteger yIdx = [yearMonthPicker selectedRowInComponent: 1] ;
 
    NSInteger y = ((NSString*)[years objectAtIndex: yIdx]).intValue;

    [parent update: @{@"year" : @(y), @"month": @(m)}];
    [self dismissViewControllerAnimated: true completion: nil];
}


- (void) update:(nullable NSDictionary *)args {}

- (void) passingArg:(NSDictionary *)args {
    parent = [args objectForKey: @"parent"];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

@end
