//
//  TestMainView.h
//  test
//
//  Created by wen xie on 2017/12/21.
//  Copyright © 2017年 wen xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestMainViewModel.h"

@interface TestMainView : UIView

@property (nonatomic, strong) TestMainViewModel *viewModel;

-(instancetype) initWithViewModel:(TestMainViewModel *)viewModel;

@end
