//
//  TestMainView.m
//  test
//
//  Created by wen xie on 2017/12/21.
//  Copyright © 2017年 wen xie. All rights reserved.
//

#import "TestMainView.h"
#import "TestTableHeaderView.h"
#import "MJRefresh.h"
#import "ReactiveCocoa.h"
#import "masonry.h"
#import "TestTableViewCell.h"




@interface TestMainView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TestTableHeaderView *headerView;

@end

@implementation TestMainView

-(instancetype) initWithViewModel:(TestMainViewModel *)viewModel
{
    self = [super init];
    if(self){
        self.viewModel = viewModel;
        [self configView];
        [self blindData];
    }
    return self;
}

-(void) blindData
{
    [self.viewModel.refreshDataCommend execute:nil];
    
    @weakify(self);
    [self.viewModel.refreshUI subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(NSString *x) {
        @strongify(self);
        [self.tableView reloadData];
        
        if([x isEqualToString:@"HasMoreData"]){
            [self.tableView.mj_header endRefreshing];
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                @strongify(self);
                [self.viewModel.nextDataCommend execute:nil];
            }];
        }else if([x isEqualToString:@"HasNoMoreData"]){
            [self.tableView.mj_header endRefreshing];
            self.tableView.mj_footer = nil;
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
    }];
}
#pragma mark --delegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.viewModel.dataArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusedIdentifier = @"cell";
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
    if(!cell){
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.viewModel = self.viewModel.dataArray[indexPath.row];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel.cellClickSubject sendNext:nil];
}

#pragma mark --UI

-(void) configView
{
    [self addSubview:self.tableView];
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

-(UITableView *) tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_tableView.tableHeaderView = self.headerView;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.viewModel.refreshDataCommend execute:nil];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self.viewModel.nextDataCommend execute:nil];
        }];
    }
    
    return _tableView;
}

-(TestTableHeaderView *) headerView
{
    if(!_headerView){
        
    }
    return _headerView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
