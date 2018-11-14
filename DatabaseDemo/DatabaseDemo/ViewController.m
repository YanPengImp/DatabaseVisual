//
//  ViewController.m
//  DatabaseDemo
//
//  Created by Imp on 2018/11/14.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import "ViewController.h"
#import "DatabaseManager/DatabaseManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"摇一摇唤起database工具";
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
    // Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    //可放在判断debug模式下才启用
    [DatabaseManager sharedInstance].dbDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    [[DatabaseManager sharedInstance] showTables];
}

@end
