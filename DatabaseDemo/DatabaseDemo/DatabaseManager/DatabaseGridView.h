//
//  DatabaseGridView.h
//  DQGuess
//
//  Created by Imp on 2018/11/8.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatabaseGridView;

typedef struct _GridIndex {
    NSInteger column;
    NSInteger row;
} GridIndex;

@protocol DatabaseGridViewDelegate <NSObject>

@optional
- (void)gridView:(DatabaseGridView *)gridView didClickContentLabel:(UILabel *)label gridIndex:(GridIndex)gridIndex;
- (void)gridView:(DatabaseGridView *)gridView didSelectedRow:(NSInteger)row;
- (void)gridView:(DatabaseGridView *)gridView didDeselectedRow:(NSInteger)row;

@end

@protocol DatabaseGridViewDataSource <NSObject>

@required
- (NSInteger)numberOfColumnsInGridView:(DatabaseGridView *)gridView;
- (NSInteger)numberOfRowsInGridView:(DatabaseGridView *)gridView;
- (NSString *)columnNameInColumn:(NSInteger)column;
- (NSString *)rowNameInRow:(NSInteger)row;
- (NSArray *)contentsAtRow:(NSInteger)row;
@optional
- (NSString *)gridView:(DatabaseGridView *)gridView contentAtGridIndex:(GridIndex)gridIndex;
- (CGFloat)gridView:(DatabaseGridView *)gridView widthForContentCellInColumn:(NSInteger)column;
- (CGFloat)gridView:(DatabaseGridView *)gridView heightForContentCellInRow:(NSInteger)row;

@end


@interface DatabaseGridView : UIView

@property (nonatomic, weak) id<DatabaseGridViewDelegate> delegate;
@property (nonatomic, weak) id<DatabaseGridViewDataSource> dataSource;

- (void)reloadData;

@end

