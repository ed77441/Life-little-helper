//
//  TimePicker.m
//  final_2
//
//  Created by eb211-22 on 2019/12/24.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import "TimePicker.h"

@interface TimePicker () {
    id <PassingArgsAndUpdate> parent;
}

@end

@implementation TimePicker
@synthesize timePicker;
@synthesize confirmButton;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor: [UIColor colorWithRed: 60/255.0 green: 60/255.0 blue: 60/255.0 alpha:1]];
    [timePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    [timePicker setBackgroundColor: [UIColor clearColor]];
    [confirmButton.titleLabel setFont : [UIFont fontWithName: @"AvenirNext-MediumItalic" size: 20] ];
    [confirmButton setBackgroundColor: [UIColor colorWithRed: 0 green: 179/255.0 blue:134/255.0 alpha: 1]];
    [confirmButton.layer setMasksToBounds: true];
    [confirmButton.layer setCornerRadius: 5.0f];
}

- (IBAction)confirm:(id)sender {
    NSDate *date = timePicker.date;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];

    [parent update: @{@"hour": @(hour), @"min": @(minute)}];
    
    
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}


- (void) passingArg:(NSDictionary *)args {
    parent = [args objectForKey: @"parent"];
}


- (void) update:(nullable NSDictionary *)args {}
@end
