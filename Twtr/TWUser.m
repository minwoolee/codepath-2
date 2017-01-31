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

@end

@implementation TWUser

static NSString *const kNameKey = @"name";
static NSString *const kScreenNameKey = @"screen_name";
static NSString *const kProfileImageUrlKey = @"profile_image_url";
static NSString *const kTaglineKey = @"description";

- (id)initWithDictionary:(NSDictionary *)dictionary;
{
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[kNameKey];
        self.screenName = dictionary[kScreenNameKey];
        self.profileImageUrlString = dictionary[kProfileImageUrlKey];
        self.tagline = dictionary[kTaglineKey];
    }
    return self;
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@: %p %@>", [self class], self, @{@"name": self.name, @"screenName": self.screenName}];
}

@end
