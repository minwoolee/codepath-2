//
//  TWNavigationManager.m
//  Twtr
//
//  Created by Min Lee on 2/1/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import "TWNavigationManager.h"
#import "TWNavigationController.h"
#import "TWLoginViewController.h"

@interface TWNavigationManager()

@property (assign, nonatomic) BOOL isLoggedIn;

@end

@implementation TWNavigationManager

- (instancetype)init;
{
    self = [super init];
    if (self) {
        self.isLoggedIn = [TWUser getCurrentUser] != nil;
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
    self.window.rootViewController = (self.isLoggedIn)? [TWNavigationController new] : [TWLoginViewController new];
}

- (void)logOut;
{
    self.isLoggedIn = NO;
    [TWUser setCurrentUser:nil];
    [self setRootViewController];
}

- (void)logIn:(TWUser *)user;
{
    self.isLoggedIn = YES;
    [TWUser setCurrentUser:user];
    [self setRootViewController];
}

@end
