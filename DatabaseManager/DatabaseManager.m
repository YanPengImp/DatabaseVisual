//
//  DatabaseManager.m
//  DQGuess
//
//  Created by Imp on 2018/11/5.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import "DatabaseManager.h"
#import "DatabaseListViewController.h"
#import "DatabaseFactory.h"

@interface DatabaseManager () <DatabaseListViewControllerDelegate>

@property (nonatomic, strong) UIWindow *showWindow;
@property (nonatomic, strong) DatabaseListViewController *viewController;

@end

@implementation DatabaseManager

+ (instancetype)sharedInstance {
    static DatabaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DatabaseManager alloc] init];
    });
    return sharedInstance;
}

- (UIWindow *)showWindow {
    if (_showWindow == nil) {
        _showWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _showWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
        _showWindow.windowLevel = UIWindowLevelStatusBar + 100;
    }
    return _showWindow;
}

- (DatabaseListViewController *)viewController {
    if (_viewController == nil) {
        _viewController = [[DatabaseListViewController alloc] initWithDBPaths:[DatabaseFactory queryIfHadDBFromDirectory:self.dbDocumentPath]];
        _viewController.delegate = self;
    }
    return _viewController;
}

- (void)showTables {
    self.showWindow.hidden = false;
    self.showWindow.transform = CGAffineTransformMakeTranslation(0, _showWindow.bounds.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.showWindow.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideTables {
    [UIView animateWithDuration:0.3 animations:^{
        self.showWindow.transform = CGAffineTransformMakeTranslation(0, self.showWindow.bounds.size.height);
    }completion:^(BOOL finished) {
        self.showWindow.hidden = true;
        self.showWindow = nil;
    }];
}

#pragma mark -- DatabaseListViewControllerDelegate

- (void)databaseListViewControllerDidFinish {
    [self hideTables];
}

@end
