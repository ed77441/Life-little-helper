//
//  PassingArgsAndUpdate.h
//  final_2
//
//  Created by eb211-22 on 2020/1/2.
//  Copyright © 2020 Yuntech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol PassingArgsAndUpdate <NSObject>



@required
- (void) update: (nullable NSDictionary*) args;
- (void) passingArg: (NSDictionary*) args;


@end

NS_ASSUME_NONNULL_END
