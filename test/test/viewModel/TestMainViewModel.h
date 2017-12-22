//
//  TestMainViewModel.h
//  test
//
//  Created by wen xie on 2017/12/21.
//  Copyright © 2017年 wen xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"

@interface TestMainViewModel : NSObject

@property (nonatomic, strong) RACSubject *refreshEndSubject;
@property (nonatomic, strong) RACSubject *refreshUI;
@property (nonatomic, strong) RACCommand *refreshDataCommend;
@property (nonatomic, strong) RACCommand *nextDataCommend;
@property (nonatomic, strong) RACSubject *cellClickSubject;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end
