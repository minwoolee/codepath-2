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
#import "TWComposeViewController.h"

@interface TWNavigationManager()

@property (assign, nonatomic) BOOL isLoggedIn;
@property (strong, nonatomic) UIViewController *timelineViewController;

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
    // Timeline tab
    //
    UINavigationController *timelineTab = [UINavigationController new];
    TWListViewController *timelineViewController = [TWListViewController new];
    timelineViewController.navigationItem.title = @"Timeline";
    timelineViewController.api = @"1.1/statuses/home_timeline.json";
    [timelineTab pushViewController:timelineViewController animated:YES];
    timelineTab.tabBarItem.title = @"Timeline";
    timelineTab.tabBarItem.image = [UIImage imageNamed:@"home-icon"];

    
    UIBarButtonItem *newButton = [UIBarButtonItem new];
    newButton.target = self;
    newButton.action = @selector(handleCompose:);
    newButton.title = @"New";
    timelineViewController.navigationItem.rightBarButtonItem = newButton;
    
    UIBarButtonItem *signOutButton = [UIBarButtonItem new];
    signOutButton.target = self;
    signOutButton.action = @selector(handleSignOut:);
    signOutButton.title = @"Sign Out";
    timelineViewController.navigationItem.leftBarButtonItem = signOutButton;

    self.timelineViewController = timelineViewController;

    // Mentions tab
    //
    UINavigationController *mentionsTab = [UINavigationController new];
    TWListViewController *mentionsViewController = [TWListViewController new];
    mentionsViewController.navigationItem.title = @"Mentions";
    mentionsViewController.api = @"1.1/statuses/mentions_timeline.json";
    [mentionsTab pushViewController:mentionsViewController animated:YES];
    mentionsTab.tabBarItem.title = @"Mentions";
    mentionsTab.tabBarItem.image = [UIImage imageNamed:@"stat-icon"];

    // Profile tab
    //
    UINavigationController *profileTab = [UINavigationController new];
    TWProfileViewController *twProfileViewController = [TWProfileViewController new];
    twProfileViewController.user = TWUser.currentUser;
    [profileTab pushViewController:twProfileViewController animated:YES];
    profileTab.tabBarItem.title = @"Profile";
    profileTab.tabBarItem.image = [UIImage imageNamed:@"profile-icon"];

    // Set up the Tab Bar Controller to have two tabsr
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[timelineTab, mentionsTab, profileTab]];

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

- (void)handleCompose:(id)sender;
{
    [self.timelineViewController.navigationController pushViewController:[TWComposeViewController new] animated:YES];
}

- (void)handleSignOut:(id)sender;
{
    UIAlertController *confirmSignOut = [UIAlertController alertControllerWithTitle:@"Sign out?"
                                                                            message:nil
                                                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self logOut];
                                                     }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             // do nothing
                                                         }];
    
    [confirmSignOut addAction:okAction];
    [confirmSignOut addAction:cancelAction];
    [self.timelineViewController presentViewController:confirmSignOut animated:YES completion:nil];
}

@end
