//
//  BeeNavigationController.m
//  BumblebeeDemo
//
//  Created by GIKI on 17/1/12.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "BeeNavigationController.h"

@interface BeeNavigationController ()

@end

@implementation BeeNavigationController

+ (void)initialize {
    /*--- CONFIGURE THE VARIETY BAR'S PROPERTIES ---*/
     UINavigationBar *navBar = [UINavigationBar appearance];
     [navBar setBarTintColor:[UIColor grayColor]];
     [navBar setTintColor:[UIColor whiteColor]];
     [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
     
     UIBarButtonItem *barButtonItem = [UIBarButtonItem appearanceWhenContainedIn:[BeeNavigationController class], nil];
     [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
     
     [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]} forState:UIControlStateDisabled];

}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    /*
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
     */
    [super pushViewController:viewController animated:animated];
}

- (void)backAction {
    [self popViewControllerAnimated:YES];
}



@end
