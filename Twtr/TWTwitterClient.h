//
//  TWTwitterClient.h
//  Twtr
//
//  Created by Min Lee on 1/30/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>
#import "TWUser.h"

@interface TWTwitterClient : BDBOAuth1SessionManager

+ (TWTwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(TWUser *user, NSError *error))completion;

- (void)handleApplicationOpenUrl:(NSURL*)url;

@end
