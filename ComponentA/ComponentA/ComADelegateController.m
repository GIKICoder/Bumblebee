//
//  ComADelegateController.m
//  ComponentA
//
//  Created by GIKI on 2017/3/10.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "ComADelegateController.h"
#import "Bumblebee.h"

@interface ComADelegateController ()<UITextFieldDelegate>
{
    UITextField *_textField;
    UIButton *_button;
}
@end

@implementation ComADelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:({
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
         [_textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        _textField;
    })];
    
    [self.view addSubview:({
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundColor:[UIColor greenColor]];
        [_button setTitle:@"点击我带数据返回" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _button;
    })];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _textField.frame = CGRectMake(100, 100, 200,50);
    _button.frame = CGRectMake(100, 170, 200,50);
}

- (void)btnClick:(UIButton*)btn
{
    [Bumblebee createBumblebeeEntrance:@"ComBEntrance"];
    BeeRequest *req = [BeeRequestFactory BeeOpenTargetRequest:@"ComBEntrance"];
    req.parameter = @{@"Text":_textField.text, @"VC":self.preVc};
    req.actionName = @"getComAdelegateData";
    [Bumblebee openTargetWithPramas:req resultBlock:^(BeeResponse *info) {
        
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldEditChanged:(UITextField *)textField

{
    
    NSLog(@"textfield text %@",textField.text);
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
