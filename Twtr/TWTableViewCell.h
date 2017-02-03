//
//  TWTableViewCell.h
//  Twtr
//
//  Created by Min Lee on 1/30/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWTweet.h"

@protocol TWReplyHandlerDelegate <NSObject>

- (void)handleReplyToTweetId:(NSString *)tweetId;

@end

@interface TWTableViewCell : UITableViewCell

@property (strong, nonatomic) TWTweet *tweet;
@property (strong, nonatomic) id<TWReplyHandlerDelegate> delegate;

@end

