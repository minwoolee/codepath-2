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

@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) TWUser *user;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic, strong, readonly) NSNumber *retweetCount;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray<TWTweet*> *)tweetsWithArray:(NSArray<NSDictionary *> *)array;

@end
