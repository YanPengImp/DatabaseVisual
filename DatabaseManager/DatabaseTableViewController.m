//
//  DatabaseTableViewController.m
//  DQGuess
//
//  Created by Imp on 2018/11/5.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import "DatabaseTableViewController.h"
#import "DatabaseOperation.h"
#import "DatabaseContentViewController.h"

@interface DatabaseTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableNames;
@property (nonatomic, strong) DatabaseOperation *dbOperation;

@end

@implementation DatabaseTableViewController

- (instancetype)initWithDB:(NSString *)db {
    if (self = [super init]) {
        self.dbOperation = [[DatabaseOperation alloc] initWithPath:db];
        self.tableNames = [self.dbOperation queryAllTablesNames];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"table list";
    [self setTableView];
    // Do any additional setup after loading the view.
}

- (void)setTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = false;
    [self.view addSubview:_tableView];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"tableNameCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = _tableNames[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DatabaseContentViewController *contentController = [[DatabaseContentViewController alloc] initWithDBOperation:self.dbOperation tableName:_tableNames[indexPath.row]];
    [self.navigationController pushViewController:contentController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
