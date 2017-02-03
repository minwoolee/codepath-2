//
//  TWNavigationManager.h
//  Twtr
//
//  Created by Min Lee on 2/1/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TWUser.h"

@interface TWNavigationManager : NSObject

+ (TWNavigationManager *)sharedInstance;

- (void)logOut;
- (void)logIn:(TWUser *)user;

- (void)setRootViewController;

- (UIViewController *)profileViewControllerForUser:(TWUser *)user;
- (UIViewController *)tweetsListViewControllerForUser:(TWUser *)user;
- (UIViewController *)usersListViewControllerFollowingUser:(TWUser *)user;
- (UIViewController *)usersListViewControllerFollowedByUser:(TWUser *)user;

@property (strong, nonatomic) UIWindow *window;

@end
