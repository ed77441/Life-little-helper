//
//  PurchaseRecord.m
//  final_2
//
//  Created by eb211-22 on 2019/12/29.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import "PurchaseRecord.h"
#import "DBManager.h"
@interface PurchaseRecord ()
{
    float size_w;
    float size_h;
    float tableSize_w;
    float tableSize_h;
    NSArray *shoppingRecord;
    NSArray *recordType;
    NSMutableArray *toggle;
    NSMutableArray *recordBatch;
    NSMutableArray *shoppingRecord_batch;
}
@end

@implementation PurchaseRecord
-(void)viewDidLayoutSubviews{
    [self loadNavigationFormat];
    
    CGRect windowRect = [[UIScreen mainScreen] bounds];
    float w = windowRect.size.width;float h = windowRect.size.height;
    float nh = self.navigationController.navigationBar.frame.size.height;
    float ny = self.navigationController.navigationBar.frame.origin.y;
    size_w = w;
    size_h = h;
    
    //tableSize_h = [shoppingRecord count]*50.0f + [recordBatch count]*60.0f;
    //if (tableSize_h > size_h - nh - ny)
        tableSize_h = size_h - nh - ny;
    tableSize_w = size_w - 20.0f;
    
    [self.shoppingRecTable setFrame:CGRectMake(10.0f, nh + ny + 10.0f, tableSize_w, tableSize_h)];
    
    self.shoppingRecTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}
    
- (void)viewDidLoad {
    [super viewDidLoad];

   // self.shoppingRecTable.allowsSelection = NO;
    self.shoppingRecTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.shoppingRecTable.delegate = self;
    self.shoppingRecTable.dataSource = self;
    
    shoppingRecord = [[NSArray alloc]initWithArray:[DBManager retrieve:SHOPPINGREC columns:nil where:nil]];
    recordType = [[NSArray alloc]initWithObjects:@"name", @"price", @"num" , @"batch", @"date" , @"location", nil];
    toggle = [[NSMutableArray alloc] init];

 
    NSMutableSet *batchSet = [[NSMutableSet alloc] init];
    for (int i = 0; i < [shoppingRecord count]; ++i){
        [batchSet addObject: shoppingRecord[i][@"batch"]];
    }
    
    
    for (int i = 0 ; i < [batchSet count]; ++i) {
        [toggle addObject: @NO];
    }
   [self.shoppingRecTable setBackgroundColor:[UIColor clearColor]];
 [self.view setBackgroundColor: [UIColor colorWithRed: 102/255.0 green: 0 blue: 0/255.0 alpha:1]];

NSLog(@"set: %@",batchSet);
    recordBatch = [[NSMutableArray alloc] init];
    recordBatch = [[batchSet allObjects] mutableCopy];
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
//    [recordBatch sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
    shoppingRecord_batch = [[NSMutableArray alloc] init];
    for (int i = 0; i < [recordBatch count]; ++i){
        [shoppingRecord_batch addObject: [[NSMutableArray alloc] init] ];
    }
NSLog(@"batch: %@",recordBatch);
    for(int i = 0; i < [shoppingRecord count]; ++i){
        for(int j = 0; j < [recordBatch count]; ++j){
            NSString *batchID = [[NSString alloc]initWithString:shoppingRecord[i][@"batch"]];
            if([batchID isEqualToString:recordBatch[j]]){
                [shoppingRecord_batch[j] addObject:shoppingRecord[i]];
            }
        }
    }

NSLog(@"shRB: %@", shoppingRecord_batch);
    
    NSLog(@"shp= %@", shoppingRecord_batch);
    [self viewDidLayoutSubviews];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
NSLog(@"batch count%ld",[recordBatch count]);
    return [recordBatch count];
}

//section header and footer
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 88.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableSize_w, 88.0f)];
 //   [sectionView setBackgroundColor:[UIColor colorWithRed:250/255.0f green:230/255.0f blue:180/255.0f alpha:1.0f]];
    [sectionView setBackgroundColor:[UIColor colorWithRed:255/255.0f green:209/255.0f blue:179/255.0f alpha:1.0f]];
    UILabel *label_date = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 1.0f, tableSize_w, 40.0f)];
    label_date.text = shoppingRecord_batch[section][0][@"date"];
    [label_date setFont: [UIFont systemFontOfSize:20]];
    [sectionView addSubview: label_date];

    UILabel *label_location = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 45.0f, tableSize_w - 10.0f, 40.0f)];
    label_location.text = shoppingRecord_batch[section][0][@"location"];
    [label_location setTextColor: [UIColor purpleColor]];
    [label_location setTextAlignment:NSTextAlignmentRight];
    [sectionView addSubview: label_location];

    UIFont *f = [UIFont fontWithName: @"Avenir-Heavy" size: 25];
    
    [label_date setFont: f];
    [label_location setFont: f];
    
    return sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}
