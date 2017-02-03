//
//  TWUser.m
//  Twtr
//
//  Created by Min Lee on 1/30/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import "TWUser.h"

@interface TWUser()

@property (nonatomic, strong) NSDictionary *dictionary;

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *screenName;
@property (nonatomic, strong, readwrite) NSString *profileImageUrlString;
@property (nonatomic, strong, readwrite) NSString *tagline;
@property (nonatomic, strong, readwrite) NSNumber *tweetCount;
@property (nonatomic, strong, readwrite) NSNumber *followingCount;
@property (nonatomic, strong, readwrite) NSNumber *followersCount;

@end

@implementation TWUser

static NSString *const kNameKey = @"name";
static NSString *const kScreenNameKey = @"screen_name";
static NSString *const kProfileImageUrlKey = @"profile_image_url";
static NSString *const kTaglineKey = @"description";
static NSString *const kTweetsCountKey = @"statuses_count";
static NSString *const kFollowingCountKey = @"friends_count";
static NSString *const kFollowersCountKey = @"followers_count";

static NSString *const kCurrentUserKey = @"currentUser";

- (id)initWithDictionary:(NSDictionary *)dictionary;
{
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[kNameKey];
        self.screenName = dictionary[kScreenNameKey];
        self.profileImageUrlString = dictionary[kProfileImageUrlKey];
        self.tagline = dictionary[kTaglineKey];
        self.tweetCount = dictionary[kTweetsCountKey];
        self.followersCount = dictionary[kFollowersCountKey];
        self.followingCount = dictionary[kFollowingCountKey];
    }
    return self;
}

+ (TWUser *)currentUser;
{
    TWUser *currentUser = nil;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (dictionary) {
        currentUser = [[TWUser alloc] initWithDictionary:dictionary];
    } else {
        NSLog(@"No current user set");
    }
    return currentUser;
}

+ (void)setCurrentUser:(TWUser *)user;
{
    // TODO: use keychain
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (user == nil) {
        [userDefaults removeObjectForKey:kCurrentUserKey];
    } else {
        NSDictionary *dictionary = user.dictionary;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
        [userDefaults setObject:data forKey:kCurrentUserKey];
    }
    [userDefaults synchronize];
}

+ (NSArray<TWUser*> *)usersWithArray:(NSArray<NSDictionary *> *)array;
{
    NSMutableArray *users = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        TWUser *user = [[TWUser alloc] initWithDictionary:dictionary];
        [users addObject:user];
    }
    return users;
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@: %p %@>", [self class], self, @{@"name": self.name, @"screenName": self.screenName}];
}

@end
