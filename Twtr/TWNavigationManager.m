//
//  TWNavigationManager.m
//  Twtr
//
//  Created by Min Lee on 2/1/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import "TWNavigationManager.h"
#import "TWLoginViewController.h"
#import "TWTwitterClient.h"
#import "TWListViewController.h"

@interface TWNavigationManager()

@property (assign, nonatomic) BOOL isLoggedIn;

- (UIViewController *)loggedInRootViewController;
- (UIViewController *)loggedOutRootViewController;

@end

@implementation TWNavigationManager

- (instancetype)init;
{
    self = [super init];
    if (self) {
        self.isLoggedIn = TWUser.currentUser != nil;
    }
    return self;
}

+ (TWNavigationManager *)sharedInstance;
{
    static TWNavigationManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TWNavigationManager new];
    });
    return instance;
}

- (void)setRootViewController;
{
    self.window.rootViewController = (self.isLoggedIn)? [self loggedInRootViewController] : [self loggedOutRootViewController];
}

- (void)logOut;
{
    self.isLoggedIn = NO;
    [TWUser setCurrentUser:nil];
    [[TWTwitterClient sharedInstance].requestSerializer removeAccessToken];
    [self setRootViewController];
}

- (void)logIn:(TWUser *)user;
{
    self.isLoggedIn = YES;
    [TWUser setCurrentUser:user];
    [self setRootViewController];
}

- (UIViewController *)loggedInRootViewController;
{
    UINavigationController *tab1VC = [UINavigationController new];
    [tab1VC pushViewController:[TWListViewController new] animated:YES];
    tab1VC.tabBarItem.title = @"Timeline";
    UINavigationController *tab2VC = [UINavigationController new];
    [tab2VC pushViewController:[TWListViewController new] animated:YES];
    tab2VC.tabBarItem.title = @"Mentions";
    UINavigationController *tab3VC = [UINavigationController new];
    [tab3VC pushViewController:[TWListViewController new] animated:YES];
    tab3VC.tabBarItem.title = @"Profile";

    // Set up the Tab Bar Controller to have two tabsr
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[tab1VC, tab2VC, tab3VC]];

    return tabBarController;
}

- (UIViewController *)loggedOutRootViewController;
{
    return [TWLoginViewController new];
}

@end
