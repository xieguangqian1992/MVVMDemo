//
//  TestMainViewModel.m
//  test
//
//  Created by wen xie on 2017/12/21.
//  Copyright © 2017年 wen xie. All rights reserved.
//

#import "TestMainViewModel.h"
#import "SVProgressHUD.h"
#import "TestTableViewCellModel.h"



@interface TestMainViewModel()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation TestMainViewModel

-(instancetype) init
{
    self = [super init];
    if(self){
        [self fetchData];
    }
    return self;
}


-(void) fetchData
{
    @weakify(self);
    [self.refreshDataCommend.executionSignals.switchToLatest subscribeNext:^(NSArray *x) {
        @strongify(self);
        
        NSMutableArray *arr = [NSMutableArray new];
        for(NSInteger i = 0; i < x.count; i++){
            TestTableViewCellModel *cellModel = [[TestTableViewCellModel alloc] init];
            cellModel.title = x[i];
            [arr addObject:cellModel];
        }
        self.dataArray = [[NSMutableArray alloc] initWithArray:arr];
        [self.refreshEndSubject sendNext:@"HasMoreData"];

        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
    
    [[[self.refreshDataCommend.executing skip:1] take:1] subscribeNext:^(id x) {
        if([x isEqualToNumber:@(YES)]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeGradient];
            });
        }
    }];
    
    [[self.nextDataCommend.executionSignals switchToLatest] subscribeNext:^(NSArray *array) {
        @strongify(self);
        
        NSMutableArray *arr = [NSMutableArray new];
        for(NSInteger i = 0; i < array.count; i++){
            TestTableViewCellModel *cellModel = [[TestTableViewCellModel alloc] init];
            cellModel.title = array[i];
            [arr addObject:cellModel];
        }
        [self.dataArray addObjectsFromArray:arr];
        [self.refreshEndSubject sendNext:@"HasMoreData"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}


-(RACCommand *) refreshDataCommend
{
    if(!_refreshDataCommend){
        
        @weakify(self);
        _refreshDataCommend = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.currentPage = 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD show];
            });
            
           return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
               //模拟网络请求返回数据
               sleep(5);
               [subscriber sendNext:@[@"111",@"222",@"333"]];
               [subscriber sendCompleted];
               return nil;
            }];
            return nil;
        }];
    }
    return _refreshDataCommend;
}

-(RACCommand *) nextDataCommend
{
    if(!_nextDataCommend){
        _nextDataCommend = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
           
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
               
                self.currentPage ++;
                sleep(2);
                [subscriber sendNext:@[@"的嘎",@"从VB现场v",@"浩特研究院"]];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _nextDataCommend;
}

-(RACSubject *) refreshEndSubject
{
    if(!_refreshEndSubject){
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

-(RACSubject *) refreshUI
{
    if(!_refreshUI){
        _refreshUI = [RACSubject subject];
    }
    return _refreshUI;
}

-(RACSubject *) cellClickSubject
{
    if(!_cellClickSubject){
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}

@end
