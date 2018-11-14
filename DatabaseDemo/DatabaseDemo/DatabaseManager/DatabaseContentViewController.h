//
//  DatabaseContentViewController.h
//  DQGuess
//
//  Created by Imp on 2018/11/7.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatabaseOperation;

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseContentViewController : UIViewController

- (instancetype)initWithDBOperation:(DatabaseOperation *)dbOperation tableName:(NSString *)tableName;

@end

NS_ASSUME_NONNULL_END
