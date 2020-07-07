//
//  DBManager.m
//  final_2
//
//  Created by eb211-22 on 2019/12/19.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import "DBManager.h"
#import "Utility.h"

@implementation DBManager

#define dbname @"recorder.sqlite"
static sqlite3 *database = nil;
static NSArray *tableNames = nil;
static NSArray *columnNames = nil;
static NSArray *columnFormats = nil;
static NSString *dbPath = nil;


+ (void) initDBManager{
    
    
    
    
    if (tableNames == nil) {
        tableNames = @[@"commodityinfo", @"shoppingrecord", @"reminderrecord"];
    }
    
    if (columnNames == nil) {
        NSArray *comm = @[@"name", @"image", @"price", @"location", @"date"];
        NSArray *shop = @[@"name", @"price", @"num" , @"batch", @"date" , @"location"];
        NSArray *remi = @[@"title", @"content", @"year", @"month", @"day", @"hour", @"min", @"pushid"];
        columnNames = @[comm, shop, remi];
    }
    
    if (columnFormats == nil) {
        NSArray *comm = @[@"s", @"s", @"i", @"s", @"s"];
        NSArray *shop = @[@"s", @"i", @"i", @"s" ,@"s", @"s"];
        NSArray *remi = @[@"s", @"s", @"i", @"i", @"i", @"i", @"i", @"s"];
        columnFormats = @[comm, shop, remi];
    }
    
    [DBManager initDBPath];
    
    
    
    
    [DBManager createTables];
}

+ (void)initDBPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [paths objectAtIndex:0];
    dbPath = [documentDir stringByAppendingPathComponent:dbname];
    
//    if([[NSFileManager defaultManager] fileExistsAtPath:dbPath]){
//        [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
//    }
    
    NSLog(@"dbpath = %@", dbPath);
}

+ (void)exec: (NSString*)command{

    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        const char *sql_command = [command UTF8String];
        char *errmsg;
        NSLog(@"command = %s\n", sql_command);
        int err = sqlite3_exec(database, sql_command, NULL, NULL, &errmsg);
        
        if(err != SQLITE_OK){
            NSLog(@"Failed to execute command");
            NSLog(@"Error message: %s:", errmsg);
        }
        else{
            NSLog(@"Execute command successfully");
        }
    }
    else {
        NSLog(@"Failed to open database!");
    }

    sqlite3_close(database);
}

+ (void)createTables{
    for (int i = 0; i < 3; ++i) {
        NSString *structure = @"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT%@)";
        NSString *table = [tableNames objectAtIndex: i];
        NSArray *currentTableCol = [columnNames objectAtIndex: i];
        NSArray *currentTableFormat = [columnFormats objectAtIndex: i];
        
        NSMutableString *cols = [[NSMutableString alloc] init];
        for(int j = 0; j < [currentTableCol count]; ++j) {
            NSString *col = [currentTableCol objectAtIndex: j];
            NSString *format = [currentTableFormat objectAtIndex: j];
            
            if ([format isEqualToString: @"s"]) {
                [cols appendFormat: @", %@ TEXT", col];
            }
            else {
                [cols appendFormat: @", %@ INT", col];
            }
        }
        NSString *command = [[NSString alloc] initWithFormat: structure, table, cols];
        NSLog(@"table %d = %@\n", i, command);
        [DBManager exec: command];
    }
}

+ (NSArray*)retrieveData:(NSString*) command tb:(enum TableType)table nofcols:(NSUInteger)numOfCols allColumn:(BOOL)allColumn {
    sqlite3_stmt *statement;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *colNames = [columnNames objectAtIndex: table];
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        NSLog(@"%@" ,@"Open database successfully");
    }
    else {
        NSLog(@"%@" ,@"Failed to open database");
    }
    
    if (sqlite3_prepare_v2(database, [command UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            NSMutableDictionary *row = [[NSMutableDictionary alloc] init];

            for (int i = 0; i < numOfCols ; ++i) {
                NSString *col = [colNames objectAtIndex: i];
                char *field = (char *)sqlite3_column_text(statement, allColumn ? i + 1 : i);
                if (field) {
                    NSString *fieldStr = [[NSString alloc]initWithUTF8String:field];
                    [row setObject:fieldStr forKey: col];
                }
                else {
                    [row setObject:[NSNull null] forKey: col];
                }
            }
            [result addObject: row];
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"Failed to retrieve data");
    }

    sqlite3_close(database);
    return [result count] == 0 ? nil : result;
}

+ (void) add:(enum TableType)table payload:(NSDictionary*)payload{
    NSString *commandFormat =  @"INSERT INTO %@ (%@) VALUES (%@)";
    NSString *command ;
    NSArray *colNames =  [columnNames objectAtIndex: table];
    NSArray *formats = [columnFormats objectAtIndex: table];
    NSMutableArray *valArray = [[NSMutableArray alloc] init];
    
    if ([Utility checkIllegalColumn: colNames vals: [payload allKeys]]) {
        NSLog(@"Illegal column has been found, please fix your typo");
        return;
    }
    
    for(int i = 0; i < [colNames count]; ++i) {
        id value = [payload objectForKey: [colNames objectAtIndex: i]];
        if (value != [NSNull null] && value != nil) {
            NSString *formatted;
            if ([[formats objectAtIndex: i] isEqualToString: @"s"]) {
                formatted = [[NSString alloc] initWithFormat: @"'%@'", (NSString*)value];
            }
            else {
                formatted = [[NSString alloc] initWithFormat: @"%d", ((NSNumber*)value).intValue];
            }
            [valArray addObject: formatted];
        }
        else {
            [valArray addObject: @"?"];
        }
    }

    command = [[NSString alloc] initWithFormat: commandFormat, [tableNames objectAtIndex: table],  [colNames componentsJoinedByString: @","], [valArray componentsJoinedByString: @","]];
    NSLog(@"add command = %@", command);
    [DBManager exec: command];
}

