 //
//  BeeTabBarController.m
//  BumblebeeDemo
//
//  Created by GIKI on 17/1/12.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "BeeTabBarController.h"

#import "ViewController.h"
@interface BeeTabBarController ()<UITabBarControllerDelegate>

@end

@implementation BeeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    NSArray *controllerProperties = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"controllers.plist" ofType:nil]];
    NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:controllerProperties.count];
    for (NSDictionary *dicData in controllerProperties) {
        NSString * string = dicData[@"controller"];
        Class cls = NSClassFromString(string);
        UIViewController *viewController = [cls new];
        NSString * title =dicData[@"title"];
        viewController.title = title;
        NSString * image = dicData[@"tab_icon"];
        NSString * selectimage =dicData[@"tab_icon_sl"];
        viewController.tabBarItem.image = [UIImage imageNamed:image];
        viewController.tabBarItem.selectedImage = [UIImage imageNamed:selectimage];
        [controllers addObject:viewController];
    }
    self.delegate = self;
    self.viewControllers = [controllers copy];
    [self syncNavgationItemsFromViewController:controllers.firstObject];
}


- (void)loadRootViewController
{
    ViewController * v1 = [[ViewController alloc] init];
    ViewController * v2 = [[ViewController alloc] init];
    v1.title = @"ComA";
    v1.tabBarItem.image = [UIImage imageNamed:@"tab1_chat_off"];
    v1.tabBarItem.selectedImage = [UIImage imageNamed:@"tab1_chat_on"];
    v2.title = @"ComB";
    v2.tabBarItem.image = [UIImage imageNamed:@"tab2_work_off"];
    v2.tabBarItem.selectedImage = [UIImage imageNamed:@"tab2_work_on"];

     self.delegate = self;
    self.viewControllers = @[v1,v2];
     [self syncNavgationItemsFromViewController:v1];
}


#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self syncNavgationItemsFromViewController:viewController];
}

/** Sync TabBar's NavigationItem */
- (void)syncNavgationItemsFromViewController:(UIViewController *)viewController {
    self.navigationItem.leftBarButtonItem = viewController.navigationItem.leftBarButtonItem;
    self.navigationItem.leftBarButtonItems = viewController.navigationItem.leftBarButtonItems;
    self.navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItems = viewController.navigationItem.rightBarButtonItems;
    self.navigationItem.titleView = viewController.navigationItem.titleView;
    self.navigationItem.title = viewController.navigationItem.title;
}
@end
