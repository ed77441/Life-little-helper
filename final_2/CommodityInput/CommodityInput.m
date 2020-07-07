//
//  CommodityInput.m
//  final_2
//
//  Created by eb211-22 on 2019/12/16.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import "CommodityInput.h"
@interface CommodityInput ()
{
    CommodityInput_QR *input_qr;
    CommodityInput_TV *input_tv;
    
    NSMutableArray *commodity_inputInfo;
}
@end

@implementation CommodityInput
- (void)viewDidLayoutSubviews{
    CGRect windowRect = [[UIScreen mainScreen] bounds];
    float w = windowRect.size.width;float h = windowRect.size.height;
    float nh = self.navigationController.navigationBar.frame.size.height;
    float ny = self.navigationController.navigationBar.frame.origin.y;
    _choose_input.frame = CGRectMake(0.0, nh+ny, w/2.0, h/16.0);
    _choose_input.layer.borderWidth = 3.0f;
    _choose_input.layer.borderColor = [UIColor colorWithRed:240/255.0f green:80/255.0f blue:120/255.0f alpha:1].CGColor;
    _choose_input.titleLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:18];
    [_choose_input setTitleColor:[UIColor colorWithRed:240/255.0f green:80/255.0f blue:120/255.0f alpha:1] forState:UIControlStateNormal];
    _choose_qrcode.frame = CGRectMake(w/2.0, nh+ny, w/2.0, h/16.0);
    _choose_qrcode.layer.borderWidth = 3.0f;
    _choose_qrcode.layer.borderColor = [UIColor colorWithRed:240/255.0f green:80/255.0f blue:120/255.0f alpha:1].CGColor;
    _choose_qrcode.titleLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:18];
    [_choose_qrcode setTitleColor:[UIColor colorWithRed:240/255.0f green:80/255.0f blue:120/255.0f alpha:1] forState:UIControlStateNormal];
    _input_view.frame = CGRectMake(0.0, h/16.0+nh+ny, w, h*15/16.0-nh-ny);
    //size_w=_input_view.bounds.size.width, size_h=_input_view.bounds.size.height;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    input_tv = [[CommodityInput_TV alloc]initWithNibName:@"CommodityInput_Tableview" bundle:nil];
    [input_tv changeViewSize:_input_view.bounds.size.width height:_input_view.bounds.size.height];
    input_qr = [[CommodityInput_QR alloc]initWithNibName:@"CommodityInput_QRcode" bundle:nil];
    [input_qr changeViewSize:_input_view.bounds.size.width height:_input_view.bounds.size.height];
    [input_qr passingArg: @{@"bro" : input_tv, @"parent": self}];

    [self loadNavigationFormat];
    [self viewDidLayoutSubviews];
    [input_tv viewDidLoad];
    [self swapView:input_tv old_vc:input_qr symbol:@"QR"];
}



-(void)swapView:(UIViewController*)now_vc old_vc:(UIViewController*)old_vc symbol:(NSString*)type{
    if(old_vc){
        [old_vc.view removeFromSuperview];
    }
    
    if ([type isEqualToString:@"QR"]){
        now_vc = input_qr;
    }
    else if([type isEqualToString:@"TV"]){
        now_vc = input_tv;
    }

    //[_input_view setFrame:now_vc.view.bounds];
    //NSLog([NSString stringWithFormat:@"%f %f", w, h]);
    [_input_view addSubview:now_vc.view];
}


- (IBAction)button_input:(id)sender {
    [self swapView:input_tv old_vc:input_qr symbol:@"TV"];
}

- (IBAction)button_qrcode:(id)sender {
    [self swapView:input_qr old_vc:input_tv symbol:@"QR"];
}



- (void) loadNavigationFormat{
    //CGRect windowRect = [[UIScreen mainScreen] bounds];
    //float w = windowRect.size.width;float h = windowRect.size.height;
    self.navigationItem.title = @"商品輸入";
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:250/255.0 green:180/255.0 blue:120/255.0 alpha:1.0]];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

//keyboard
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



//commodity info transfer



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) update:(nullable NSDictionary *)args {
    //NSLog(@"%d", ((NSNumber*)args[@"2"]).intValue);
    [self swapView:input_tv old_vc:input_qr symbol:@"TV"];

    
}
- (void) passingArg:(NSDictionary *)args {}
@end
