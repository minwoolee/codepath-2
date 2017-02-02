//
//  TWUser.h
//  Twtr
//
//  Created by Min Lee on 1/30/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWUser : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *screenName;
@property (nonatomic, strong, readonly) NSString *profileImageUrlString;
@property (nonatomic, strong, readonly) NSString *tagline;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (TWUser *)currentUser;
+ (void)setCurrentUser:(TWUser *)user;

@end
