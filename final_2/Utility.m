//
//  Utility.m
//  final_2
//
//  Created by eb211-22 on 2019/12/21.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import "Utility.h"

@implementation Utility


+ (NSDictionary*) createDictWithKeysAndValues: (NSArray*)keys vals:(NSArray*)values{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [keys count]; ++i) {
        NSString *key = [keys objectAtIndex: i];
        id value = (id)[values objectAtIndex: i];
        [dict setObject: value forKey: key];
    }
    return dict;
}

+ (id) checkNil :(id) val {
    return val == nil ? [NSNull null] : val;
}

+ (BOOL) checkIllegalColumn: (NSArray*)arr vals: (NSArray*)vals {
    for (NSString *val in vals) {
        if (![arr containsObject: val]) {
            return true;
        }
    }
    return false;
}


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)changeSomeColorTransparent: (UIImage *)image isWhite: (bool)isWhite;
{

    image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 1.0)];
    CGImageRef rawImageRef=image.CGImage;
    //RGB color range to mask (make transparent)  R-Low, R-High, G-Low, G-High, B-Low, B-High
    const double whiteColorMasking[6] = {222, 255, 222, 255, 222, 255};
    const double blackColorMasking[6] = {0, 33, 0, 33, 0, 33};
    const double *colorMasking = isWhite ? whiteColorMasking : blackColorMasking;

    
    UIGraphicsBeginImageContext(image.size);
    CGImageRef maskedImageRef=CGImageCreateWithMaskingColors(rawImageRef, colorMasking);

    //iPhone translation
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, image.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);

    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height), maskedImageRef);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(maskedImageRef);
    UIGraphicsEndImageContext();
    return result;
}

@end
