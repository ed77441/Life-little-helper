//
//  NotificationManager.h
//  final_2
//
//  Created by mac15 on 2019/12/31.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationManager : NSObject
+ (void) pushNotification : uuid title:(NSString*)titleStr content:(NSString*)contentStr  year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour min:(NSInteger)min  ;

+ (void) dismissNotification : (NSString*)uuid ;
@end

NS_ASSUME_NONNULL_END
