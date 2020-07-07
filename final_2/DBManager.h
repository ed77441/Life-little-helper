//
//  DBManager.h
//  final_2
//
//  Created by eb211-22 on 2019/12/19.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
NS_ASSUME_NONNULL_BEGIN

typedef NSArray<NSDictionary*>* ResultType;

enum TableType {
  COMMIDITINFO = 0, SHOPPINGREC, REMINDERREC
};

@interface DBManager : NSObject

+ (void) initDBManager;
+ (void) initDBPath;
+ (void) createTables;

+ (void) add:(enum TableType)table payload:(NSDictionary*)payload;
+ (void) remove: (enum TableType)table where:(nullable NSString*)condition;
+ (void) modify: (enum TableType)table setValue:(NSDictionary*)dict where:(nullable NSString*)condition;
+ (NSArray*) retrieve: (enum TableType)table columns:(nullable NSArray<NSString*>*)cols where:(nullable NSString*)condition;

+ (NSDictionary*) createDictForComm : (nullable NSString*)name image:(nullable NSString*)image price:(nullable NSNumber*)price
                            location:(nullable NSString*)location date:(nullable NSString*)date;

+ (NSDictionary*) createDictForShop : (nullable NSString*)name price:(nullable NSNumber*)price num:(nullable NSNumber*)num
                               batch:(nullable NSNumber*)batch date:(nullable NSString*)date location:(nullable NSString*)location;

+(NSDictionary*) createDictForRemi : (nullable NSString*)title content:(nullable NSString*)content year:(nullable NSNumber*)year month: (nullable NSNumber*)month day:(nullable NSNumber*)day hour:(nullable NSNumber*)hour min:(nullable NSNumber*)min pushid:(nullable NSString*) pushid;
@end

NS_ASSUME_NONNULL_END
