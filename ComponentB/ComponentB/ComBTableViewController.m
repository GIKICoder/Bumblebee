//
//  ComBTableViewController.m
//  ComponentB
//
//  Created by GIKI on 2017/3/10.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "ComBTableViewController.h"
#import "Bumblebee.h"

@interface ComBTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView  *tableView;

@end

@implementation ComBTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:({
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView;
    })];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
}

#pragma mark - tableView Delegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [Bumblebee createBumblebeeEntrance:@"ComAEntrance"];
    static NSString *cellID = @"tableViewCellID";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
       
        BeeRequest * request = [BeeRequestFactory BeeInvokeSynRequest:@"ComAEntrance"];
        request.parameter = @{@"reuseIdentifier":cellID,@"cellStyle":@(UITableViewCellStyleDefault)};
        request.actionName = @"getComATableViewCell";
        cell = [Bumblebee invokeSynRequestWithPramas:request].responseData;
        
    }
    
    BeeRequest *requestConfig = [BeeRequestFactory BeeInvokeSynRequest:@"ComAEntrance"];
    requestConfig.parameter = @{@"label":@"我是ComA的cell",@"subLabel":@"但是我的值从ComB传过来",@"Cell":cell};
    requestConfig.actionName = @"configComATableViewCell";
    [Bumblebee invokeSynRequestWithPramas:requestConfig];
    
    return cell;
}



@end
