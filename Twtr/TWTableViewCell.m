//
//  TWTableViewCell.m
//  Twtr
//
//  Created by Min Lee on 1/30/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import "TWTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface TWTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UIView *topContainerView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContainerHeightConstraint;

@end

@implementation TWTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTweet:(TWTweet *)tweet;
{
    _tweet = tweet;

    self.nameLabel.text = tweet.user.name;
    self.handleLabel.text = [NSString stringWithFormat: @"@%@", tweet.user.screenName];
    self.timestampLabel.text = [NSDateFormatter localizedStringFromDate:tweet.createdAt
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterShortStyle];
    self.contentLabel.text = tweet.text;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrlString]];
    if (tweet.retweetCount == nil || [tweet.retweetCount intValue] == 0) {
        self.topContainerView.hidden = YES;
        self.topContainerHeightConstraint.constant = 0;
        [self setNeedsUpdateConstraints];
    } else {
        self.retweetCountLabel.text = [tweet.retweetCount stringValue];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
