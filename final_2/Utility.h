//
//  Utility.h
//  final_2
//
//  Created by eb211-22 on 2019/12/21.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface Utility : NSObject

+ (NSDictionary*) createDictWithKeysAndValues: (NSArray*)keys vals:(NSArray*)values;
+ (id) checkNil :(id) val ;
+ (BOOL) checkIllegalColumn: (NSArray*)arr vals: (NSArray*)vals ;
+ (UIImage *)changeSomeColorTransparent: (UIImage *)image isWhite: (bool)isWhite;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize ;
@end

NS_ASSUME_NONNULL_END