- (UIView*)tableView:(UITableView*)tableView
           viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 40.0f;
    
    NSInteger sec = indexPath.section;
    NSNumber *isfolded = toggle[sec];

    if (indexPath.row != [shoppingRecord_batch[sec] count] && isfolded.intValue == @NO.intValue) {
        height = 0.0f;
    }

    if (indexPath.row == [shoppingRecord_batch[sec] count]) {
        height = 50.0f;
    }
    
    
    return height;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
NSLog(@"cell count %ld",[shoppingRecord_batch[section] count]);
    return ([shoppingRecord_batch[section] count] + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
NSLog(@"index count %ld",indexPath.row);
    UITableViewCell *cell = [[UITableViewCell alloc]init];
 //   [cell setBackgroundColor:[UIColor colorWithRed:250/255.0f green:230/255.0f blue:180/255.0f alpha:1.0f]];
    [cell setClipsToBounds: true] ;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    NSInteger sum = 0;
    if (indexPath.row >= [shoppingRecord_batch[indexPath.section] count]){
        [cell setBackgroundColor:[UIColor colorWithRed:255/255.0f green:209/255.0f blue:179/255.0f alpha:1.0f]];
        for(int i = 0; i < [shoppingRecord_batch[indexPath.section] count]; ++i){
            NSNumber *cost = shoppingRecord_batch[indexPath.section][i][@"price"];
            NSNumber *num = shoppingRecord_batch[indexPath.section][i][@"num"];
            sum += cost.intValue * num.intValue;
            NSLog(@"%d", cost.intValue);
        }
        NSString *sum_string = [[NSString alloc]initWithFormat:@"total: %ld$", sum];
        
        UILabel *label_sum = [[UILabel alloc]initWithFrame:CGRectMake(tableSize_w - 200.0f, 5.0f, 190.0f, 40.0f)];
        label_sum.text = sum_string;
        [label_sum setTextAlignment:NSTextAlignmentRight];
        //[cell.layer setBorderWidth : 5.0f];
        [cell addSubview: label_sum];
        
        
        UIFont *f = [UIFont fontWithName: @"Avenir-HeavyOblique" size: 25];
        [label_sum  setFont:f];
        [label_sum setTextColor: [UIColor colorWithRed: 1 green:102/255.0 blue:0 alpha:1]];
        
        
    }
    
    else{
        [cell setBackgroundColor:[UIColor whiteColor]];

        UILabel *label_name = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 1.0f, tableSize_w - 150.0f, 40.0f)];
        NSString *name = shoppingRecord_batch[indexPath.section][indexPath.row][@"name"];
        NSNumber *num = shoppingRecord_batch[indexPath.section][indexPath.row][@"num"];
        NSString *name_string = [[NSString alloc]initWithFormat:@"%@", name];
        label_name.text = name_string;
        [cell addSubview: label_name];
        
        UILabel *label_price = [[UILabel alloc]initWithFrame:CGRectMake(tableSize_w - 150.0f, 3.0f, 140.0f, 40.0f)];
        NSNumber *price = shoppingRecord_batch[indexPath.section][indexPath.row][@"price"];
        NSString *price_string = [[NSString alloc] initWithFormat:@"%d$ * %d", price.intValue, num.intValue];
        label_price.text = price_string;
        [label_price setTextAlignment:NSTextAlignmentRight];
        [label_price setFont:[UIFont systemFontOfSize:12]];
        [cell addSubview: label_price];
        //[label_name setTextColor: [UIColor whiteColor]];
        //[label_price setTextColor: [UIColor whiteColor]];

    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger sec = indexPath.section;
    NSNumber *isfolded = toggle[sec];
    
    if (indexPath.row == [shoppingRecord_batch[sec] count]) {
        
        toggle[sec] = isfolded.intValue == @NO.intValue ? @YES : @NO;
        [tableView beginUpdates];
        [tableView endUpdates];
    }
}


- (void) loadNavigationFormat{
    //CGRect windowRect = [[UIScreen mainScreen] bounds];
    //float w = windowRect.size.width;float h = windowRect.size.height;
    self.navigationItem.title = @"購物紀錄";
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:250/255.0 green:180/255.0 blue:120/255.0 alpha:1.0]];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}




@end
