//
//  CommodityInput_QR.m
//  final_2
//
//  Created by eb211-22 on 2019/12/19.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import "CommodityInput_QR.h"
#import <AVFoundation/AVFoundation.h>
#import "CommodityInput_TV.h"
@interface CommodityInput_QR ()
{
    float size_w;
    float size_h;
    
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *previewLayer;
    CommodityInput_TV *qr_view;
    id <PassingArgsAndUpdate> bro, parent;
    
    UIColor *bc_color;
}
@end

@implementation CommodityInput_QR

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //CGRect windowRect = [[UIScreen mainScreen] bounds];
    //float w = windowRect.size.width;float h = windowRect.size.height;
    //[self.view setFrame:CGRectMake(0.0, 0.0, w, h)];
    bc_color = [UIColor colorWithRed:255/255.0 green:230/255.0 blue:180/255.0 alpha:0.9];
    [self.view setFrame:CGRectMake(0.0, 0.0, size_w, size_h)];
    [self.view setBackgroundColor:bc_color];
    
    [self.QR_view setFrame:CGRectMake(5.0, 5.0, size_w-10.0, size_w-10.0)];
    



    
    self.view.userInteractionEnabled=YES;   // default=yes
    self.view.multipleTouchEnabled=NO;  // default=no
    
    
    [self test];
}


//change view size (for super)
-(void)changeViewSize:(float)w height:(float)h{
    size_w = w;
    size_h = h;
}

- (void)viewDidAppear:(BOOL)animated{
    //NSLog(@"Wa Da Shi Wa No.1!");
}
- (void)viewWillAppear:(BOOL)animated{
    [self test];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self test_close];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"TV:A!");
    if (touches.anyObject.tapCount == 2){
        NSLog(@"KaCha!");
    }
    
}


-(void)test{
    BOOL isReading;
    //create session
    //AVCaptureSession *captureSession = [[AVCaptureSession alloc]init];
    captureSession =[[AVCaptureSession alloc]init] ;
    
    
    //addinput
    NSError *error;
    AVCaptureDevice *devcie = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:devcie error:&error];
    
    [captureSession addInput:deviceInput];
    
    //addoutput
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc]init];
    [captureSession addOutput:metadataOutput];
    
    dispatch_queue_t queue = dispatch_queue_create("MyQueue", NULL);
    [metadataOutput setMetadataObjectsDelegate:self queue:queue];
    [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    //show caught frame
    //AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:captureSession];
    previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:captureSession];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [previewLayer setFrame:_QR_view.layer.bounds];
    [_QR_view.layer addSublayer:previewLayer];

    [captureSession startRunning];
}

-(void)test_close{
    
    [captureSession stopRunning];
    captureSession = nil;
    [previewLayer removeFromSuperlayer];
    
}

- (void) captureOutput:(AVCaptureOutput*)captureOutput didOutputMetadataObjects:(nonnull NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(nonnull AVCaptureConnection *)connection{
    if (metadataObjects!= nil && [metadataObjects count] > 0){
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]){
            //NSLog(@"%@",[metadataObj stringValue]);
            NSLog(@"%@", metadataObj);
            NSString *inputString = [metadataObj stringValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dict;
                NSMutableArray *result = [[NSMutableArray alloc] init];
                NSArray <NSString*>*splitted ;
                
                NSString *inputStr = inputString;
                
                if ([self isRightQR: inputStr]) {
                   
                    splitted = [inputStr componentsSeparatedByString:@":"];
                    NSLog(@"Right");

                    if ([splitted[0] length] > 2) {

                        NSString *firstOne = splitted[0];
                        firstOne = [firstOne substringWithRange:NSMakeRange(2, [firstOne length] - 2)];
                        NSLog(@"%@", firstOne);
                        NSLog(@"stick together %@", splitted);
                        dict = @{@"name": firstOne , @"number": [self replaceSpaces: splitted[1]], @"price": [self replaceSpaces: splitted[2]]};
                        [result addObject: dict];
                        
                        for (int i = 3 ; i < [splitted count] ; i += 3) {
                            dict = @{@"name": splitted[i] , @"number": [self replaceSpaces: splitted[i+1]], @"price": [self replaceSpaces: splitted[i+2]]};
                            [result addObject: dict];
                        }
                    }
                    else {
                        for (int i = 1 ; i < [splitted count] ; i += 3) {
                             dict = @{@"name": splitted[i] , @"number":[self replaceSpaces:  splitted[i+1]], @"price": [self replaceSpaces: splitted[i+2]]};
                            [result addObject: dict];
                        }
                    }
                    [self->bro update: @{@"result": result}];
                }
                else {
                    if ([self isLeftQR: inputStr]) {
                        NSLog(@"Left %@" , inputStr);
                        NSString *dateStr = [inputStr substringWithRange:NSMakeRange(10, 7)];
                        NSString *y = [dateStr substringWithRange:NSMakeRange(0, 3)];
                        int y_value = [y intValue]+1911;
                        NSString *m = [dateStr substringWithRange:NSMakeRange(3, 2)];
                        int m_value = [m intValue];
                        NSString *d = [dateStr substringWithRange:NSMakeRange(5, 2)];
                        int d_value = [d intValue];
                        [self->bro update: @{@"action": @"qrcode date",@"year":@(y_value), @"month":@(m_value), @"day":@(d_value)}];
                        
                        inputStr = [inputStr substringWithRange:NSMakeRange(89, [inputStr length] - 89)];
                        
                        splitted = [inputStr componentsSeparatedByString:@":"];
                        
                        for (int i = 3 ; i < [splitted count] ; i += 3) {
                            dict = @{@"name": splitted[i] , @"number": [self replaceSpaces: splitted[i+1]], @"price": [self replaceSpaces: splitted[i+2]]};
                            [result addObject: dict];
                        }
                        [self->bro update: @{@"result": result}];
                    }
                    else {
                        NSLog(@"You need to go fuck youself");
                        //[self->bro update: nil];
                    }
                }
            

               [self->parent update: nil];
            });
            

            //for(int i=0; i< [[metadataObj stringValue] string])
        }
    }
}

- (bool) isRightQR : (NSString*)str {
    bool valid = false;
    if ([str length] > 2) {
        NSString *subStr = [str substringWithRange:NSMakeRange(0, 2)];
        NSInteger arrNum = [[str componentsSeparatedByString:@":"] count];
        valid = [subStr isEqualToString: @"**"] && arrNum >= 3;
    }
    return valid;
}


- (bool) isLeftQR : (NSString*)str {
    bool valid = false;
    if ([str length] >= 89) {
        NSInteger times = [[str componentsSeparatedByString:@":"] count] -1;
        valid = times >= 4;
    }
    return valid;
}

- (NSString*)replaceSpaces : (NSString*) str{
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)passingArg:(NSDictionary *)args {
    bro = args[@"bro"];
    parent = args[@"parent"];
}


- (void)update:(nullable NSDictionary *)args {}
@end
