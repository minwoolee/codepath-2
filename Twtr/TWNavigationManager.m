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
#import "TWProfileViewController.h"

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
    TWListViewController *timelineViewController = [TWListViewController new];
    timelineViewController.api = @"1.1/statuses/home_timeline.json";
    [tab1VC pushViewController:timelineViewController animated:YES];
    tab1VC.tabBarItem.title = @"Timeline";
    tab1VC.tabBarItem.image = [UIImage imageNamed:@"home-icon"];

    UINavigationController *tab2VC = [UINavigationController new];
    TWListViewController *mentionsViewController = [TWListViewController new];
    mentionsViewController.api = @"1.1/statuses/mentions_timeline.json";
    [tab2VC pushViewController:mentionsViewController animated:YES];
    tab2VC.tabBarItem.title = @"Mentions";
    tab2VC.tabBarItem.image = [UIImage imageNamed:@"stat-icon"];

    UINavigationController *tab3VC = [UINavigationController new];
    TWProfileViewController *twProfileViewController = [TWProfileViewController new];
    twProfileViewController.user = TWUser.currentUser;
    [tab3VC pushViewController:twProfileViewController animated:YES];
    tab3VC.tabBarItem.title = @"Profile";
    tab3VC.tabBarItem.image = [UIImage imageNamed:@"profile-icon"];

    // Set up the Tab Bar Controller to have two tabsr
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[tab1VC, tab2VC, tab3VC]];

    return tabBarController;
}

- (UIViewController *)loggedOutRootViewController;
{
    return [TWLoginViewController new];
}

- (UIViewController *)tweetsListViewControllerFor:(TWUser *)user;
{
    TWListViewController *tweetsViewController = [TWListViewController new];
    tweetsViewController.api = [NSString stringWithFormat:@"1.1/statuses/user_timeline.json?screen_name=%@", user.screenName];
    return tweetsViewController;
}

@end
