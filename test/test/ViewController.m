//
//  ViewController.m
//  test
//
//  Created by wen xie on 2017/12/20.
//  Copyright © 2017年 wen xie. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "TestViewController.h"
#import "masonry.h"
#import "TestMainView.h"
#import "TestMainViewModel.h"




@interface ViewController ()

@property (nonatomic, strong) TestMainView *mainView;
@property (nonatomic, strong) TestMainViewModel *mainViewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configView];
    [self blindViewModel];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) blindViewModel
{
    @weakify(self);
    [[self.mainViewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self);
        TestViewController *vc = [[TestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}


-(TestMainViewModel *) mainViewModel
{
    if(!_mainViewModel){
        _mainViewModel = [[TestMainViewModel alloc] init];
    }
    return _mainViewModel;
}

-(void) configView
{
    _mainView = [[TestMainView alloc] initWithViewModel:self.mainViewModel];
    [self.view addSubview:_mainView];
    @weakify(self);
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
