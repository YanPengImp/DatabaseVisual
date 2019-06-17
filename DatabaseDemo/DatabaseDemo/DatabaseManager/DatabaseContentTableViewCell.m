//
//  DatabaseContentTableViewCell.m
//  DQGuess
//
//  Created by Imp on 2018/11/8.
//  Copyright © 2018 jingbo. All rights reserved.
//

#import "DatabaseContentTableViewCell.h"

@interface DatabaseContentTableViewCell ()

@property (nonatomic, strong) NSArray <UILabel *>*labels;

@end

@implementation DatabaseContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.labels = [NSArray array];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat labelWidth  = self.contentView.frame.size.width / _labels.count;
    CGFloat labelHeight = self.contentView.frame.size.height;
    for (NSInteger i = 0; i < _labels.count; i++) {
        UILabel *label = _labels[i];
        label.frame = CGRectMake(labelWidth * i + 5, 0, (labelWidth - 10), labelHeight);
    }
}

- (void)loadContents:(NSArray *)contents {
    if (contents.count != _labels.count) {
        for (UIView *label in self.contentView.subviews) {
            if ([label isKindOfClass:[UILabel class]]) {
                [label removeFromSuperview];
            }
        }
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 0; i < contents.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.userInteractionEnabled = YES;
            label.tag = 10000 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabelAction:)];
            [label addGestureRecognizer:tap];
            [self.contentView addSubview:label];
            [array addObject:label];
        }
        self.labels = array;
    }
    for (NSInteger i = 0; i < contents.count; i++) {
        self.labels[i].text = contents[i];
    }
}

- (void)tapLabelAction:(UITapGestureRecognizer *)gesture {
    UILabel *label = (UILabel *)gesture.view;
    if (self.clickLabel) {
        self.clickLabel(label, label.tag - 10000);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
