//
//  TWNavigationController.m
//  Twtr
//
//  Created by Min Lee on 1/31/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import "TWNavigationController.h"
#import "TWListViewController.h"
#import "TWLoginViewController.h"

@interface TWNavigationController ()

@end

@implementation TWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     
    TWListViewController *twListViewController = [TWListViewController new];
    [self pushViewController:twListViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
