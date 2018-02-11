//
//  ComBViewController.m
//  ComponentB
//
//  Created by GIKI on 17/1/12.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "ComBViewController.h"
#import "Bumblebee.h"
#import "UIColor+YYAdd.h"

@interface ComBViewController ()

{
    UILabel * label;
}
@end

@implementation ComBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColorHex(f2f2f2);
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 100, 50)];
    [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor= [UIColor redColor];
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    label = [UILabel new];
    label.frame = CGRectMake( 150, 100, 200, 50);
    label.text = @"ComBViewController";
    label.textColor = [UIColor redColor];
    [self.view addSubview:label];
    
    UIButton * btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 200, 50)];
    [btn1 addTarget:self action:@selector(btnclick1:) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor= [UIColor redColor];
    [btn1 setTitle:@"获取信息" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
}


- (void)setButtonText:(NSString *)buttonText
{
    label.text = buttonText;
}


- (void)btnclick
{
    [Bumblebee createBumblebeeEntrance:@"ComAEntrance"];
    BeeRequest * request = [BeeRequestFactory BeeOpenTargetRequest:@"ComAEntrance"];
    request.actionName = @"pushToVC";
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"nav"] = self.navigationController;
    dict[@"preVc"] =  self;
    request.parameter = dict.copy;
    [Bumblebee openTargetWithPramas:request resultBlock:^(BeeResponse *info) {
        
    }];
}

- (void)btnclick1:(UIButton *)btn
{
    [Bumblebee createBumblebeeEntrance:@"ComAEntrance"];
    BeeRequest * request = [BeeRequestFactory BeeInvokeSynRequest:@"ComAEntrance"];
    request.actionName = @"getComAInfo";
    NSString *info = [Bumblebee invokeSynRequestWithPramas:request].responseData;
    [btn setTitle:info forState:UIControlStateNormal];

}


@end
