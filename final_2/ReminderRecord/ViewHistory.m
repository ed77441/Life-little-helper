//
//  ViewHistory.m
//  final_2
//
//  Created by mac15 on 2019/12/25.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import "ViewHistory.h"
#import "DBManager.h"
#import "ModifyContent.h"
#import "NotificationManager.h"

@interface ViewHistory () {
    NSMutableArray<NSDictionary*> *data;
    NSMutableArray *toggle;
    NSInteger year, month, day;
    UITabBarController *tabbar;
    UIColor *darkCyan;
    id <PassingArgsAndUpdate> parent;
    bool allowSelect;
}
@end

@implementation ViewHistory
@synthesize history;
@synthesize dateLabel;
@synthesize itemNumberLabel;
@synthesize headerView;
@synthesize deleteButton;
@synthesize cancelButton;


- (void)viewDidLoad {
    [super viewDidLoad];    
    allowSelect = false;
    history.delegate = self;
    history.dataSource = self;

    history.allowsMultipleSelection = true;
    
    [self.view setBackgroundColor: [UIColor colorWithRed: 53/255.0 green:53/255.0 blue:53/255.0 alpha:1]];
    [history setBackgroundColor: [UIColor clearColor]];
    
    [dateLabel setText: [[NSString alloc] initWithFormat: @"%ld/%@%ld/%@%ld", year, month < 10 ? @"0": @"" ,month, day < 10 ? @"0" : @"", day ]];
    [itemNumberLabel setText: [[NSString alloc] initWithFormat: @"%ld item%@ found", [data count], [data count] == 1 ? @"" : @"s"]];
    darkCyan = [UIColor colorWithRed: 0 green: 179/255.0 blue:134/255.0 alpha: 1];
    [headerView setBackgroundColor: darkCyan];
    [dateLabel setTextColor: [UIColor whiteColor]];
    [dateLabel setFont: [UIFont fontWithName: @"GillSans-SemiBoldItalic" size: 25]];
    
    [itemNumberLabel setTextColor: [UIColor whiteColor]];
    [itemNumberLabel setFont: [UIFont fontWithName: @"GillSans-SemiBoldItalic" size: 25]];
}

- (void) reloadTable {
    data = [[NSMutableArray alloc] init];
    toggle = [[NSMutableArray alloc] init];
    [self getDataFromDataBase];

    [itemNumberLabel setText: [[NSString alloc] initWithFormat: @"%ld item%@ found",[data count], [data count] == 1 ? @"" : @"s"]];
    [history reloadData];
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}



