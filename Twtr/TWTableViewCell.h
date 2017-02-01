//
//  TWTableViewCell.h
//  Twtr
//
//  Created by Min Lee on 1/30/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWTweet.h"

@interface TWTableViewCell : UITableViewCell

@property (strong, nonatomic) TWTweet *tweet;

@end
