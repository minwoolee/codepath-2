//
//  TWtweet.m
//  Twtr
//
//  Created by Min Lee on 1/30/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import "TWTweet.h"
#import "TWTwitterClient.h"

@interface TWTweet()

@property (nonatomic, strong) NSDictionary *dictionary;

@property (nonatomic, strong, readwrite) NSString *tweetId;
@property (nonatomic, strong, readwrite) NSString *text;
@property (nonatomic, strong, readwrite) NSString *retweetedBy;
@property (nonatomic, strong, readwrite) TWUser *user;
@property (nonatomic, strong, readwrite) NSDate *createdAt;
@property (nonatomic, strong, readwrite) NSNumber *retweetCount;
@property (nonatomic, strong, readwrite) NSNumber *favoritesCount;
@property (nonatomic, assign, readwrite) BOOL favorited;
@property (nonatomic, assign, readwrite) BOOL retweeted;

@end

@implementation TWTweet

static NSString *const kIdKey = @"id_str";
static NSString *const kTextKey = @"text";
static NSString *const kUserKey = @"user";
static NSString *const kCreateAtKey = @"created_at";
static NSString *const kRetweetCountKey = @"retweet_count";
static NSString *const kFavoritesCountKey = @"favorite_count";
static NSString *const kRetweetedByKey = @"retweeted_status.user.screen_name";
static NSString *const kFavoritedKey = @"favorited";
static NSString *const kRetweetedKey = @"retweeted";

- (id)initWithDictionary:(NSDictionary *)dictionary;
{
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.tweetId = dictionary[kIdKey];
        self.text = dictionary[kTextKey];
        self.user = [[TWUser alloc] initWithDictionary:dictionary[kUserKey]];
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:dictionary[kCreateAtKey]];
        self.retweetCount = dictionary[kRetweetCountKey];
        self.favoritesCount = dictionary[kFavoritesCountKey];
        self.retweetedBy = [dictionary valueForKeyPath:kRetweetedByKey];
        self.favorited = [dictionary[kFavoritedKey] integerValue] > 0;
        self.retweeted = [dictionary[kRetweetedKey] integerValue] > 0;
    }
    return self;
}

- (void)toggleFavorithWithCompletion:(void (^)(NSDictionary *dictionary, NSError *error))completion;
{
    if (self.favorited) {
        [[TWTwitterClient sharedInstance] unfavoriteTweetWithId:self.tweetId withCompletion:^(NSDictionary *dictionary, NSError *error) {
            if (!error) {
                self.favorited = NO;
            }
            completion(dictionary, error);
        }];
    } else {
        [[TWTwitterClient sharedInstance] favoriteTweetWithId:self.tweetId withCompletion:^(NSDictionary *dictionary, NSError *error) {
            if (!error) {
                self.favorited = YES;
            }
            completion(dictionary, error);
        }];
    }
}

- (void)toggleRetweetWithCompletion:(void (^)(NSDictionary *dictionary, NSError *error))completion;
{
    if (self.retweeted) {
        [[TWTwitterClient sharedInstance] unretweetTweetWithId:self.tweetId withCompletion:^(NSDictionary *dictionary, NSError *error) {
            if (!error) {
                self.retweeted = NO;
            }
            completion(dictionary, error);
        }];
    } else {
        [[TWTwitterClient sharedInstance] retweetTweetWithId:self.tweetId withCompletion:^(NSDictionary *dictionary, NSError *error) {
            if (!error) {
                self.retweeted = YES;
            }
            completion(dictionary, error);
        }];
    }
}

+ (NSArray<TWTweet*> *)tweetsWithArray:(NSArray<NSDictionary *> *)array;
{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        TWTweet *tweet = [[TWTweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@: %p %@>", [self class], self, @{@"user": self.user, @"text": self.text, @"createdAt": self.createdAt}];
}

@end
