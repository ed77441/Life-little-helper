//
//  ModifyContent.m
//  final_2
//
//  Created by eb211-22 on 2019/12/30.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import "ModifyContent.h"
#import "ViewHistory.h"
#import "DBManager.h"
#import "TimePicker.h"
#import "NotificationManager.h"
#import "Utility.h"
@interface ModifyContent () {
    NSDictionary *dict;
    NSInteger pos;
    ViewHistory *parent;
    NSInteger hour, min;
}

@end

@implementation ModifyContent

@synthesize titleText;
@synthesize contentText;
@synthesize modifyButton;
@synthesize unsetButton;
@synthesize timeLabel;
@synthesize titleLabel;
@synthesize contentLabel;
@synthesize clearButton;

@synthesize eraserIcon;
@synthesize lineIcon;
@synthesize thoughtsIcon;
@synthesize hmmIcon;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [titleText setText: [dict objectForKey: @"title"]];
    [contentText setText: [dict objectForKey: @"content"]];
    
    [titleText setBackgroundColor: [UIColor clearColor]];
    [titleText setTextColor: [UIColor whiteColor]];
    [contentText setBackgroundColor: [UIColor clearColor]];
    [contentText setTextColor: [UIColor whiteColor]];
    [timeLabel setTextColor: [UIColor whiteColor]];
    
    if ([dict objectForKey: @"hour"] != [NSNull null])
    {
        NSLog(@"wut");
        NSInteger h = ((NSNumber*)[dict objectForKey: @"hour"]).intValue;
        NSInteger m = ((NSNumber*)[dict objectForKey: @"min"]).intValue;
        [timeLabel setText:[[NSString alloc] initWithFormat: @"Current notification time is %@%ld:%@%ld" , h < 10 ? @"0": @"",h,m < 10 ? @"0": @"",m]];
    }
    else {
        [timeLabel setText:@"Current notification time is --:--"];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(dismissKeyboard)];
    tap.cancelsTouchesInView = false;
    [self.view addGestureRecognizer: tap];
    
    
    UIColor *darkCyan = [UIColor colorWithRed: 0 green: 179/255.0 blue:134/255.0 alpha: 1];
    NSArray *bts = @[unsetButton, modifyButton, clearButton];
    for (UIButton* bt in bts) {
        [bt.layer setCornerRadius: 10.0f];
        [bt setBackgroundColor: darkCyan];
        [bt.layer setMasksToBounds: true];
        [bt setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [bt.titleLabel setFont: [UIFont fontWithName: @"AvenirNext-MediumItalic" size: 20]];
    }
    [self.view setBackgroundColor: [UIColor colorWithRed: 53/255.0 green:53/255.0 blue:53/255.0 alpha:1]];
    
    UIFont *tc = [UIFont fontWithName: @"Noteworthy" size: 20];
    [titleLabel setTextColor: [UIColor whiteColor]];
    [contentLabel setTextColor: [UIColor whiteColor]];
    [titleLabel setFont: tc];
    [contentLabel setFont: tc];

    [timeLabel setFont: tc];
    
    
    UIImage *eraserImg = [UIImage imageNamed: @"eraser.png"];
    eraserImg = [Utility changeSomeColorTransparent:eraserImg isWhite: false];
    eraserIcon.image = eraserImg;
    
    
    [lineIcon setBackgroundColor: [UIColor whiteColor]];
    
    UIImage *thoughts2 = [UIImage imageNamed: @"thoughts2.png"];
    thoughts2 = [Utility changeSomeColorTransparent:thoughts2 isWhite: false];
    thoughtsIcon.image = thoughts2;
    
    UIImage *hmmImg = [UIImage imageNamed: @"hmm.png"];
    hmmImg = [Utility changeSomeColorTransparent:hmmImg isWhite: true];
    hmmIcon.image = hmmImg;
}

