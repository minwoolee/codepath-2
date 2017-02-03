//
//  TWtweet.h
//  Twtr
//
//  Created by Min Lee on 1/30/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWUser.h"

@interface TWTweet : NSObject

@property (nonatomic, strong, readonly) NSString *tweetId;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSString *retweetedBy;
@property (nonatomic, strong, readonly) TWUser *user;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic, strong, readonly) NSNumber *retweetCount;
@property (nonatomic, strong, readonly) NSNumber *favoritesCount;
@property (nonatomic, assign, readonly) BOOL favorited;
@property (nonatomic, assign, readonly) BOOL retweeted;

- (id)initWithDictionary:(NSDictionary *)dictionary;

// tweet actions
//
- (void)toggleFavorithWithCompletion:(void (^)(NSDictionary *dictionary, NSError *error))completion;
- (void)toggleRetweetWithCompletion:(void (^)(NSDictionary *dictionary, NSError *error))completion;

+ (NSArray<TWTweet*> *)tweetsWithArray:(NSArray<NSDictionary *> *)array;

@end
