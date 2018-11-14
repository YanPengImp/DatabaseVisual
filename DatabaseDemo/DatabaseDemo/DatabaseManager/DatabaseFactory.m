//
//  DatabaseFactory.m
//  DQGuess
//
//  Created by Imp on 2018/11/5.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import "DatabaseFactory.h"

@implementation DatabaseFactory

+ (NSArray <NSString *>*)supportDBFileExtension {
    return @[@"db", @"sqlite", @"sqlite3"];
}

+ (NSArray *)queryIfHadDBFromDirectory:(NSString *)directory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtPath:directory];
    NSMutableArray *filePathArray = [NSMutableArray array];
    NSString *file;
    while((file = [directoryEnumerator nextObject])) {
        if([[DatabaseFactory supportDBFileExtension] containsObject:[file pathExtension]]) {
            [filePathArray addObject:[directory stringByAppendingPathComponent:file]];
        }
    }
    return filePathArray;
}

+ (NSString *)dbNameFromPath:(NSString *)path {
    return path.lastPathComponent;
}

@end
