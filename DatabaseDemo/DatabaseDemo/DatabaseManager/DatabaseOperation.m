//
//  DatabaseOperation.m
//  DQGuess
//
//  Created by Imp on 2018/11/5.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import "DatabaseOperation.h"
#import <sqlite3.h>
#import <pthread.h>

typedef enum : NSUInteger {
    DatabaseTypeInteger = 0,
    DatabaseTypeFloat,
    DatabaseTypeString,
    DatabaseTypeBlob,
    DatabaseTypeNull,
} DatabaseType;

@implementation DatabaseOperation
{
    sqlite3 *_db;
    NSString *_databasePath;
    pthread_mutex_t mutex;
}

- (instancetype)initWithPath:(NSString *)path {
    if (self = [super init]) {
        _databasePath = [path copy];
        pthread_mutex_init(&mutex, NULL);
    }
    return self;
}

- (NSArray <NSString *>*)queryAllTablesNames {
    NSString *sql = @"SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name";
    NSArray *resultArray = [self executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in resultArray) {
        [array addObject:dict[@"name"]];
    }
    return array;
}

- (NSArray <NSString *> *)queryAllColumnNameWithTable:(NSString *)table {
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info('%@')",table];
    NSArray *resultArray =  [self executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in resultArray) {
        [array addObject:dict[@"name"]];
    }
    return array;
}

- (NSArray *)queryAllContentWithTable:(NSString *)table {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",table];
    return [self executeQuery:sql];
}

- (BOOL)deleteRow:(NSInteger)row inTable:(NSString *)table {
    //delete one row in table
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE rowid IN (SELECT rowid FROM %@ limit %ld,1)", table, table, row];
    return [self executStatement:sql];
}

- (BOOL)updateRow:(NSInteger)row column:(NSInteger)column content:(NSString *)content inTable:(NSString *)table {
    //update data in one row
    NSString *columnName = [self queryAllColumnNameWithTable:table][column];
    DatabaseType columeType = [self queryColumeType:column inTable:table];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' WHERE rowid IN (SELECT rowid FROM %@ limit %ld,1)",table, columnName, [self dataTypeFormat:columeType content:content], table, row];
    return [self executStatement:sql];
}

#pragma mark -- Private

- (BOOL)open {
    pthread_mutex_lock(&mutex);
    if (_db) {
        return YES;
    }
    int ret = sqlite3_open([_databasePath UTF8String], &_db);
    if(ret != SQLITE_OK) {
        NSLog(@"error opening!: %d", ret);
        return NO;
    }
    return YES;
}

- (BOOL)close {
    if (!_db) {
        return YES;
    }
    int  rc;
    BOOL retry;
    BOOL triedFinalizingOpenStatements = NO;
    do {
        retry = NO;
        rc = sqlite3_close(_db);
        if (SQLITE_BUSY == rc || SQLITE_LOCKED == rc) {
            if (!triedFinalizingOpenStatements) {
                triedFinalizingOpenStatements = YES;
                sqlite3_stmt *pStmt;
                while ((pStmt = sqlite3_next_stmt(_db, nil)) !=0) {
                    NSLog(@"Closing leaked statement");
                    sqlite3_finalize(pStmt);
                    retry = YES;
                }
            }
        }
        else if (SQLITE_OK != rc) {
            NSLog(@"error closing!: %d", rc);
        }
    } while (retry);
    _db = nil;
    pthread_mutex_unlock(&mutex);
    return YES;
}

- (NSArray *)executeQuery:(NSString *)sql {
    [self open];
    NSMutableArray *resultArray = [NSMutableArray array];
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(_db, [sql UTF8String], -1, &stmt, 0);
    if (ret == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSUInteger num_cols = (NSUInteger)sqlite3_data_count(stmt);
            if (num_cols > 0) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:num_cols];
                int columnCount = sqlite3_column_count(stmt);
                int columnIdx = 0;
                for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
                    NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name(stmt, columnIdx)];
                    id objectValue = [self objectForColumnIndex:columnIdx stmt:stmt];
                    [dict setObject:objectValue forKey:columnName];
                }
                [resultArray addObject:dict];
            }
        }
    } else {
        NSLog(@"**** DB query error = %@, errorCode = %d, SQL error = %@ ****",[NSString stringWithUTF8String:sqlite3_errmsg(_db)],sqlite3_errcode(_db),sql);
    }
    [self close];
    return resultArray;
}

