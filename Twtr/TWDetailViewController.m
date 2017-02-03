//
//  TWDetailViewController.m
//  Twtr
//
//  Created by Min Lee on 2/1/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import "TWDetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "TWUser.h"
#import "TWTwitterClient.h"
#import "TWComposeViewController.h"
#import "TWNavigationManager.h"

@interface TWDetailViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *rtCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetedByLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIView *topContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContainerHeightConstraint;

@end

@implementation TWDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"Tweet";
//    UIBarButtonItem *replyButton = [UIBarButtonItem new];
//    replyButton.target = self;
//    replyButton.action = @selector(handleReply:);
//    replyButton.title = @"Reply";
//    self.navigationItem.rightBarButtonItem = replyButton;

    // Adding UIGestureRecognizer programmatically because "nib must contain exactly one top level object" error
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnProfileImage:)];
    tap.cancelsTouchesInView = YES;
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.profileImageView addGestureRecognizer:tap];

    [self initViewWithTweet:self.tweet];
}

- (void)initViewWithTweet:(TWTweet *)tweet;
{
    self.contentLabel.text = tweet.text;
    self.createdAtLabel.text = [NSDateFormatter localizedStringFromDate:tweet.createdAt
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterShortStyle];
    self.rtCountLabel.text = [tweet.retweetCount stringValue];
    self.favCountLabel.text = [tweet.favoritesCount stringValue];
    
    TWUser *user = tweet.user;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrlString]];
    self.nameLabel.text = user.name;
    self.handleLabel.text = [@"@" stringByAppendingString:user.screenName];
    
    if (tweet.retweetedBy) {
        self.retweetedByLabel.text = tweet.retweetedBy;
    } else {
        self.topContainerView.hidden = YES;
        self.topContainerHeightConstraint.constant = 0;
        [self.view setNeedsUpdateConstraints];
    }
    
    self.favoriteButton.selected = tweet.favorited;
    self.retweetButton.selected = tweet.retweeted;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reply:(id)sender {
    TWComposeViewController *composeViewController = [TWComposeViewController new];
    composeViewController.replyingToTweet = self.tweet;
    composeViewController.replyingToUser = self.tweet.user;
    [self.navigationController pushViewController:composeViewController animated:YES];
}

- (IBAction)favorite:(id)sender {
    [self.tweet toggleFavorithWithCompletion:^(TWTweet *tweet, NSError *error) {
        if (!error) {
            self.tweet = tweet;
            [self initViewWithTweet:tweet];
        }
    }];
}

- (IBAction)retweet:(id)sender {
    [self.tweet toggleRetweetWithCompletion:^(TWTweet *tweet, NSError *error) {
        if (!error) {
            self.tweet = tweet;
            [self initViewWithTweet:tweet];
        }
    }];
}

- (void)tapOnProfileImage:(UITapGestureRecognizer *)sender {
    UIViewController *profileViewController = [[TWNavigationManager sharedInstance] profileViewControllerForUser:self.tweet.user];
    [self.navigationController pushViewController:profileViewController animated:YES];
}

@end