- (IBAction)modify:(id)sender {
    UIAlertController* alert ;
    [self setTitleAndContent];
    
    NSString *title = [dict objectForKey: @"title"];
    NSString *content = [dict objectForKey: @"content"];
    
    bool isEmpty = [title isEqualToString: @""] || [content isEqualToString: @""];
    
    if (!isEmpty) {
        [parent update: @{@"dict":dict, @"pos": @(pos)}];

        NSString *condition =  [[NSString alloc] initWithFormat: @"pushid='%@'" , [dict objectForKey: @"pushid"]];
        [DBManager modify: REMINDERREC setValue: dict  where: condition];
        
        if ([dict objectForKey: @"hour"] != [NSNull null]) {
            NSString *uuid = [dict objectForKey: @"pushid"];
  
            NSInteger year = ((NSNumber*)[dict objectForKey: @"year"]).intValue;
            NSInteger month = ((NSNumber*)[dict objectForKey: @"month"]).intValue;
            NSInteger day = ((NSNumber*)[dict objectForKey: @"day"]).intValue;
            NSInteger hour = ((NSNumber*)[dict objectForKey: @"hour"]).intValue;
            NSInteger min = ((NSNumber*)[dict objectForKey: @"min"]).intValue;

            [NotificationManager pushNotification: uuid title: title content: content  year:year  month:month day:day hour:hour min: min];
        }
        else {
            [NotificationManager dismissNotification: [dict objectForKey: @"pushid"]];
        }
        alert = [UIAlertController alertControllerWithTitle:@"Modify info"
                                   message:@"Your message in the database has been modified!"
                                   preferredStyle:UIAlertControllerStyleAlert];
    }
    else {
        alert = [UIAlertController alertControllerWithTitle:@"Modify info"
                                   message:@"Either title or content cannot be empty!"
                                   preferredStyle:UIAlertControllerStyleAlert];
    }
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)unset:(id)sender {
    [self setDict: @{@"hour": [NSNull null], @"min" : [NSNull null]}];
    [timeLabel setText: @"Current notification time is --:--"];
}

- (IBAction)clear:(id)sender {
    titleText.text = contentText.text = @"";
}



- (void) dismissKeyboard {
    [self.view endEditing: true];
}

- (IBAction)timePicker:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    TimePicker *timePickerController = [sb instantiateViewControllerWithIdentifier: @"popOver"];
    timePickerController.modalPresentationStyle = UIModalPresentationPopover;
    timePickerController.preferredContentSize = CGSizeMake(240, 180);
    
    UIPopoverPresentationController *popover =  timePickerController.popoverPresentationController;
    popover.delegate = (id)timePickerController;
    popover.sourceView = self.view;
    popover.sourceRect = CGRectMake(390.0,50.0,0,5);
    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [timePickerController passingArg: @{@"parent":self}];
    [self presentViewController:timePickerController animated: YES completion: nil];
}

- (void) setTitleAndContent {
    [self setDict: @{@"title": titleText.text, @"content" : contentText.text}];
}

- (void) setDict:(NSDictionary *)newVals {
    NSMutableDictionary *mutableDict = [dict mutableCopy];
    
    for (NSString* key in newVals) {
        id val = [newVals objectForKey: key];
        [mutableDict setObject: val forKey: key];
    }

    dict = [mutableDict mutableCopy];
}

- (void) update:(nullable NSDictionary *)args {
    hour = ((NSNumber*)[args objectForKey: @"hour"]).intValue;
    min = ((NSNumber*)[args objectForKey: @"min"]).intValue;
    
    [timeLabel setText:[[NSString alloc] initWithFormat: @"Current notification time is %@%ld:%@%ld" , hour < 10 ? @"0": @"", hour, min < 10 ? @"0": @"", min]];

    [self setDict: @{@"hour": @(hour), @"min" : @(min)}];
}

- (void) passingArg:(NSDictionary *)args {
    parent = [args objectForKey: @"parent"];
    dict = [args objectForKey: @"dict"];
    pos = ((NSNumber*)[args objectForKey: @"pos"]).intValue;
}

@end
