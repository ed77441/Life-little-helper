//
//  NotificationManager.m
//  final_2
//
//  Created by mac15 on 2019/12/31.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import "NotificationManager.h"
#import <UserNotifications/UNNotificationContent.h>
#import <UserNotifications/UNNotificationTrigger.h>
#import <UserNotifications/UNNotificationServiceExtension.h>
#import <UserNotifications/UNNotificationRequest.h>
#import <UserNotifications/UserNotifications.h>

@implementation NotificationManager

+ (void) pushNotification : uuid title:(NSString*)titleStr content:(NSString*)contentStr  year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour min:(NSInteger)min  {
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
     content.title = [NSString localizedUserNotificationStringForKey: titleStr arguments:nil];
     content.body = [NSString localizedUserNotificationStringForKey: contentStr arguments:nil];
     content.sound = [UNNotificationSound defaultSound];


     NSDateComponents* date = [[NSDateComponents alloc] init];
     date.year = year;
     date.month = month;
     date.day = day;
     date.hour = hour;
     date.minute = min;
     UNCalendarNotificationTrigger* trigger = [UNCalendarNotificationTrigger
            triggerWithDateMatchingComponents:date repeats:NO];
      
     UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:uuid content:content trigger:trigger];
      
     UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
     
     [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
     }];
}

+ (void) dismissNotification : (NSString*)uuid {
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers: @[uuid]];
}

@end
