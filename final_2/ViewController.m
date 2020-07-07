//
//  ViewController.m
//  final
//
//  Created by mac15 on 2019/12/3.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"
#import "Utility.h"
#import "AddNewItem.h"
#import "ViewHistory.h"
#import "YearMonthPicker.h"

@interface ViewController ()
{
    NSMutableArray *days;
    NSInteger year, month, day, pd;
    NSArray *weekday;
    NSArray *months;
    UIColor *redOrange;
}
@end

@implementation ViewController

@synthesize myCollection;
@synthesize monthLabel;
@synthesize yearLabel;
@synthesize calendarView;

- (void)viewDidLayoutSubviews{
    [self loadLabelFormat];
    [self loadImageFormat];
    [self loadNavigationFormat];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view layoutIfNeeded];
    [DBManager initDBManager];
    
    
    [self.view setBackgroundColor:[UIColor colorWithRed:255/255.0 green:230/255.0 blue:180/255.0 alpha:0.9]];
    // Do any additional setup after loading the view.
    days = [[NSMutableArray alloc] init];
    self.myCollection.dataSource = self;
    self.myCollection.delegate = self;
 
    CGFloat margin = 8;
    
    UICollectionViewFlowLayout *cvf = [[UICollectionViewFlowLayout alloc] init];
    
    cvf.minimumLineSpacing = margin;
    cvf.minimumLineSpacing = margin;
    cvf.minimumInteritemSpacing = margin;
    cvf.itemSize = CGSizeMake(45, 35);
    
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents *currentdayComponents =
    [cal components:(NSCalendarUnitDay |
                     NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
    
    self.myCollection.collectionViewLayout = cvf;
    year = currentdayComponents.year;
    month = currentdayComponents.month;
    day = currentdayComponents.day;
    
    weekday= @[@"SUN", @"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT"];
    months = @[@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",
    @"September", @"October", @"November", @"December"];
    
    redOrange = [UIColor colorWithRed:1.0 green:51/255.0 blue:0 alpha:1];
    
    UISwipeGestureRecognizer * swipeDown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedown:)];
    swipeDown.direction=UISwipeGestureRecognizerDirectionDown;
    [calendarView addGestureRecognizer:swipeDown];

    UISwipeGestureRecognizer * swipeUp=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeup:)];
    swipeUp.direction=UISwipeGestureRecognizerDirectionUp;
    [calendarView addGestureRecognizer:swipeUp];

    [calendarView.layer setMasksToBounds: true ];
    [calendarView.layer setCornerRadius: 10.0f];
    
    [calendarView.layer setBorderWidth: 2.0f];
    [self recalculate: true];
}

