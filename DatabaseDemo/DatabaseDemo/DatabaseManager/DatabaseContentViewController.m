//
//  DatabaseContentViewController.m
//  DQGuess
//
//  Created by Imp on 2018/11/7.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import "DatabaseContentViewController.h"
#import "DatabaseContentModifyViewController.h"
#import "DatabaseGridView.h"
#import "DatabaseOperation.h"

@interface DatabaseContentViewController () <DatabaseGridViewDelegate, DatabaseGridViewDataSource, DatabaseContentModifyViewControllerDelegate>

@property (nonatomic, strong) DatabaseGridView *gridView;
@property (nonatomic, strong) DatabaseOperation *dbOperation;
@property (nonatomic, strong) NSArray *columnArray;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) GridIndex clickedGridIndex;

@end

@implementation DatabaseContentViewController

- (instancetype)initWithDBOperation:(DatabaseOperation *)dbOperation tableName:(nonnull NSString *)tableName {
    if (self = [super init]) {
        self.dbOperation = dbOperation;
        self.tableName = [tableName copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initViews];
    [self refreshData];
    // Do any additional setup after loading the view.
}

- (void)initViews {
    [self initVC];
    [self initGridView];
}

- (void)initVC {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.tableName;
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"deleteRow" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemDidClickAction)]];
}

- (void)initGridView {
    _gridView = [[DatabaseGridView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _gridView.delegate = self;
    _gridView.dataSource = self;
    [self.view addSubview:_gridView];
}

- (void)refreshData {
    self.selectedRow = -1;
    self.columnArray = [self.dbOperation queryAllColumnNameWithTable:_tableName];
    self.contentArray = [self.dbOperation queryAllContentWithTable:_tableName];
    [self.gridView reloadData];
}

- (void)rightBarButtonItemDidClickAction {
    if (self.selectedRow >= 0) {
        if ([self.dbOperation deleteRow:self.selectedRow inTable:_tableName]) {
            [self refreshData];
        }
    }
}

- (void)jumpmToModifyViewControllerWithContent:(NSString *)content gridIndex:(GridIndex)gridIndex {
    DatabaseContentModifyViewController *modifyVC = [[DatabaseContentModifyViewController alloc] initWithContent:content gridIndex:gridIndex];
    modifyVC.delegate = self;
    [self.navigationController pushViewController:modifyVC animated:YES];
}

#pragma mark -- DatabaseGridViewDelegate, DatabaseGridViewDataSource

- (NSInteger)numberOfRowsInGridView:(DatabaseGridView *)gridView {
    return _contentArray.count;
}

- (NSInteger)numberOfColumnsInGridView:(DatabaseGridView *)gridView {
    return _columnArray.count;
}

- (NSString *)columnNameInColumn:(NSInteger)column {
    return _columnArray[column];
}

- (NSString *)rowNameInRow:(NSInteger)row {
    //display row number begin at 1
    return [NSString stringWithFormat:@"%zd",row + 1];
}

- (NSString *)gridView:(DatabaseGridView *)gridView contentAtGridIndex:(GridIndex)gridIndex {
    NSDictionary *dict = _contentArray[gridIndex.row];
    return dict[_columnArray[gridIndex.column]];
}

- (NSArray *)contentsAtRow:(NSInteger)row {
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dict = _contentArray[row];
    for (NSInteger i = 0; i < _columnArray.count; i++) {
        id obj = dict[_columnArray[i]];
        if ([obj isKindOfClass:[NSNull class]]) {
            [array addObject:@"null"];
        } else {
            [array addObject:[NSString stringWithFormat:@"%@",dict[_columnArray[i]]]];
        }
    }
    return array;
}

- (CGFloat)gridView:(DatabaseGridView *)gridView widthForContentCellInColumn:(NSInteger)column {
    return 100;
}

- (CGFloat)gridView:(DatabaseGridView *)gridView heightForContentCellInRow:(NSInteger)row {
    return 30;
}

- (void)gridView:(DatabaseGridView *)gridView didClickContentLabel:(UILabel *)label gridIndex:(GridIndex)gridIndex {
    NSString *content = [self contentsAtRow:gridIndex.row][gridIndex.column];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:content message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"copy" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (content && content.length) {
            UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
            pastboard.string = content;
        }
    }]];
    __weak typeof(self)weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"modify" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf jumpmToModifyViewControllerWithContent:content gridIndex:gridIndex];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil]];
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        // fix iPad crash when show alert
        // https://stackoverflow.com/questions/24224916/presenting-a-uialertcontroller-properly-on-an-ipad-using-ios-8
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [alert
                                                         popoverPresentationController];
        popPresenter.sourceView = label;
        popPresenter.sourceRect = label.bounds;
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)gridView:(DatabaseGridView *)gridView didSelectedRow:(NSInteger)row {
    self.selectedRow = row;
}

- (void)gridView:(DatabaseGridView *)gridView didDeselectedRow:(NSInteger)row {
    self.selectedRow = -1;
}

#pragma mark -- DatabaseContentModifyViewControllerDelegate

- (void)modifyViewControllerDidModifyContent:(NSString *)content withGridIndex:(GridIndex)gridIndex {
    if ([self.dbOperation updateRow:gridIndex.row column:gridIndex.column content:content inTable:self.tableName]) {
        [self refreshData];
    }
}


@end
