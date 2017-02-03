//
//  TWComposeViewController.h
//  Twtr
//
//  Created by Min Lee on 1/31/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWUser.h"
#import "TWTweet.h"

@interface TWComposeViewController : UIViewController

@property (nonatomic, strong) TWTweet *replyingToTweet;
@property (nonatomic, strong) TWUser *replyingToUser;

@end
