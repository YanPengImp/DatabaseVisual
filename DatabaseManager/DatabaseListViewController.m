//
//  DatabaseListViewController.m
//  DQGuess
//
//  Created by Imp on 2018/11/5.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import "DatabaseListViewController.h"
#import "DatabaseTableViewController.h"
#import "DatabaseFactory.h"

@interface DatabaseListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dbPaths;

@end

@implementation DatabaseListViewController

- (instancetype)initWithDBPaths:(NSArray *)dbPaths {
    if (self = [super init]) {
        self.dbPaths = [dbPaths copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"db list";
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = false;
    [self.view addSubview:_tableView];

    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemDidClickAction)]];
    // Do any additional setup after loading the view.
}

- (void)leftBarButtonItemDidClickAction {
    if (_delegate && [_delegate respondsToSelector:@selector(databaseListViewControllerDidFinish)]) {
        [_delegate databaseListViewControllerDidFinish];
    }
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dbPaths.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"listNameCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [DatabaseFactory dbNameFromPath:_dbPaths[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DatabaseTableViewController *tableViewController = [[DatabaseTableViewController alloc] initWithDB:_dbPaths[indexPath.row]];
    [self.navigationController pushViewController:tableViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
