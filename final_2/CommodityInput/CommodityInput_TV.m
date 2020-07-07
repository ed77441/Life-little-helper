//
//  CommodityInput_TV.m
//  final_2
//
//  Created by eb211-22 on 2019/12/19.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import "CommodityInput_TV.h"
#import "CommodityInput_Tablecell.h"
#import "DBManager.h"
#import "CommodityInput_calendar.h"
@interface CommodityInput_TV ()
{
    bool check_moveview;
    float size_w;
    float size_h;
    float row_number;
    float keyboard_h;
    NSArray *input_types;
    
    NSMutableArray *input_collection;
    //NSMutableArray *data_cell;
    //NSMutableArray *data_row;
    bool inputCheck;
    bool waitAlert;
    NSString *location, *date, *image, *batch;
    
    UIDatePicker *datePicker;
    
    UIColor *bc_color;
}
@end

@implementation CommodityInput_TV

- (void)viewDidLayoutSubviews{

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //load keyboard info
    keyboard_h = 271.0f;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    
    _inputtable.delegate = self;
    _inputtable.dataSource = self;
    //_inputtable.gestureRecognizers;
    row_number = 1;

    input_types = [[NSArray alloc]initWithObjects:@"name",@"price",@"number", nil];
    input_collection = [[NSMutableArray alloc]init];
    
    //typesetting
    bc_color = [UIColor colorWithRed:255/255.0 green:230/255.0 blue:180/255.0 alpha:0.9];
    [self.view setFrame:CGRectMake(0.0, 0.0, size_w, size_h)];
    [self.view setBackgroundColor:bc_color];
    
    [self tableViewResize:_inputtable row:row_number reload:YES];
    [self.inputtable setBackgroundColor:[UIColor clearColor]];
    
    [self.button_add setFrame:CGRectMake(size_w-120.0, size_h-80.0, 100.0, 50.0)];
    //[self.button_add setBackgroundColor:[UIColor colorWithRed:100/255.0 green:250/255.0 blue:200/255.0 alpha:1]];
    self.button_add.layer.cornerRadius = 5.0f;
    
    _text_location.delegate = self;
}

//button to add data
- (IBAction)info_add:(id)sender {
    [self.view endEditing:YES];
    //location date;
    if ([_text_location.text isEqualToString:@""])
        location = @"GPS";
    else
        location = _text_location.text;
    
    if ([_text_date.text isEqualToString:@""])
        date = @"date";
    else
        date = _text_date.text;
    
    //image
    image = @"";
    
    //batch
    batch = [[NSUUID UUID] UUIDString];
    
    NSMutableArray *warninput = [[NSMutableArray alloc]init];
    for (int i=0; i<[input_collection count]; ++i){
        NSLog(@"%@:%@ %@:%@ %@:%@", input_types[0], input_collection[i][0]
              , input_types[1], input_collection[i][1]
              , input_types[2], input_collection[i][2]);
        
        for(int j=0; j<3; ++j){
            if([input_collection[i][j] isEqualToString:@""]){
                [warninput addObject:@(i+1)];

                break;
            }
        }
    }
    
    if([warninput count]>0){
        NSString *alertString = [[NSString alloc]init];
        for(int i=0; i<[warninput count]; ++i){
            alertString = [alertString stringByAppendingFormat:@"Row %@ has empty input\n", warninput[i]];
        }
        NSLog(@"alert %@", alertString);
        [self okAlert:@"Input Error" content:alertString];
    }
    else if([input_collection count] == 0){
        [self showAlert:@"Empty input" content:@""];
    }
    else{
        [self checkAlert:@"Are you sure\nto input these info"];
    }

}

