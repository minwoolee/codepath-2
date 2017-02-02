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

@property (strong, nonatomic) UIWindow *window;

@end