- (IBAction)edit:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ModifyContent *modifyPage = [sb instantiateViewControllerWithIdentifier: @"modifyPage"];
    
    modifyPage.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    modifyPage.modalPresentationStyle = UIModalPresentationFullScreen;
    
    //[tabbar presentViewController: modifyPage animated: true completion: nil];
    modifyPage.hidesBottomBarWhenPushed = true;
    UINavigationController * navi2 = [[tabbar viewControllers] objectAtIndex: 1];
    [navi2 pushViewController: modifyPage animated: true];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cellforhist"];
    
    NSUInteger sectionIdx = indexPath.section;
    NSDictionary *dict = [data objectAtIndex: sectionIdx];
    
    UILabel *title = (UILabel*)[cell viewWithTag: 100];
    
    [title setFont: [UIFont fontWithName: @"HelveticaNeue-CondensedBold" size: 30] ];
    [title setText: [dict objectForKey: @"title"] ];

    
    UILabel *subTitle = (UILabel*)[cell viewWithTag: 300];
    
    [subTitle setFont: [UIFont fontWithName: @"DIN Condensed" size: 18] ];
    [subTitle setTextColor: [UIColor darkGrayColor]];
    id h = [dict objectForKey: @"hour"];
    
    if (h == nil || h == [NSNull null]) {
        [subTitle setText: @"No specified notification time"];
    }
    else {
        NSNumber *m = [dict objectForKey: @"min"];
        NSInteger hour = ((NSNumber*)h).intValue;
        NSInteger min = m.intValue;
        
        NSString *timeStr = [[NSString alloc] initWithFormat: @"The app will notify you at %@%ld:%@%ld",hour < 10 ? @"0" : @"", hour, min < 10 ? @"0" : @"" , min];
        [subTitle setText: timeStr];
    }

    
    UITextView *content = (UITextView*)[cell viewWithTag: 200];

    [content setText: [dict objectForKey: @"content"] ];
    [content setBackgroundColor:[UIColor colorWithRed: 240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [content.layer setCornerRadius: 5.0f];
    [content.layer setMasksToBounds: true];
    [content setFont: [UIFont fontWithName: @"HelveticaNeue-Light" size: 18]];

    UIButton *toggleButton = (UIButton*)[cell viewWithTag: 400];
    [toggleButton.layer setMasksToBounds: true];
    [toggleButton.layer setCornerRadius: 5.0f];
    [toggleButton.layer setBackgroundColor: darkCyan.CGColor];
    [toggleButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [toggleButton.titleLabel setFont: [UIFont fontWithName: @"Copperplate" size: 15]];
    
    UIButton *editButton = (UIButton*)[cell viewWithTag: 500];
    [editButton setTitleColor: darkCyan forState:UIControlStateNormal];
    [editButton.titleLabel setFont: [UIFont fontWithName: @"Copperplate" size: 15]];
    
    [cell.layer setMasksToBounds: true];
    [cell.layer setCornerRadius: 5.0f];

    NSLog(@"sec = %ld", indexPath.section);
    return cell;
}

- (void) getDataFromDataBase {
    
    ResultType result = [DBManager retrieve: REMINDERREC columns: nil where: [[NSString alloc] initWithFormat: @"year=%ld AND month=%ld AND day=%ld", year, month, day]];

    for (NSDictionary *dict in result) {
        [data addObject: dict];
        [toggle addObject: @NO];
        
        NSLog(@"%@", dict);
    }
    NSLog(@"num = %ld", [data count]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height;
    NSNumber *val = [toggle objectAtIndex: indexPath.section];
    if (val.intValue == @NO.intValue) {
        height = 100.0f;
    }
    else {
        height = 280.0f;
    }
    return height;
}
- (IBAction)back:(id)sender {
    [parent update: nil];
    [self dismissViewControllerAnimated: true completion: nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    [v setBackgroundColor: [UIColor clearColor]];
    return v;
}

- (IBAction)toggleHeight:(id)sender {
    UIButton *bt = (UIButton*) sender;
    UIView *superview = bt.superview;

    while(![superview isKindOfClass:[UITableViewCell class]]){
        superview = superview.superview;
    }
    
    NSIndexPath *indexPath = [history indexPathForCell: (UITableViewCell*)superview];
    
    NSNumber *oldVal =  [toggle objectAtIndex: indexPath.section];
    bool isNotToggled =  oldVal.intValue == @NO.intValue;

    NSNumber *newVal = isNotToggled ? @YES : @NO;
    [bt setTitle: isNotToggled ? @"Show less" : @"Read more" forState: UIControlStateNormal];
    
    
    [toggle replaceObjectAtIndex: indexPath.section withObject: newVal];
    
    [history beginUpdates];
    [history endUpdates];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString: @"toModifyPage"]) {
        
        UIButton *bt = sender;
        UIView *superview = bt.superview;

        while(![superview isKindOfClass:[UITableViewCell class]]){
            superview = superview.superview;
        }
        
        
        ModifyContent *controller = segue.destinationViewController;
        NSIndexPath *indexPath = [history indexPathForCell: (UITableViewCell*)superview];
        NSDictionary *dict = [data objectAtIndex: indexPath.section] ;
        
        [controller passingArg: @{@"parent" : self,@"dict": dict, @"pos": @(indexPath.section)}];
    }
}

- (void)deleteSelected {
    NSMutableArray *newArrayD = [[NSMutableArray alloc] init];
    NSMutableArray *newArrayT = [[NSMutableArray alloc] init];

    
    
    for (int i = 0; i < [data count]; ++i) {
        bool isSelected = false;
        for (NSIndexPath *indexPath in self.history.indexPathsForSelectedRows) {
            if (i == indexPath.section) {
                isSelected = true;
                break;
            }
        }
        
        if (!isSelected) {
            [newArrayD addObject: [data objectAtIndex: i]];
            [newArrayT addObject: [toggle objectAtIndex: i]];
        }
    }
    
    data = newArrayD;
    toggle = newArrayT;
    [UIView transitionWithView: self.history
                     duration: 0.35f
                      options: UIViewAnimationOptionTransitionCrossDissolve
                   animations: ^(void)
    {
         [self.history reloadData];
    }
                   completion: nil];
}

- (void) setEntry: (NSDictionary*) dict pos: (NSInteger) pos{
    NSMutableArray *newArrayD = [[NSMutableArray alloc] init];
    for (int i = 0; i < [data count]; ++i) {
        if (i != pos) {
            [newArrayD addObject: [data objectAtIndex: i]];
        }
        else {
            [newArrayD addObject: dict];
        }
    }
    data = newArrayD;
    [history reloadData];
    NSLog(@"eeee = %@", data);
}

- (IBAction)delete:(id)sender {
    if (!allowSelect) {
        deleteButton.image = [UIImage systemImageNamed:@"checkmark"];
        cancelButton.enabled = true;
        cancelButton.image = [UIImage systemImageNamed:@"xmark"];
        allowSelect = !allowSelect;
    }
    else {
        NSInteger itemNum = [history.indexPathsForSelectedRows count];
        
        if (itemNum > 0) {
            NSString *formatted = [[NSString alloc] initWithFormat: @"%ld items is about to be deleted!", itemNum];

            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete info"
                                              message: formatted
                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {
                
                for (NSIndexPath *indexPath in self.history.indexPathsForSelectedRows) {
                    NSInteger sec = indexPath.section;
                    NSDictionary *row = [self->data objectAtIndex: sec];
                    NSString *uuid = [row objectForKey: @"pushid"];
                    NSString *condition = [[NSString alloc] initWithFormat: @"pushid='%@'", uuid];
                    [DBManager remove: REMINDERREC where: condition];
                    [NotificationManager dismissNotification: uuid];
                }
                
                [self deleteSelected];

                [self.itemNumberLabel setText: [[NSString alloc] initWithFormat: @"%ld item%@ found",[self->data count], [self->data count] == 1 ? @"" : @"s"]];
                [self resetImage];
                self->allowSelect = !self->allowSelect;
            }];
            
             UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction * action) {}];
            
            [alert addAction:okAction];
            [alert addAction:cancelAction];

            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            [self resetImage];
            allowSelect = !allowSelect;
        }
    }
}

- (void) resetImage {
    deleteButton.image = [UIImage systemImageNamed: @"trash"];
    cancelButton.enabled = false;
    cancelButton.image = nil;
}

- (IBAction)cancel:(id)sender {
    for (NSIndexPath *indexPath in history.indexPathsForSelectedRows) {
        [history deselectRowAtIndexPath:indexPath animated:NO];
    }
    allowSelect = false;
    [self resetImage];
}

- (void) update:(nullable NSDictionary *)args {
    NSInteger pos = ((NSNumber*)[args objectForKey: @"pos"]).intValue;
    NSDictionary *d = [args objectForKey: @"dict"];

    [self setEntry:d pos: pos];
}

- (void) passingArg:(NSDictionary *)args {
    year = ((NSNumber*)[args objectForKey: @"year"]).intValue;
    month = ((NSNumber*)[args objectForKey: @"month"]).intValue;
    day = ((NSNumber*)[args objectForKey: @"day"]).intValue;
    parent = [args objectForKey: @"parent"];
    tabbar = [args objectForKey: @"tabbar"];
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( !allowSelect ) {
        return nil;
    }
    return indexPath;
}

@end
