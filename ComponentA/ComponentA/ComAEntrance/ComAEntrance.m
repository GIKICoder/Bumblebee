//
//  ComAEntrance.m
//  ComponentA
//
//  Created by GIKI on 17/1/12.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "ComAEntrance.h"
#import "ComAViewController.h"
#import "ComATableViewCell.h"
#import "ComADelegateController.h"
@implementation ComAEntrance

- (BeeResponse*)getComAInfo
{
    BeeResponse * response = [[BeeResponse alloc] init];
    response.responseData = @"ComAInfo";
    return response;
}


- (void)pushToVC
{
    ComADelegateController * vc = [[ComADelegateController alloc] init];
    UINavigationController * nav = self.request.parameter[@"nav"];
    UIViewController *preVc = self.request.parameter[@"preVc"];
    vc.preVc = preVc;
    [nav pushViewController:vc animated:YES];
}

- (BeeResponse *)getComATableViewCell
{
    NSDictionary * dict =  self.request.parameter;
    if (dict) {
        NSString * reuseIdentifier = dict[@"reuseIdentifier"];
        UITableViewCellStyle style = [dict[@"cellStyle"] integerValue];
        ComATableViewCell * cell = [[ComATableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
        BeeResponse * response = [[BeeResponse alloc] init];
        response.responseData = cell;
        return response;
    }
    return nil;
    
}

- (void)configComATableViewCell
{
    NSDictionary * dict =  self.request.parameter;
    if (dict) {
         NSString * label = dict[@"label"];
         NSString * subLabel = dict[@"subLabel"];
         ComATableViewCell *cell = dict[@"Cell"];
        
        [cell configCellWithLabelText:label subLabelText:subLabel];
    }
}

@end
