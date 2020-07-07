//
//  AddNewItem.m
//  final_2
//
//  Created by eb211-22 on 2019/12/22.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import "AddNewItem.h"
#import "DBManager.h"
#import "Utility.h"
#import "TimePicker.h"
#import "NotificationManager.h"

@interface AddNewItem () {
    NSInteger hour, min;
    NSInteger year, month , day, weekday;
    id <PassingArgsAndUpdate> parent;
    BOOL infoBarState;
}
@end

@implementation AddNewItem

@synthesize titleText;
@synthesize contentText;

@synthesize submitButton;
@synthesize clearButton;
@synthesize unsetButton;

@synthesize timeLabel;
@synthesize titleLable;
@synthesize contentLabel;

@synthesize dialogIcon;
@synthesize pencilIcon;
@synthesize lineIcon;
@synthesize thinkingIcon;


@synthesize infoBox;


@synthesize my;
@synthesize date;

- (void)viewDidLoad {
    [super viewDidLoad];
    infoBarState = false;
    infoBox.frame =  CGRectMake(infoBox.frame.origin.x + 300,  infoBox.frame.origin.y, infoBox.frame.size.width - 300, infoBox.frame.size.height);
    [infoBox.layer setMasksToBounds: true];
    [infoBox.layer setCornerRadius: 10.0f];
    [infoBox setBackgroundColor:[UIColor colorWithRed: 64/255.0 green:64/255.0 blue:64/255.0 alpha:1]];
    
    hour = min = -1;
    NSArray *ms = @[@"", @"Jan.", @"Feb.", @"Mar.", @"Apr.", @"May", @"June", @"July", @"Aug.", @"Sep.", @"Oct.", @"Nov.", @"Dec."];
    NSArray *suffixes = @[@"", @"st", @"nd", @"rd"];
    NSString*suffix ;
    if (day <= 3) {
        suffix = [suffixes objectAtIndex: day];
    }
    else {
        suffix = @"th";
    }
    contentText.delegate = self;
    
    [my setText: [[NSString alloc] initWithFormat: @"\n\n%@ %ld\n\n\n", [ms objectAtIndex: month], year]];
    
    if (weekday == 0 || weekday == 6) {
        [my setBackgroundColor: [UIColor colorWithRed: 255/255.0 green:77/255.0 blue:77/255.0 alpha:1]];
    }
    else {
        [my setBackgroundColor: [UIColor colorWithRed: 64/255.0 green:64/255.0 blue:64/255.0 alpha:1]];
    }
    
    [my setTextColor: [UIColor whiteColor]];
    [my setFont: [UIFont fontWithName: @"Damascus" size: 20]];

    [date setText: [[NSString alloc] initWithFormat: @"%ld%@", day, suffix]];
    [date setTextColor: [UIColor whiteColor]];
    [date setFont: [UIFont fontWithName: @"Damascus" size: 40]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(dismissKeyboard)];
    tap.cancelsTouchesInView = false;
    [self.view addGestureRecognizer: tap];
    
    [self.view setBackgroundColor: [UIColor whiteColor]];
    
    UIImage *dialogImg = [UIImage imageNamed: @"thoughts.jpg"];
    dialogImg = [Utility changeSomeColorTransparent: dialogImg isWhite: true];
    dialogIcon.image = dialogImg;

    UIImage *pencilImg = [UIImage imageNamed: @"pencil.png"];
    pencilImg = [Utility changeSomeColorTransparent: pencilImg isWhite: true];
    pencilIcon.image = pencilImg;

    lineIcon.backgroundColor = [UIColor blackColor];
    
    UIImage *thinkingImg = [UIImage imageNamed: @"thinking.jpeg"];
    thinkingImg = [Utility changeSomeColorTransparent: thinkingImg isWhite: true];
    thinkingIcon.image = thinkingImg;

    
    [titleText setBackgroundColor: [UIColor clearColor]];
    [contentText setBackgroundColor: [UIColor clearColor]];

    [titleLable setFont: [UIFont fontWithName: @"Noteworthy" size: 20]];
    [contentLabel setFont: [UIFont fontWithName: @"Noteworthy" size: 20]];
    
    [timeLabel setFont: [UIFont fontWithName: @"Noteworthy" size: 20]];

    
    
    UIColor *darkCyan = [UIColor colorWithRed: 0 green: 179/255.0 blue:134/255.0 alpha: 1];
    [submitButton setBackgroundColor: darkCyan];

    [submitButton setTitleColor:  [UIColor whiteColor] forState: UIControlStateNormal];
    [submitButton.titleLabel setFont: [UIFont fontWithName: @"AvenirNext-MediumItalic" size: 15]];
    [submitButton.layer setCornerRadius: 10.0f];

    [clearButton setBackgroundColor: [UIColor whiteColor]];

    [clearButton setTitleColor:  darkCyan forState: UIControlStateNormal];
    [clearButton.titleLabel setFont: [UIFont fontWithName: @"AvenirNext-MediumItalic" size: 15]];
    [clearButton.layer setBorderWidth: 2.0f];
    [clearButton.layer setBorderColor: darkCyan.CGColor];
    [clearButton.layer setCornerRadius: 10.0f];
    [clearButton.layer setMasksToBounds : true];
    
    [unsetButton setTitleColor:  darkCyan forState: UIControlStateNormal];
    [unsetButton.titleLabel setFont: [UIFont fontWithName: @"AvenirNext-MediumItalic" size: 15]];
    [unsetButton.layer setBorderWidth: 2.0f];
    [unsetButton.layer setBorderColor: darkCyan.CGColor];
    [unsetButton.layer setCornerRadius: 10.0f];
    [unsetButton.layer setMasksToBounds : true];
}