-(NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return [days count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [myCollection dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
    
    UILabel *label = (UILabel*)[cell viewWithTag:100];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:200];
    imageView.image = nil;
    NSString *data = [days objectAtIndex:[indexPath row]];

    if (![data isEqualToString: @""]) {
        [label setText:[days objectAtIndex:[indexPath row]]];
        [label setFont: [UIFont fontWithName: @"copperplate" size: 18]];
        Boolean isWithinWeekday = false;
        for(int i = 0; i < 7; ++i) {
            if ([data isEqualToString: [weekday objectAtIndex:i]]) {
                isWithinWeekday = true;
                break;
            }
         }

        if (isWithinWeekday) {
            if (([data isEqualToString:@"SUN"] || [data isEqualToString:@"SAT"])) {
                label.textColor = redOrange;
            }
            else {
                label.textColor = [UIColor blackColor];
            }
        }
        else {
            NSInteger day = data.intValue-1;
            [label setFont: [UIFont fontWithName: @"Marker felt" size: 18]];
            NSInteger s = (pd + day) % 7;
            if ((s == 0 ||  s == 6)) {
                label.textColor = redOrange;
            }
            else {
                label.textColor = [UIColor blackColor];
            }
            
            NSString *formatted = [[NSString alloc] initWithFormat: @"year=%ld AND month=%ld AND day=%d", (long)year, (long)month , data.intValue];
            
            ResultType r = [DBManager  retrieve: REMINDERREC columns: nil  where: formatted];
            
            if (r != nil) {
                UIImageView *imageView = (UIImageView*)[cell viewWithTag:200];
                UIImage *img = [UIImage imageNamed: @"redmark.jpeg"];
                UIImage *newImage = [Utility changeSomeColorTransparent: img isWhite: true];
                newImage = [Utility imageWithImage:newImage scaledToSize: CGSizeMake(45, 35)];
        
                imageView.image = newImage;
            }
            else {
                imageView.image = nil;
            }
        }
    }
    else {
        [label setText:@""];
    }

    return cell;
}


-(void) recalculate:(bool) isUp {
    [monthLabel setText: [months objectAtIndex: month-1]];
    [monthLabel setFont: [UIFont fontWithName:@"Verdana-bold" size:40]];
    monthLabel.textColor = redOrange;
    
    [yearLabel setText: [[NSString alloc] initWithFormat:@"%ld", year] ];
    [yearLabel setFont: [UIFont fontWithName:@"Futura" size:30]];
    
    days = [[NSMutableArray alloc] init];
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents *current = [[NSDateComponents alloc] init];
    [current setYear: year];
    [current setMonth: month];
    [current setDay: 1];
    
    NSDate *date = [cal dateFromComponents:current];
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate: date];
    /*recalculate*/
    NSDateComponents* newOne = [cal components:NSCalendarUnitWeekday fromDate:date];
    NSInteger padding = [newOne weekday] - 1;
    pd = padding;
    NSInteger length = range.length;
    for(int i = 0; i < 7; ++i) {
        [days addObject: weekday[i]];
    }
    
    for(int i = 0; i < padding ; ++i) {
        [days addObject:@""];
    }
    
    for(NSInteger i = 1; i <= length ; ++i) {
        [days addObject: [[NSString alloc] initWithFormat: @"%ld", i]];
    }
    
    
    if (isUp) {
        [UIView transitionWithView: calendarView
                         duration: 0.35f
                          options: UIViewAnimationOptionTransitionCurlUp
                       animations: ^(void)
        {
             [self.myCollection reloadData];
            
        }
                       completion: nil];
    }
    else {
        [UIView transitionWithView: calendarView
                         duration: 0.35f
                          options: UIViewAnimationOptionTransitionCurlDown
                       animations: ^(void)
        {
             [self.myCollection reloadData];
        }
                       completion: nil];
    }
}

- (IBAction)decrease:(id)sender {
    if (month == 1) {
        month = 12;
        year -= 1;
    }
    else {
        month--;
    }
    [self recalculate: false ];
}
- (IBAction)increase:(id)sender {
    if (month == 12) {
        month = 1;
        year += 1;
    }
    else {
        month++;
    }
    [self recalculate: true];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.myCollection cellForItemAtIndexPath:indexPath];
    UILabel *label = (UILabel*)[cell viewWithTag:100];

    NSScanner *scanner = [NSScanner scannerWithString:label.text];
    BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
    
    if (isNumeric) {
        NSLog(@"Select Cell %@\n", label.text);
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tb = [sb instantiateViewControllerWithIdentifier: @"reminder"];
        
        UINavigationController * navi1 = [[tb viewControllers] objectAtIndex: 0];
        UINavigationController * navi2 = [[tb viewControllers] objectAtIndex: 1];
        
        AddNewItem *newItem =  (AddNewItem *)[navi1 topViewController];
        ViewHistory *hist = (ViewHistory*)[navi2 topViewController];
        NSCalendar* cal = [NSCalendar currentCalendar];
        NSDateComponents *current = [[NSDateComponents alloc] init];
        [current setYear: year];
        [current setMonth: month];
        [current setDay: label.text.intValue];
        
        NSDate *date = [cal dateFromComponents:current];
        NSDateComponents* newOne = [cal components:NSCalendarUnitWeekday fromDate:date];
        NSInteger padding = [newOne weekday] - 1;
        
        
        NSInteger thisDay = label.text.intValue;
        NSArray *keys = @[@"tabbar", @"parent", @"year", @"month", @"day", @"weekday"];
        NSArray *vals = @[tb, self, @(year), @(month), @(thisDay) , @(padding)];
        NSDictionary *dict = [Utility createDictWithKeysAndValues: keys vals: vals];
        [newItem passingArg: dict];
        [hist passingArg: dict];
        
        tb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        tb.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController: tb animated: true completion: nil];
    }
}