- (BOOL)executStatement:(NSString *)sql {
    [self open];
    char *errmsg = nil;
    int ret = sqlite3_exec(_db, [sql UTF8String], nil, nil, &errmsg);
    if (errmsg) {
        NSLog(@"DB execut Error = %s, SQL error = %@",errmsg,sql);
    }
    [self close];
    return ret == SQLITE_OK;
}

- (id)objectForColumnIndex:(int)columnIdx stmt:(sqlite3_stmt*)stmt {
    int columnType = sqlite3_column_type(stmt, columnIdx);
    id returnValue = nil;
    if (columnType == SQLITE_INTEGER) {
        returnValue =  [NSNumber numberWithLongLong:sqlite3_column_int64(stmt, columnIdx)];
    } else if (columnType == SQLITE_FLOAT) {
        returnValue = [NSNumber numberWithDouble:sqlite3_column_double(stmt, columnIdx)];
    } else if (columnType == SQLITE_BLOB) {
        returnValue = [self dataForColumnIndex:columnIdx stmt:stmt];
    } else {
        returnValue = [self stringForColumnIndex:columnIdx stmt:stmt];
    }
    if (returnValue == nil) {
        returnValue = [NSNull null];
    }
    return returnValue;
}

- (NSString *)stringForColumnIndex:(int)columnIdx stmt:(sqlite3_stmt *)stmt {
    if (sqlite3_column_type(stmt, columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }
    const char *c = (const char *)sqlite3_column_text(stmt, columnIdx);
    if (!c) {
        // null row.
        return nil;
    }
    return [NSString stringWithUTF8String:c];
}

- (NSData *)dataForColumnIndex:(int)columnIdx stmt:(sqlite3_stmt *)stmt {
    if (sqlite3_column_type(stmt, columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }
    const char *dataBuffer = sqlite3_column_blob(stmt, columnIdx);
    int dataSize = sqlite3_column_bytes(stmt, columnIdx);
    if (dataBuffer == NULL) {
        return nil;
    }
    return [NSData dataWithBytes:(const void *)dataBuffer length:(NSUInteger)dataSize];
}

- (DatabaseType)queryColumeType:(NSInteger)column inTable:(NSString *)table {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ limit 0,1",table];
    [self open];
    DatabaseType type = DatabaseTypeNull;
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(_db, [sql UTF8String], -1, &stmt, 0);
    if (ret == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int columnType = sqlite3_column_type(stmt, (int)column);
            if (columnType == SQLITE_INTEGER) {
                type = DatabaseTypeInteger;
            } else if (columnType == SQLITE_FLOAT) {
                type = DatabaseTypeFloat;
            } else if (columnType == SQLITE_BLOB) {
                type = DatabaseTypeBlob;
            } else if (columnType == SQLITE_TEXT){
                type = DatabaseTypeString;
            }
            //else is null type
        }
    } else {
        NSLog(@"**** DB queryColumn error = %@, errorCode = %d, SQL error = %@ ****",[NSString stringWithUTF8String:sqlite3_errmsg(_db)],sqlite3_errcode(_db),sql);
    }
    [self close];
    return type;
}

- (id)dataTypeFormat:(DatabaseType)type content:(NSString *)content {
    if (type == DatabaseTypeInteger) {
        return [NSNumber numberWithInteger:content.integerValue];
    } else if (type == DatabaseTypeFloat) {
        return [NSNumber numberWithInteger:content.floatValue];
    } else if (type == DatabaseTypeBlob) {
        return [content dataUsingEncoding:NSUTF8StringEncoding];
    } else {
        if (content && content.length) {
            return content;
        } else {
            return [NSNull null];
        }
    }
}

@end
