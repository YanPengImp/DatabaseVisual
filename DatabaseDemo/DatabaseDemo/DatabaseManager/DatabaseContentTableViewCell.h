//
//  DatabaseContentTableViewCell.h
//  DQGuess
//
//  Created by Imp on 2018/11/8.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseContentTableViewCell : UITableViewCell

- (void)loadContents:(NSArray *)contents;

@property (nonatomic, copy) void(^clickLabel)(UILabel *label, NSInteger column);

@end

NS_ASSUME_NONNULL_END
