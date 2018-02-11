//
//  ComAViewController.m
//  ComponentA
//
//  Created by GIKI on 17/1/12.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "ComAViewController.h"
#import "Bumblebee.h"
#import "UIColor+YYAdd.h"

@interface ComAViewController ()

@end

@implementation ComAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColorHex(fafa99);
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 100, 50)];
    [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor= [UIColor redColor];
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    UILabel * label = [UILabel new];
    label.frame = CGRectMake( 150, 100, 200, 50);
    label.text = @"ComAViewController";
    label.textColor = [UIColor redColor];
    [self.view addSubview:label];
    
    UIButton * btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 200, 50)];
    [btn1 addTarget:self action:@selector(btnclick1:) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor= [UIColor redColor];
    [btn1 setTitle:@"获取信息" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)btnclick
{
    [Bumblebee createBumblebeeEntrance:@"ComBEntrance"];
    BeeRequest * request = [BeeRequestFactory BeeOpenTargetRequest:@"ComBEntrance"];
    request.actionName = @"pushToVC";
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"nav"] = self.navigationController;
    request.parameter = dict.copy;
    [Bumblebee openTargetWithPramas:request resultBlock:^(BeeResponse *info) {
        
    }];
}

- (void)btnclick1:(UIButton *)btn
{
    [Bumblebee createBumblebeeEntrance:@"ComBEntrance"];
    BeeRequest * request = [BeeRequestFactory BeeInvokeASynRequest:@"ComBEntrance"];
    request.actionName = @"getComBInfo";
    [Bumblebee invokeAsynRequestWithPramas:request resultBlock:^(BeeResponse *info) {
         [btn setTitle:info.responseData forState:UIControlStateNormal];
    }];
    
}

@end