-(void)addToDatabase{
    for (int i=0; i<[input_collection count]; ++i){
        NSDictionary *commodityinfo = [[NSDictionary alloc]
            initWithObjects:@[input_collection[i][0], image, input_collection[i][1], location, date]
            forKeys:@[@"name", @"image", @"price", @"location", @"date"]];
    
        NSDictionary *shoppingrec = [[NSDictionary alloc]
            initWithObjects:@[input_collection[i][0], input_collection[i][1], input_collection[i][2], batch, date, location]
            forKeys:@[@"name", @"price", @"num" , @"batch", @"date" , @"location"]];
        
        [DBManager add:COMMIDITINFO payload:commodityinfo];
        [DBManager add:SHOPPINGREC payload:shoppingrec];
        
        [self showAlert:@"Success to add" content:@""];
        NSLog(@"suceess add %@", commodityinfo);
    }
    input_collection = [[NSMutableArray alloc]init];
    row_number = 1.0f;
    [self tableViewResize:_inputtable row:row_number reload:YES];
}

//change viewsize (for super)
- (void)changeViewSize:(float)w height:(float)h{
    size_w = w;
    size_h = h;
}

//table list
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return row_number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommodityInput_Tablecell *cell;
    //NSLog([NSString stringWithFormat:@"%ld %ld %ld", indexPath.row, indexPath.length, indexPath.item]);
    if ( indexPath.row == row_number-1){
        cell = (CommodityInput_Tablecell*)[[UITableViewCell alloc]init];
        
        UILabel *celllabel_add = [[UILabel alloc]init];
        [celllabel_add setFrame:CGRectMake(0.0, 0.0, size_w-20.0f, 44.0f)];
        [celllabel_add setText:@"Add Commodity"];
        [celllabel_add setTextAlignment:NSTextAlignmentCenter];
        celllabel_add.font = [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:18];
        [celllabel_add setTextColor:[UIColor colorWithRed:250/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f]];
        [cell addSubview:celllabel_add];
        
        [cell setBackgroundColor:[UIColor colorWithRed:230/255.0f green:150/255.0f blue:100/255.0f alpha:1.0f]];
        cell.layer.cornerRadius = 10.0f;
        cell.layer.borderColor = [UIColor colorWithRed:230/255.0f green:130/255.0f blue:80/255.0f alpha:1.0f].CGColor;
        cell.layer.borderWidth = 5;
        
    }
    
    else{
        static NSString *CellIdentifier = @"tablecell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell){
            [tableView registerNib:[UINib nibWithNibName:@"CommodityInput_Tablecell" bundle:nil] forCellReuseIdentifier:@"tablecell"];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        //cell = (CommodityInput_Tablecell*)cell;
        NSString *label = [[NSString alloc]initWithFormat:@"%ld", indexPath.row+1];
        [cell.label_num setText:label];
        [cell.label_num setTextAlignment:NSTextAlignmentCenter];
        
        if(indexPath.row < [input_collection count]){
            cell.text_name.text = input_collection[indexPath.row][0];
            cell.text_price.text = input_collection[indexPath.row][1];
            cell.text_number.text = input_collection[indexPath.row][2];
        }
        else{
            NSMutableArray *input_datas;
            input_datas = [[NSMutableArray alloc]initWithObjects:@"",@"",@"", nil];
            [input_collection addObject:input_datas];
            [input_collection count];
            cell.text_name.text = @"";
            cell.text_name.delegate = self;
            cell.text_name.tag = 0;
            
            cell.text_price.text = @"";
            cell.text_price.delegate = self;
            cell.text_price.tag = 1;
            
            cell.text_number.text = @"";
            cell.text_number.delegate = self;
            cell.text_number.tag = 2;
            

        }

        //design
        [cell setBackgroundColor:[UIColor redColor]];
        
        cell.layer.cornerRadius = 25.0f;
        cell.layer.borderWidth = 5.0f;
        cell.layer.borderColor = bc_color.CGColor;
        
        [cell.button_clear addTarget:self action:@selector(cellbutton_delete:)  forControlEvents:UIControlEventTouchUpInside];
        cell.button_clear.layer.cornerRadius = 5.0f;
        //cell.button_clear.backgroundColor = [UIColor colorWithRed:230/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
        //[cell.button_clear setTitleColor:[UIColor colorWithRed:240/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f] forState:UIControlStateNormal];
        //cell.button_clear.titleLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:11];
        
        
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float cellheight = 102.0f;
    //float cellheight = 110.0f;
    if (indexPath.row == row_number-1){
        cellheight = 44.0f;
    }
    return cellheight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    NSLog(@"tap %ld", indexPath.row);
    if (indexPath.row == row_number-1){
        row_number++;
        [self tableViewResize:tableView row:row_number reload:YES];
    }
}

