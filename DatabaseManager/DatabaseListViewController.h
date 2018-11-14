//
//  DatabaseListViewController.h
//  DQGuess
//
//  Created by Imp on 2018/11/5.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DatabaseListViewControllerDelegate <NSObject>

- (void)databaseListViewControllerDidFinish;

@end

@interface DatabaseListViewController : UIViewController

- (instancetype)initWithDBPaths:(NSArray *)dbPaths;

@property (nonatomic, weak) id<DatabaseListViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
