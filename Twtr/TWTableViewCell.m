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
@property (weak, nonatomic) IBOutlet UILabel *retweetedByLabel;
@property (weak, nonatomic) IBOutlet UIView *topContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContainerHeightConstraint;

@end

@implementation TWTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // Adding UIGestureRecognizer programmatically because "nib must contain exactly one top level object" error
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnProfileImage:)];
    tap.cancelsTouchesInView = YES;
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.profileImageView addGestureRecognizer:tap];
    self.profileImageView.userInteractionEnabled = YES;
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
    if (tweet.retweetedBy == nil) {
        self.topContainerView.hidden = YES;
        self.topContainerHeightConstraint.constant = 0;
        [self setNeedsUpdateConstraints];
    } else {
        self.retweetedByLabel.text = tweet.retweetedBy;
    }
    
    self.favoriteButton.selected = self.tweet.favorited;
    self.retweetButton.selected = self.tweet.retweeted;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)favorite:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleFavorite:)]) {
        [self.delegate handleFavorite:self.tweet];
    }
}

- (IBAction)retweet:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleRetweet:)]) {
        [self.delegate handleRetweet:self.tweet];
    }
}

- (IBAction)reply:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleReplyToTweet:)]) {
        [self.delegate handleReplyToTweet:self.tweet];
    }
}

- (void)tapOnProfileImage:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(handleProfileViewForUser:)]) {
            [self.delegate handleProfileViewForUser:self.tweet.user];
        }
    }
}
@end
