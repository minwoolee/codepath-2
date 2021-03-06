//
//  TWTableViewCell.h
//  Twtr
//
//  Created by Min Lee on 1/30/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWTweet.h"
#import "TWUser.h"

@protocol TWTableCellActionDelegate <NSObject>

- (void)handleReplyToTweet:(TWTweet *)tweet;
- (void)handleProfileViewForUser:(TWUser *)user;
- (void)handleRetweet:(TWTweet *)tweet;
- (void)handleFavorite:(TWTweet *)tweet;

@end

@interface TWTableViewCell : UITableViewCell

@property (strong, nonatomic) TWTweet *tweet;
@property (strong, nonatomic) id<TWTableCellActionDelegate> delegate;

@end