//layout set
- (void) loadNavigationFormat{
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:250/255.0 green:180/255.0 blue:120/255.0 alpha:1.0]];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void) loadLabelFormat{
    CGRect windowRect = [[UIScreen mainScreen] bounds];
    float w = windowRect.size.width;float h = windowRect.size.height;
    [_button_commodityInput setFrame:CGRectMake(0, h/20, w/3, h/10)];
    _button_commodityInput.backgroundColor = [UIColor colorWithRed:250/255.0f green:180/255.0 blue:120/255.0f alpha:1.0];
    [_button_commodityInput setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button_commodityInput.layer setBorderColor:[UIColor colorWithRed:200/255.0f green:144/255.0 blue:96/255.0f alpha:1.0].CGColor];
    [_button_commodityInput.layer setBorderWidth:1.5];
    
    [_button_purchaseRecord setFrame:CGRectMake(w/3, h/20, w/3, h/10)];
    _button_purchaseRecord.backgroundColor = [UIColor colorWithRed:250/255.0 green:180/255.0 blue:120/255.0 alpha:1.0];
    [_button_purchaseRecord setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button_purchaseRecord.layer setBorderColor:[UIColor colorWithRed:200/255.0f green:144/255.0 blue:96/255.0f alpha:1.0].CGColor];
    [_button_purchaseRecord.layer setBorderWidth:1.5];
    
    [_button_commodityInfo setFrame:CGRectMake(w*2/3, h/20, w/3, h/10)];
    _button_commodityInfo.backgroundColor = [UIColor colorWithRed:250/255.0 green:180/255.0 blue:120/255.0 alpha:1.0];
    [_button_commodityInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button_commodityInfo.layer setBorderColor:[UIColor colorWithRed:200/255.0f green:144/255.0 blue:96/255.0f alpha:1.0].CGColor];
    [_button_commodityInfo.layer setBorderWidth:1.5];
    //[_button_input.layer setCornerRadius:20.0f];
}

-(void)loadImageFormat{
    NSLog(@"test");
    CGRect windowRect = [[UIScreen mainScreen] bounds];
    float w = windowRect.size.width;float h = windowRect.size.height;
    [_main_image setFrame:CGRectMake(w*1/5, h*1.5/10, w*3/5, w*2.5/5)];
    _main_imagename = @"draw2";
    UIImage *imagefile = [UIImage imageNamed:_main_imagename];
    [_main_image setImage:imagefile];
    
    //
    
    
    
    
    
    //gesture recongnizer
    [_main_image setUserInteractionEnabled:YES];
    //tap
    /*
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImage)];
    [tap setNumberOfTapsRequired:1];
    [_main_image addGestureRecognizer:tap];
    */
    
    //press
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    [press setMinimumPressDuration:1];
    [press setNumberOfTapsRequired:1];
    [press setNumberOfTouchesRequired:1];
    [_main_image addGestureRecognizer:press];
    
    [self.view addSubview:_main_image];
}
-(void)handleLongPress:(UILongPressGestureRecognizer*)sender{
    if(sender.state == UIGestureRecognizerStateBegan){
        _main_imagename = @"draw3";
        UIImage *imagefile = [UIImage imageNamed:_main_imagename];
        [_main_image setImage:imagefile];
        NSLog(@"tap");
    }
    else if(sender.state == UIGestureRecognizerStateEnded){
        _main_imagename = @"draw2";
        UIImage *imagefile = [UIImage imageNamed:_main_imagename];
        [_main_image setImage:imagefile];
        NSLog(@"tap");
    }
    
}

- (void) update:(nullable NSDictionary *)args{
    
    if (args == nil) {
        [myCollection reloadData];
    }
    else {
        NSInteger oY = year;
        NSInteger oM = month;

        
        year = ((NSNumber*)[args objectForKey: @"year"]).intValue;
        month = ((NSNumber*)[args objectForKey: @"month"]).intValue + 1;
        
        
        if (year != oY || month != oM) {
            if (year > oY || (year == oY && month > oM)) {
                [self recalculate: true];
            }
            else {
                [self recalculate: false];
            }
        }
    }
}

- (void) passingArg:(NSDictionary *)args {}


-(void)swipedown:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self decrease: nil];
}

-(void)swipeup:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self increase: nil];
}

- (IBAction)yearMonthPicker:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    YearMonthPicker *yearMonthController = [sb instantiateViewControllerWithIdentifier: @"yearMonthPicker"];
    yearMonthController.modalPresentationStyle = UIModalPresentationPopover;
    yearMonthController.preferredContentSize = CGSizeMake(240, 180);
    
    UIPopoverPresentationController *popover =  yearMonthController.popoverPresentationController;
    popover.delegate = (id)yearMonthController;
    popover.sourceView = calendarView;
    
    UIButton *bt = sender;
    
    popover.sourceRect = CGRectMake(bt.frame.origin.x, bt.frame.origin.y,10,20);
    popover.permittedArrowDirections = UIPopoverArrowDirectionDown;
    
    [yearMonthController passingArg: @{@"parent": self}];
    [self presentViewController:yearMonthController animated: YES completion: nil];
}



@end
