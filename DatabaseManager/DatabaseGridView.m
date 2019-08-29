//
//  DatabaseGridView.m
//  DQGuess
//
//  Created by Imp on 2018/11/8.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import "DatabaseGridView.h"
#import "DatabaseLeftTableViewCell.h"
#import "DatabaseContentTableViewCell.h"

/*
————————————————————————————————————————
    |   H   |    E   |     A    |   D     E     R
————|———————|————————|——————————|———————
  L |content|content | content  |           //cell
————|———————|————————|——————————|———————
  E |content|content | content  |           //cell
————|———————|————————|——————————|———————
  F |content|content | content  |           //cell
————|———————|————————|——————————|———————
  T |content|content | content  |           //cell
————————————————————————————————————————
 */

static CGFloat kGridHeaderHeight = 30.f;
static CGFloat kGridLeftWidth = 60.f;
static CGFloat kGridContentCellWidth = 100.f;
static CGFloat kGridContentCellHeight = 30.f;

@interface DatabaseGridView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *contentTableView;

@end

@implementation DatabaseGridView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _leftTableView = [[UITableView alloc] init];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.showsVerticalScrollIndicator = false;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_leftTableView registerClass:[DatabaseLeftTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DatabaseLeftTableViewCell class])];
    [self addSubview:_leftTableView];

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    [self addSubview:_scrollView];

    _contentTableView = [[UITableView alloc] init];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.showsVerticalScrollIndicator = false;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_contentTableView registerClass:[DatabaseContentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DatabaseContentTableViewCell class])];
    [_scrollView addSubview:_contentTableView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _leftTableView.frame = CGRectMake(0, 0, kGridLeftWidth, self.bounds.size.height);
    NSInteger count = [self columnsCount];
    CGFloat width = 0;
    for (NSInteger i = 0; i < count; i++) {
        CGFloat contentCellWidth = kGridContentCellWidth;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridView:widthForContentCellInColumn:)]) {
            contentCellWidth = [self.dataSource gridView:self widthForContentCellInColumn:i];
        }
        width += contentCellWidth;
    }
    _contentTableView.frame = CGRectMake(0, 0, width, self.bounds.size.height);
    _scrollView.frame = CGRectMake(kGridLeftWidth, 0, self.bounds.size.width - kGridLeftWidth, self.bounds.size.height);
    _scrollView.contentSize = _contentTableView.frame.size;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];

    [self reloadData];
}

- (void)reloadData {
    [_leftTableView reloadData];
    [_contentTableView reloadData];
}

- (NSInteger)columnsCount {
    return [_dataSource numberOfColumnsInGridView:self];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _contentTableView) {
        NSInteger count = [self columnsCount];
        CGFloat width = 0;
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        for (NSInteger i = 0; i < count; i++) {
            CGFloat contentCellWidth = kGridContentCellWidth;
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridView:widthForContentCellInColumn:)]) {
                contentCellWidth = [self.dataSource gridView:self widthForContentCellInColumn:i];
            }
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(width, 0, contentCellWidth, kGridHeaderHeight);
            label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.text = [self.dataSource columnNameInColumn:i];
            [headerView addSubview:label];
            width += contentCellWidth;
            if (i < count - 1) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width - 0.5, 0, 0.5, kGridHeaderHeight)];
                line.backgroundColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
                [headerView addSubview:line];
            }
        }
        headerView.frame = CGRectMake(0, 0, width, kGridHeaderHeight);
        return headerView;
    } else {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kGridLeftWidth, kGridHeaderHeight)];
        headerView.backgroundColor = [UIColor lightGrayColor];
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kGridHeaderHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource numberOfRowsInGridView:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridView:heightForContentCellInRow:)]) {
        return [_dataSource gridView:self heightForContentCellInRow:indexPath.row];
    }
    return kGridContentCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isUnEvenRow = indexPath.row % 2 == 1;
    if (tableView == _leftTableView) {
        DatabaseLeftTableViewCell *cell = [_leftTableView dequeueReusableCellWithIdentifier:NSStringFromClass([DatabaseLeftTableViewCell class])];
        cell.label.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        if (isUnEvenRow) {
            cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    } else {
        DatabaseContentTableViewCell *cell = [_contentTableView dequeueReusableCellWithIdentifier:NSStringFromClass([DatabaseContentTableViewCell class])];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(contentsAtRow:)]) {
            [cell loadContents:[self.dataSource contentsAtRow:indexPath.row]];
        }
        __weak typeof(self) weakSelf = self;
        cell.clickLabel = ^(UILabel *label, NSInteger column) {
            GridIndex index;
            index.column = column;
            index.row = indexPath.row;
            [weakSelf didClickContentLabel:label gridIndex:index];
        };
        if (isUnEvenRow) {
            cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        [_contentTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    if (tableView == _contentTableView) {
        [_leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(gridView:didSelectedRow:)]) {
        [_delegate gridView:self didSelectedRow:indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        [_contentTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    if (tableView == _contentTableView) {
        [_leftTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(gridView:didDeselectedRow:)]) {
        [_delegate gridView:self didDeselectedRow:indexPath.row];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _leftTableView) {
        _contentTableView.contentOffset = scrollView.contentOffset;
    }
    if (scrollView == _contentTableView) {
        _leftTableView.contentOffset = scrollView.contentOffset;
    }
}

- (void)didClickContentLabel:(UILabel *)label gridIndex:(GridIndex)gridIndex {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:didClickContentLabel:gridIndex:)]) {
        [self.delegate gridView:self didClickContentLabel:label gridIndex:gridIndex];
    }
}

@end

