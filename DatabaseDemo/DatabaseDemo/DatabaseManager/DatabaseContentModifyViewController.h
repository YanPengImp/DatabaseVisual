//
//  DatabaseContentModifyViewController.h
//  DQGuess
//
//  Created by Imp on 2018/11/13.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseGridView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DatabaseContentModifyViewControllerDelegate <NSObject>

- (void)modifyViewControllerDidModifyContent:(NSString *)content withGridIndex:(GridIndex)gridIndex;

@end

@interface DatabaseContentModifyViewController : UIViewController

- (instancetype)initWithContent:(NSString *)content gridIndex:(GridIndex)gridIndex;

@property (nonatomic, weak) id<DatabaseContentModifyViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
