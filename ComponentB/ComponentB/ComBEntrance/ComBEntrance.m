//
//  ComBEntrance.m
//  ComponentB
//
//  Created by GIKI on 17/1/12.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "ComBEntrance.h"
#import "ComBViewController.h"
#import "ComBTableViewController.h"

@implementation ComBEntrance

- (void)getComBInfo
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      
        BeeResponse *response = [[BeeResponse alloc] init];
        response.status = kBeeMoudleResponseState_Success;
        response.responseData = @"asyn Method ";
        [self setResponse:response];
   
    });
    
}

- (void)pushToVC
{
    ComBTableViewController * vc = [[ComBTableViewController alloc] init];
    UINavigationController * nav = self.request.parameter[@"nav"];
    [nav pushViewController:vc animated:YES];
}

- (void)getComAdelegateData
{
    if (self.request.parameter) {
        NSString * text = self.request.parameter[@"Text"];
        ComBViewController *vc = self.request.parameter[@"VC"];
        vc.buttonText = text;
    }
}
@end
