//
//  ViewController.m
//  BumblebeeDemo
//
//  Created by GIKI on 17/1/12.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 100, 50)];
    [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor= [UIColor redColor];
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnclick
{
    /*
    [ComPlatformManager createComEntity:@"ComA"];
    ComRequest * request = [ComRequestFactory newComDispatchRequest:@"ComA"];
    request.actionName = @"pushToVC";
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"nav"] = self.navigationController;
    request.parameter = dict.copy;
    [ComPlatformManager dispatch:request result:^(ComResponse *info) {
        
    }];
     */
}

@end
