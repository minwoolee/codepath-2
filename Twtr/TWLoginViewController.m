//
//  TWLoginViewController.m
//  Twtr
//
//  Created by Min Lee on 1/30/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import "TWLoginViewController.h"
#import "TWTwitterClient.h"
#import "TWNavigationManager.h"

@interface TWLoginViewController ()

@end

@implementation TWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender;
{
    [[TWTwitterClient sharedInstance] loginWithCompletion:^(TWUser *user, NSError *error) {
        if (error) {
            NSLog(@"Failed to login with error: %@", error);
        } else {
            // do main app stuff
            NSLog(@"Logged in as user: %@", user);
            [[TWNavigationManager sharedInstance] logIn:user];
        }
    }];
}

@end
