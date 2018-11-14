//
//  DatabaseContentModifyViewController.m
//  DQGuess
//
//  Created by Imp on 2018/11/13.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import "DatabaseContentModifyViewController.h"

@interface DatabaseContentModifyViewController ()

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) GridIndex index;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation DatabaseContentModifyViewController

- (instancetype)initWithContent:(NSString *)content gridIndex:(GridIndex)gridIndex{
    if (self = [super init]) {
        self.content = [content copy];
        self.index = gridIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initCommonUI];
    [self initTextView];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGFloat width = UIScreen.mainScreen.bounds.size.width - 24;
    self.textView.frame = CGRectMake(12, 0, width, 200);
}

- (void)initTextView {
    self.textView = [[UITextView alloc] init];
    self.textView.text = _content;
    self.textView.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    [self.view addSubview:self.textView];
}

- (void)initCommonUI {
    self.title = @"modify";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"set" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemDidClickAction)]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEmptySpaceAction)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
}

- (void)rightBarButtonItemDidClickAction {
    [_textView resignFirstResponder];
    NSLog(@"modify textView text = %@",_textView.text);
    if (_delegate && [_delegate respondsToSelector:@selector(modifyViewControllerDidModifyContent:withGridIndex:)]) {
        [_delegate modifyViewControllerDidModifyContent:_textView.text withGridIndex:_index];
    }
    [self.navigationController popViewControllerAnimated:true];
}

- (void)tapEmptySpaceAction {
    [_textView resignFirstResponder];
}

@end