+ (void) remove: (enum TableType)table where:(nullable NSString*)condition {
    NSString *commandFormat = @"DELETE FROM %@ WHERE %@";
    NSString *command = [[NSString alloc] initWithFormat: commandFormat, [tableNames objectAtIndex: table], condition];
    NSLog(@"reomve command = %@", command);
    [DBManager exec: command];
}

+ (NSArray*) retrieve: (enum TableType)table columns:(nullable NSArray<NSString*>*)cols where:(nullable NSString*)condition {
    NSString *commandFormat = @"SELECT %@ FROM %@ WHERE %@";
    NSString *command;
    NSArray *colNames = [columnNames objectAtIndex: table];

    if ([Utility checkIllegalColumn: colNames vals: cols]) {
        NSLog(@"Illegal column has been found, please fix your typo");
        return nil;
    }
    
    cols = cols ? cols : @[@"*"];
    BOOL allColumn = [cols count] == 1 && [[cols objectAtIndex: 0] isEqualToString: @"*"];
    
    NSInteger numOfCols = allColumn ? [colNames count] : [cols count];
    
    if (condition == nil) {
        condition = @"1=1";
    }
    
    command = [[NSString alloc] initWithFormat: commandFormat, [cols componentsJoinedByString: @","], [tableNames objectAtIndex: table], condition];
    NSLog(@"retrieve command = %@", command);
    return [DBManager retrieveData: command tb: table nofcols: numOfCols allColumn: allColumn];
}

+ (void) modify: (enum TableType)table setValue:(NSDictionary*)dict where:(nullable NSString*)condition {
    NSString *commandFormat = @"UPDATE %@ SET %@ WHERE %@";
    NSString *command ;
    NSArray *colNames = [columnNames objectAtIndex: table];
    NSArray *formats = [columnFormats objectAtIndex: table];
    NSMutableArray *listOfSetValues = [[NSMutableArray alloc] init];

    if ([Utility checkIllegalColumn: colNames vals: [dict allKeys]]) {
        NSLog(@"Illegal column has been found, please fix your typo");
        return;
    }
    
    if (condition == nil) {
        condition = @"1=1";
    }
    
    for (NSString* key in dict) {
        id value = [dict objectForKey: key];
        NSString *set;
        if (value != nil && value != [NSNull null]) {
            NSUInteger pos = [colNames indexOfObject: key];

            if ([[formats objectAtIndex: pos] isEqualToString: @"s"]) {
                set = [[NSString alloc] initWithFormat: @"%@ = '%@'", key, (NSString*)value];
            }
            else {
                set = [[NSString alloc] initWithFormat: @"%@ = %d", key, ((NSNumber*)value).intValue];
            }
        }
        else {
            set = [[NSString alloc] initWithFormat: @"%@ = null", key];
        }
        
        [listOfSetValues addObject: set];
    }
    
    command = [[NSString alloc] initWithFormat: commandFormat, [tableNames objectAtIndex: table], [listOfSetValues componentsJoinedByString: @","], condition];
    NSLog(@"modify command = %@", command);
    [DBManager exec: command];
}

+ (NSDictionary*) createDictForComm : (nullable NSString*)name image:(nullable NSString*)image price:(nullable NSNumber*)price
                            location:(nullable NSString*)location date:(nullable NSString*)date {
    NSArray *values = @[[Utility checkNil: name], [Utility checkNil: image], [Utility checkNil: price], [Utility checkNil: location], [Utility checkNil: date]];
    NSArray *keys = [columnNames objectAtIndex: COMMIDITINFO];
    return [Utility createDictWithKeysAndValues: keys vals: values];
}

+ (NSDictionary*) createDictForShop : (nullable NSString*)name price:(nullable NSNumber*)price num:(nullable NSNumber*)num batch:(nullable NSNumber*)batch date:(nullable NSString*)date location:(nullable NSString*)location {
    NSArray *values = @[[Utility checkNil: name], [Utility checkNil: price], [Utility checkNil: num], [Utility checkNil: batch], [Utility checkNil: date], [Utility checkNil: location]];
    NSArray *keys = [columnNames objectAtIndex: SHOPPINGREC];
    return [Utility createDictWithKeysAndValues: keys vals: values];
}

+(NSDictionary*) createDictForRemi : (nullable NSString*)title content:(nullable NSString*)content year:(nullable NSNumber*)year month: (nullable NSNumber*)month day:(nullable NSNumber*)day hour:(nullable NSNumber*)hour min:(nullable NSNumber*)min pushid:(nullable NSString*) pushid{
    NSArray *values = @[[Utility checkNil: title], [Utility checkNil: content], [Utility checkNil: year], [Utility checkNil: month], [Utility checkNil: day], [Utility checkNil: hour], [Utility checkNil: min], [Utility checkNil: pushid]];
    NSArray *keys = [columnNames objectAtIndex: REMINDERREC];
    return [Utility createDictWithKeysAndValues: keys vals: values];
}
@end
