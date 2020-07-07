//
//  CommodityInformation.m
//  final_2
//
//  Created by eb211-22 on 2019/12/29.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import "CommodityInformation.h"
#import "Commodityinfo_Cell.h"
@interface CommodityInformation ()
{
    float size_w;
    float size_h;
    NSMutableArray *commodity_data;
    NSMutableArray<NSString*> *commodity_section;
    NSMutableArray *commodity_sectionData;
    
    NSArray *filter_types;
    NSString *filter_typeNow;

    NSMutableArray *cellCollection;
    NSMutableArray *cellCollection_section;
    
    NSIndexPath *lastPath;
}
@end

@implementation CommodityInformation

- (void)viewDidLayoutSubviews{
    [self loadNavigationFormat];
    
    CGRect windowRect = [[UIScreen mainScreen] bounds];
    float w = windowRect.size.width;float h = windowRect.size.height;
    float nh = self.navigationController.navigationBar.frame.size.height;
    float ny = self.navigationController.navigationBar.frame.origin.y;
    size_w = w;
    size_h = h;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:200/255.0f green:230/255.0f blue:255/255.0f alpha:1]];
    
    [_label_filter setFrame:CGRectMake(10, nh+ny+18, 70, 30)];
    [_label_filter setText:@"Sort:"];
    [_label_filter setTextColor:[UIColor blackColor]];
    _label_filter.font = [UIFont fontWithName:@"PingFangHK-Semibold" size:17];

    [_button_sectionDate setFrame:CGRectMake(90, nh+ny+20, 90, 28)];
    [_button_sectionDate setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
    [_button_sectionDate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_button_sectionLocation setFrame:CGRectMake(190, nh+ny+20, 90, 28)];
    [_button_sectionLocation setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
    [_button_sectionLocation setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [_button_sectionDate setEnabled:YES];
    [_button_sectionLocation setEnabled:NO];
    [_button_sectionDate setBackgroundColor: [UIColor colorWithRed:160/255.0f green:160/255.0f blue:230/255.0f alpha:0.8]];
    [_button_sectionLocation setBackgroundColor: [UIColor colorWithRed:160/255.0f green:160/255.0f blue:230/255.0f alpha:1]];
    _button_sectionDate.titleLabel.font = [UIFont fontWithName:@"PingFangHK-Semibold" size:16];
    _button_sectionLocation.titleLabel.font = [UIFont fontWithName:@"PingFangHK-Semibold" size:16];
    
    [self.commodity_table setFrame:CGRectMake(0.0f, nh+ny+60, size_w, h-nh-ny-60)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewDidLayoutSubviews];
    //[self.label_test add];
    
    
    commodity_data = [[NSMutableArray alloc]initWithArray:[DBManager retrieve:COMMIDITINFO columns:nil where:nil]];
    
    filter_types = [[NSArray alloc]initWithObjects:@"name",@"price",@"location",@"date", nil];
    filter_typeNow = filter_types[2];
    
    _commodity_table.delegate = self;
    _commodity_table.dataSource = self;
        
    //cell create
    cellCollection = [[NSMutableArray alloc]init];
    for(int i=0; i<[commodity_data count]; ++i){
        Commodityinfo_Cell *cell = [self.commodity_table dequeueReusableCellWithIdentifier:@"commodityinfo_tablecell"];
        if (!cell){
            [self.commodity_table registerNib:[UINib nibWithNibName:@"Commodityinfo_Cell" bundle:nil] forCellReuseIdentifier:@"commodityinfo_tablecell"];
            cell = [self.commodity_table dequeueReusableCellWithIdentifier:@"commodityinfo_tablecell"];
        }
        [cell changeSize:size_w height:44.0f];
        cell.commodity_data = commodity_data[i];
        cell.value_name.text = commodity_data[i][@"name"];
        cell.value_name.font = [UIFont fontWithName:@"PingFangHK-Semibold" size:16];
        [cell setBackgroundColor:[UIColor colorWithRed:255/255.0f green:230/255.0f blue:200/255.0f alpha:1]];
        UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
        myBackView.backgroundColor = [UIColor colorWithRed:255/255.0f green:230/255.0f blue:200/255.0f alpha:1];
        cell.selectedBackgroundView = myBackView;
        [cell cellInfoLoad];
        [cellCollection addObject:cell];
    }
    
    [self sortWithFilter:filter_typeNow];
}

//sort with filter
- (void)sortWithFilter:(NSString*)filterType{
    commodity_section = [[NSMutableArray alloc] init];
    
    NSMutableSet *section_set = [[NSMutableSet alloc]init];
    for(int i=0; i<[commodity_data count]; ++i){
        [section_set addObject:commodity_data[i][filterType]];
    }
    commodity_section = [[section_set allObjects]mutableCopy];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    [commodity_section sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
    commodity_sectionData = [[NSMutableArray alloc]init];
    cellCollection_section = [[NSMutableArray alloc]init];
    
    for(int i=0; i<[commodity_section count]; ++i){
        [commodity_sectionData addObject: [[NSMutableArray alloc]init]];
        [cellCollection_section addObject:[[NSMutableArray alloc]init]];
    }

    for(int i=0; i<[commodity_data count]; ++i){
        for(int j=0; j<[commodity_section count]; ++j){
            if([commodity_section[j] isEqualToString: commodity_data[i][filterType]]){
                [commodity_sectionData[j] addObject: commodity_data[i]];
                Commodityinfo_Cell* cell = cellCollection[i];
                cell.value_filter.text = commodity_data[i][filter_typeNow];
                [cellCollection_section[j] addObject: cell];
                break;
            }
        }
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [commodity_section count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return commodity_section[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sec = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, size_w, 44.0f)];
    [sec setBackgroundColor:[UIColor colorWithRed:255/255.0f green:160/255.0f blue:80/255.0f alpha:1]];
    sec.layer.borderColor = [UIColor colorWithRed:180/255.0f green:80/255.0f blue:30/255.0f alpha:1].CGColor;
    sec.layer.borderWidth = 1.0f;
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 0.0f, size_w, 44.0f)];
    title.text = commodity_section[section];
    title.font = [UIFont fontWithName:@"PingFangHK-Semibold" size:18];
    title.textColor = [UIColor colorWithRed:130/255.0f green:20/255.0f blue:20/255.0f alpha:1];
    [sec addSubview:title];
    return sec;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return 44.0f;
    return [cellCollection_section[indexPath.section][indexPath.row] getSize_h];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [cellCollection_section[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellCollection_section[indexPath.section][indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //only one open
//    if (!lastPath){
//        lastPath = indexPath;
//    }
//    Commodityinfo_Cell *cell = cellCollection_section[lastPath.section][lastPath.row];
//    [cell changeSize:size_w height:44.0f];
//    [cell.value_filter setHidden:NO];
//
//    cell = cellCollection_section[indexPath.section][indexPath.row];
//    [cell changeSize:size_w height:132.0f];
//    [cell.value_filter setHidden:YES];
    
    //many open
    Commodityinfo_Cell *cell = cellCollection_section[indexPath.section][indexPath.row];
    if([cell getSize_h]>50.0f){
        [cell changeSize:size_w height:44.0f];
        [cell.value_filter setHidden:NO];
        [cell setBackgroundColor:[UIColor colorWithRed:255/255.0f green:230/255.0f blue:200/255.0f alpha:1]];
        UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
        myBackView.backgroundColor = [UIColor colorWithRed:255/255.0f green:230/255.0f blue:200/255.0f alpha:1];
        cell.selectedBackgroundView = myBackView;
    }
    else{
        [cell changeSize:size_w height:132.0f];
        [cell.value_filter setHidden:YES];
        [cell setBackgroundColor:[UIColor colorWithRed:250/255.0f green:220/255.0f blue:200/255.0f alpha:1]];
        UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
        myBackView.backgroundColor = [UIColor colorWithRed:250/255.0f green:220/255.0f blue:200/255.0f alpha:1];
        cell.selectedBackgroundView = myBackView;
    }
    
    lastPath = indexPath;
    //[tableView reloadData];
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (void) loadNavigationFormat{
    //CGRect windowRect = [[UIScreen mainScreen] bounds];
    //float w = windowRect.size.width;float h = windowRect.size.height;
    self.navigationItem.title = @"商品資訊";
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:250/255.0 green:180/255.0 blue:120/255.0 alpha:1.0]];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (IBAction)button_selectDate:(id)sender {
    [self.button_sectionDate setEnabled:NO];
    [self.button_sectionLocation setEnabled:YES];
    [self.button_sectionDate setBackgroundColor: [UIColor colorWithRed:160/255.0f green:160/255.0f blue:230/255.0f alpha:1]];
    [self.button_sectionLocation setBackgroundColor: [UIColor colorWithRed:160/255.0f green:160/255.0f blue:230/255.0f alpha:0.6]];
    filter_typeNow = filter_types[3];
    [self sortWithFilter:filter_typeNow];
    [self.commodity_table reloadData];
}
- (IBAction)button_selectLocation:(id)sender {
    [self.button_sectionDate setEnabled:YES];
    [self.button_sectionLocation setEnabled:NO];
    [self.button_sectionDate setBackgroundColor: [UIColor colorWithRed:160/255.0f green:160/255.0f blue:230/255.0f alpha:0.6]];
    [self.button_sectionLocation setBackgroundColor: [UIColor colorWithRed:160/255.0f green:160/255.0f blue:230/255.0f alpha:1]];
    filter_typeNow = filter_types[2];
    [self sortWithFilter:filter_typeNow];
    [self.commodity_table reloadData];
}


@end