- (void)tableViewResize:(UITableView *)tableView row:(float)row_number reload:(bool)reload{
    float row_height = (row_number-1) * 102.0f + 44.0f;
    //float row_height = (row_number-1) * 110.0f + 44.0f;
    float div;
    
    if (row_number == 1){
        div = 10.0f;
    }
    else{
        div = 0.0;
    }
    
    if(row_height>size_h-160.0){
        [tableView setFrame:CGRectMake(10.0f, div, size_w-20.0f, size_h-160.0)];
    }
    else{
        [tableView setFrame:CGRectMake(10.0f, div, size_w-20.0f, row_height)];
    }
    if(reload)
        [tableView reloadData];
        
}

//text edit
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //NSLog(@"%f %f", textField.frame.origin.y, size_h);
    
    if(textField.tag<10){
        UIView *superview = textField.superview;
        while(![superview isKindOfClass:[CommodityInput_Tablecell class]]){
            superview = superview.superview;
        }
        UITableViewCell *cell = (UITableViewCell*) superview;
        NSIndexPath *path = [self.inputtable indexPathForCell:cell];
        if(path.row>2){
            [self tableViewResize:self.inputtable row:4.0f reload:NO];
            check_moveview = YES;
        }
        [self.inputtable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
        NSLog(@"%ld", path.row);
        /*
        if (celltext_h > size_h - keyboard_h - 40){
            if(celltext_h>432)celltext_h=432;
            [textField.superview.superview.superview.superview setFrame:CGRectMake(0, -celltext_h + size_h - keyboard_h - 40, size_w, size_h)];
            
            check_moveview = YES;
        }*/
    }
    else{
        if (textField.frame.origin.y>size_h - keyboard_h - 40){
            [textField.superview setFrame:CGRectMake(0, -textField.frame.origin.y + size_h - keyboard_h -40, size_w, size_h)];
            check_moveview = YES;
        }
    }
    //NSLog(@"%d", );
}

- (void)textFieldDidEndEditing:(UITextField*)textField{
    if(textField.tag<10){
        if(check_moveview){
            check_moveview = NO;
            [self tableViewResize:self.inputtable row:5.0f reload:NO];
            //[textField.superview.superview.superview.superview setFrame:CGRectMake(0, 0, size_w, size_h)];
        }
        
        UIView *superview = textField.superview;
        while(![superview isKindOfClass:[CommodityInput_Tablecell class]]){
            superview = superview.superview;
        }
        UITableViewCell *cell = (UITableViewCell*) superview;
        NSIndexPath *path = [self.inputtable indexPathForCell:cell];
        
        switch (textField.tag) {
            case 0:
                input_collection[path.row][0] = textField.text;
                break;
                
            case 1:
                if([textField.text isEqualToString:@""]){
                    textField.text = @"";
                }
                else if(!stringisnumber([textField.text UTF8String])){
                    textField.text = @"";
                    [self showAlert:@"Input type error" content:@"here can only input number"];
                    NSLog(@"here can only input number");
                }
                else{
                    textField.text = [NSString stringWithFormat:@"%d", [textField.text intValue]];
                }
                input_collection[path.row][1] = textField.text;
                break;
                
            case 2:
                if([textField.text isEqualToString:@""]){
                    textField.text = @"";
                }
                else if(!stringisnumber([textField.text UTF8String])){
                    textField.text = @"";
                    [self showAlert:@"Input type error" content:@"here can only input number"];
                    NSLog(@"here can only input number");
                }
                else
                    if([textField.text intValue]==0){
                        textField.text = @"";
                        [self showAlert:@"Input value error" content:@"here can only input number"];
                        NSLog(@"number can't input 0");
                    }
                    else
                        textField.text = [NSString stringWithFormat:@"%d", [textField.text intValue]] ;
                
                input_collection[path.row][2] = textField.text;
                break;
        }
    }
    else{
        if(check_moveview){
            check_moveview = NO;
            [textField.superview setFrame:CGRectMake(0, 0, size_w, size_h)];
        }
    }
    //NSLog(@"%@ %ld", textField.text, path.row);
    //NSLog(@"%@",input_collection[path.row][2]);
}




