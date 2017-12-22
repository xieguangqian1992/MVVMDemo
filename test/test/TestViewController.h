//
//  TestViewController.h
//  test
//
//  Created by wen xie on 2017/12/21.
//  Copyright © 2017年 wen xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveCocoa.h"

@interface TestViewController : UIViewController

@property (nonatomic, strong) RACSubject *signal;

@end
