//
//  TestTableViewCell.m
//  test
//
//  Created by wen xie on 2017/12/21.
//  Copyright © 2017年 wen xie. All rights reserved.
//

#import "TestTableViewCell.h"
#import "masonry.h"

@interface TestTableViewCell()

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UIView *bottomView;

@end


@implementation TestTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self configView];
    }
    return self;
}


-(void) setViewModel:(TestTableViewCellModel *)viewModel
{
    _viewModel = viewModel;
    self.title.text = viewModel.title;
}

-(void) configView
{
    _title = [[UILabel alloc] init];
    _title.font = [UIFont systemFontOfSize:15];
    _title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_title];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor blueColor];
    [self addSubview:_bottomView];
    
    
    __weak typeof(self) weakSelf = self;
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(12);
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-12);
        make.height.mas_equalTo(@(1));
        make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(-1);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
