//
//  TWTwitterClient.m
//  Twtr
//
//  Created by Min Lee on 1/30/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import "TWTwitterClient.h"

@interface TWTwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(TWUser *user, NSError *error);

@end

@implementation TWTwitterClient

static NSString * const kTwitterConsumerKey = @"1Yk9nv4nT32DbEaaitcyASTWz";
static NSString * const kTwitterConsumerSecret = @"WBVOsDTwri1Iowu8koDk0yOEyEZB5VUBvoRpBW3Dzxw0xdbhKx";
static NSString * const kTwitterBaseURL = @"https://api.twitter.com";

+ (TWTwitterClient *)sharedInstance;
{
    static TWTwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TWTwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseURL]
                                                    consumerKey:kTwitterConsumerKey
                                                 consumerSecret:kTwitterConsumerSecret];
        }});
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(TWUser *user, NSError *error))completion;
{
    self.loginCompletion = completion;

    // clear "state" first
    [self.requestSerializer removeAccessToken];
    
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"twtr://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"Got request token: %@", requestToken);
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        
        [[UIApplication sharedApplication] openURL:authURL options:@{} completionHandler:nil];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get request token with error: %@", error);
        if (self.loginCompletion) {
            self.loginCompletion(nil, error);
        }
    }];
}

- (void)handleApplicationOpenUrl:(NSURL *)url;
{
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"Got the access token: %@", accessToken);
        
        [self.requestSerializer saveAccessToken:accessToken];

        [self GET:@"1.1/account/verify_credentials.json" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            // show progress
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            TWUser *currentUser = [[TWUser alloc] initWithDictionary:responseObject];
            if (self.loginCompletion) {
                self.loginCompletion(currentUser, nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Faile to get current user with error: %@", error);
            if (self.loginCompletion) {
                self.loginCompletion(nil, error);
            }
        }];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get access token with error: %@", error);
        if (self.loginCompletion) {
            self.loginCompletion(nil, error);
        }
    }];
}

- (void)timelineApi:(NSString *)api WithCompletion:(void (^)(NSArray<TWTweet *> *tweets, NSError *error))completion;
{
    [self GET:api parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        // show progress
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion([TWTweet tweetsWithArray:responseObject], nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"timelineWithCompletion failed with error: %@", error);
        completion(nil, error);
    }];
}

- (void)statusForId:(NSString *)statusId withCompletion:(void (^)(NSDictionary *dictionary, NSError *error))completion;
{
    [self GET:[NSString stringWithFormat:@"1.1/statuses/show/%@.json", statusId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        // show progress
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"timelineWithCompletion failed with error: %@", error);
        completion(nil, error);
    }];
}

- (void)favoriteTweetWithId:(NSString *)tweetId withCompletion:(void (^)(NSDictionary *dictionary, NSError *error))completion;
{
    NSString *api = [NSString stringWithFormat:@"1.1/favorites/create.json?id=%@", tweetId];
    [self tweetActionWith:api withCompletion:completion];
}

- (void)unfavoriteTweetWithId:(NSString *)tweetId withCompletion:(void (^)(NSDictionary *dictionary, NSError *error))completion;
{
    NSString *api = [NSString stringWithFormat:@"1.1/favorites/destroy.json?id=%@", tweetId];
    [self tweetActionWith:api withCompletion:completion];
}

- (void)retweetTweetWithId:(NSString *)tweetId withCompletion:(void (^)(NSDictionary *dictionary, NSError *error))completion;
{
    NSString *api = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId];
    [self tweetActionWith:api withCompletion:completion];
}

- (void)unretweetTweetWithId:(NSString *)tweetId withCompletion:(void (^)(NSDictionary *dictionary, NSError *error))completion;
{
    NSString *api = [NSString stringWithFormat:@"1.1/statuses/unretweet/%@.json", tweetId];
    [self tweetActionWith:api withCompletion:completion];
}

- (void)tweetActionWith:(NSString *)api withCompletion:(void (^)(NSDictionary *dictionary, NSError *error))completion;
{
    [self POST:api parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Tweet action failed with error: %@", error);
        completion(nil, error);
    }];
}

@end