- (IBAction)back:(id)sender {
    [parent update: nil];
    [self dismissViewControllerAnimated: true completion: nil];
}

- (IBAction)clear:(id)sender {
    titleText.text = @"";
    contentText.text = @"";
}

- (IBAction)submit:(id)sender {
    UIAlertController* alert ;
    BOOL isEmpty = [titleText.text length] == 0 ||  [contentText.text length] == 0 ;
    
    if (!isEmpty) {
        NSDictionary *payload ;
        NSString *uuid = [[NSUUID UUID] UUIDString];

        if (!infoBarState) {
            payload = [DBManager createDictForRemi: titleText.text content: contentText.text year: @(year) month: @(month) day: @(day) hour: nil min: nil pushid: uuid];
        }
        else {
            
            
            payload = [DBManager createDictForRemi: titleText.text content: contentText.text year: @(year) month: @(month) day: @(day) hour: @(hour) min: @(min) pushid: uuid];
            
            /*notification goes here!*/
            [NotificationManager pushNotification: uuid title: titleText.text content: contentText.text year: year month: month day: day hour: hour min: min];
            infoBarState = false;
            [self shrinkInfoBox];
        }
        
        [DBManager add: REMINDERREC payload: payload];
        [self clear: nil];
        
        alert = [UIAlertController alertControllerWithTitle:@"Submit info"
                                   message:@"Your message has been submitted to the database!"
                                   preferredStyle:UIAlertControllerStyleAlert];
    }
    else {
        alert = [UIAlertController alertControllerWithTitle:@"Submit info"
                                   message:@"Either title or note cannot be empty!"
                                   preferredStyle:UIAlertControllerStyleAlert];
    }
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void) animateTextView:(BOOL) up
{
    const int movementDistance = 50; // tweak as needed
    int movement= movement = (up ? -movementDistance : movementDistance);
            
    [UIView animateWithDuration: 0.5f animations:^{
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self animateTextView: YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self animateTextView: NO];
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
    
    [timePickerController passingArg: @{@"parent": self}];
    [self presentViewController:timePickerController animated: YES completion: nil];
}

- (IBAction)unsetTime:(id)sender {
    if (infoBarState) {
        [self shrinkInfoBox];
    }
}

- (void) shrinkInfoBox {
    infoBarState = false;
    [UIView animateWithDuration:0.3 animations:^{
        
        UIView *v = self->infoBox;
        int length = 300;
        [v setFrame:CGRectMake(v.frame.origin.x + length, v.frame.origin.y, v.frame.size.width - length, v.frame.size.height)];
    }];
}

- (void) expandInfoBox {
    infoBarState = true;
    NSString *pz = @"0";
    NSString *timeString = [[NSString alloc] initWithFormat: @"%@%ld:%@%ld", hour < 10 ? pz : @"", hour , min < 10 ? pz : @"", min];
    
    [timeLabel setText:[[NSString alloc] initWithFormat: @"The app will notify you at %@", timeString]];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        UIView *v = self->infoBox;
        int length = 300;
        [v setFrame:CGRectMake(v.frame.origin.x - length, v.frame.origin.y, v.frame.size.width + length, v.frame.size.height)];//here you can set your desired frame.
    }];
}

- (void) shrinkAndExpandInfoBox {
    [UIView animateWithDuration:0.3 animations:^{
        
        UIView *v = self->infoBox;
        int length = 300;
        [v setFrame:CGRectMake(v.frame.origin.x + length, v.frame.origin.y, v.frame.size.width - length, v.frame.size.height)];//here you can set your desired frame.
    } completion:  ^(BOOL finished){
        [self expandInfoBox];
    }];
}

- (void) update:(nullable NSDictionary *)args {
    hour = ((NSNumber*)[args objectForKey: @"hour"]).intValue;
    min = ((NSNumber*)[args objectForKey: @"min"]).intValue;
    
    if (infoBarState) {
        [self shrinkAndExpandInfoBox];
    }
    else {
        [self expandInfoBox];
    }
}

- (void)passingArg:(NSDictionary *)args {
    year = ((NSNumber*)[args objectForKey: @"year"]).intValue;
    month = ((NSNumber*)[args objectForKey: @"month"]).intValue;
    day = ((NSNumber*)[args objectForKey: @"day"]).intValue;
    weekday = ((NSNumber*)[args objectForKey: @"weekday"]).intValue;
    parent = [args objectForKey: @"parent"];
}

@end
