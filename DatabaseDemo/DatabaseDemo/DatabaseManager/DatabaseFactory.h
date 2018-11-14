//
//  DatabaseFactory.h
//  DQGuess
//
//  Created by Imp on 2018/11/5.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseFactory : NSObject

+ (NSArray *)queryIfHadDBFromDirectory:(NSString *)directory;

+ (NSString *)dbNameFromPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
