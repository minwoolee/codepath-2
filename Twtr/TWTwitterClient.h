//
//  TWTwitterClient.h
//  Twtr
//
//  Created by Min Lee on 1/30/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>
#import "TWUser.h"
#import "TWTweet.h"

@interface TWTwitterClient : BDBOAuth1SessionManager

+ (TWTwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(TWUser *user, NSError *error))completion;

- (void)handleApplicationOpenUrl:(NSURL*)url;

- (void)timelineWithCompletion:(void (^)(NSArray<TWTweet *> *tweets, NSError *error))completion;

- (void)statusForId:(NSString *)statusId withCompletion:(void (^)(NSDictionary *dictionary, NSError *error))completion;

@end
