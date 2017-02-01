//
//  TWtweet.m
//  Twtr
//
//  Created by Min Lee on 1/30/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import "TWTweet.h"

@interface TWTweet()

@property (nonatomic, strong) NSDictionary *dictionary;

@property (nonatomic, strong, readwrite) NSString *text;
@property (nonatomic, strong, readwrite) TWUser *user;
@property (nonatomic, strong, readwrite) NSDate *createdAt;
@property (nonatomic, strong, readwrite) NSNumber *retweetCount;

@end

@implementation TWTweet

static NSString *const kTextKey = @"text";
static NSString *const kUserKey = @"user";
static NSString *const kCreateAtKey = @"created_at";
static NSString *const kRetweetCountKey = @"retweet_count";

- (id)initWithDictionary:(NSDictionary *)dictionary;
{
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.text = dictionary[kTextKey];
        self.user = [[TWUser alloc] initWithDictionary:dictionary[kUserKey]];
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:dictionary[kCreateAtKey]];
        self.retweetCount = dictionary[kRetweetCountKey];
    }
    return self;
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
