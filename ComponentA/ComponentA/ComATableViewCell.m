//
//  ComATableViewCell.m
//  ComponentA
//
//  Created by GIKI on 2017/3/10.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "ComATableViewCell.h"

@implementation ComATableViewCell
{
    UILabel * _label;
    UILabel * _subLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:({
            _label = [[UILabel alloc] init];
            _label.text = @"这是ComACell";
            _label;
        })];
        
        [self.contentView addSubview:({
            _subLabel = [[UILabel alloc] init];
            _subLabel;
        })];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _label.frame = CGRectMake(6, 0, self.frame.size.width, self.frame.size.height * 0.5);
    _subLabel.frame = CGRectMake(6, self.frame.size.height * 0.5, self.frame.size.width, self.frame.size.height * 0.5);
}

- (void)configCellWithLabelText:(NSString*)label subLabelText:(NSString*)subLabel
{
    _label.text = label;
    _subLabel.text = subLabel;
}
@end