//keyboard
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    keyboard_h = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //NSLog(@"%f",keyboard_h);
}

//tool
bool stringisnumber(const char* input){
    for (int i=0; i<strlen(input); ++i){
        if(input[i]>'9' || input[i]<'0'){
            return 0;
        }
    }
    return 1;
}

//cell use
- (void)cellbutton_delete:(UIButton*)sender{
    UIView *superview = sender.superview;
    while(![superview isKindOfClass:[CommodityInput_Tablecell class]]){
        superview = superview.superview;
    }
    UITableViewCell *cell = (UITableViewCell*) superview;
    NSIndexPath *path = [self.inputtable indexPathForCell:cell];
    
    NSLog(@"%ld",path.row);
    NSLog(@"%f",row_number);
    
    [input_collection removeObjectAtIndex: path.row];
    
    row_number -= 1;
    [self tableViewResize:_inputtable row:row_number reload:YES];
}

//alert
-(void)showAlert:(NSString *)title content:(NSString*)content{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(clearAlert:) userInfo:alertController repeats:NO];
}
-(void)clearAlert:(NSTimer*)timer{
    UIAlertController *alert = [timer userInfo];
    NSLog(@"clear : %@",[timer userInfo]);
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
}

-(void)okAlert:(NSString *)title content:(NSString*)content{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)checkAlert:(NSString*)content{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:content message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self addToDatabase];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        [self showAlert:@"Cancel addtion" content:@""];
    }];
    [alertController addAction:actionOk];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

//data pass
- (void) update:(nullable NSDictionary *)args {
    
    NSString *action = args[@"action"];
    if (!action) {
        NSArray *result = args[@"result"];
        row_number = row_number + [result count];
        NSLog(@"arr1=%@", input_collection);
        for (NSDictionary *dict in result) {
            NSString *name =  dict[@"name"];
            NSString *price =  dict[@"price"];
            NSString *number =  dict[@"number"];
            
            [input_collection addObject: @[name, price, number]];
        }
        [self tableViewResize:_inputtable row:row_number reload:YES];
        NSLog(@"arr2=%@", input_collection);
    }
    else {
        /*time picker*/
        NSLog(@"args=%@", args);
        
        int y = ((NSNumber*)args[@"year"]).intValue;
        int m = ((NSNumber*)args[@"month"]).intValue;
        int d = ((NSNumber*)args[@"day"]).intValue;

        _text_date.text = [[NSString alloc] initWithFormat: @"%d/%@%d/%@%d", y, m < 10 ? @"0" : @"", m, d < 10 ? @"0" : @"", d];
    }
}
    
- (void) passingArg:(NSDictionary *)args {}

    
- (IBAction)datePick:(id)sender {

    UIButton *bt = sender;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CommodityInput_calendar *datePickerController = [sb instantiateViewControllerWithIdentifier: @"datePicker"];
    datePickerController.modalPresentationStyle = UIModalPresentationPopover;
    datePickerController.preferredContentSize = CGSizeMake(300, 200);
    
    UIPopoverPresentationController *popover =  datePickerController.popoverPresentationController;
    popover.delegate = (id)datePickerController;
    popover.sourceView = self.view;
    popover.sourceRect = CGRectMake(bt.frame.origin.x,bt.frame.origin.y,30,30);
    popover.permittedArrowDirections = UIPopoverArrowDirectionDown;
    
    [datePickerController passingArg: @{@"parent": self}];
    [self presentViewController:datePickerController animated: YES completion: nil];
}


@end
