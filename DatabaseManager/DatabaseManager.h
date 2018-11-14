//
//  DatabaseManager.h
//  DQGuess
//
//  Created by Imp on 2018/11/5.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseManager : NSObject

@property (nonatomic, strong) NSString *dbDocumentPath;

+ (instancetype)sharedInstance;

- (void)showTables;

- (void)hideTables;

@end

NS_ASSUME_NONNULL_END
