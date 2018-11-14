//
//  DatabaseOperation.h
//  DQGuess
//
//  Created by Imp on 2018/11/5.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseOperation : NSObject

- (instancetype)initWithPath:(NSString *)path;

- (NSArray <NSString *>*)queryAllTablesNames;

- (NSArray <NSString *> *)queryAllColumnNameWithTable:(NSString *)table;

- (NSArray *)queryAllContentWithTable:(NSString *)table;

- (BOOL)deleteRow:(NSInteger)row inTable:(NSString *)table;

- (BOOL)updateRow:(NSInteger)row column:(NSInteger)column content:(NSString *)content inTable:(NSString *)table;

@end

NS_ASSUME_NONNULL_END
