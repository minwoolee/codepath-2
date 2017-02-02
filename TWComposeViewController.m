//
//  TWComposeViewController.m
//  Twtr
//
//  Created by Min Lee on 1/31/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import "TWComposeViewController.h"
#import "TWTwitterClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface TWComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *charCountLabel;

@end

@implementation TWComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    TWUser *currentUser = TWUser.currentUser;
    if (currentUser) {
        [self.profileImageView setImageWithURL:[NSURL URLWithString:currentUser.profileImageUrlString]];
        self.nameLabel.text = currentUser.name;
        self.handleLabel.text = [@"@" stringByAppendingString:currentUser.screenName];
    }

    self.tweetTextView.delegate = self;
    
    UIBarButtonItem *tweetButton = [UIBarButtonItem new];
    tweetButton.target = self;
    tweetButton.action = @selector(handleTweet:);
    tweetButton.title = @"Tweet";
    self.navigationItem.rightBarButtonItem = tweetButton;
    
    [self.tweetTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate methods
- (void)textViewDidChange:(UITextView *)textView;
{
    self.charCountLabel.text = [@(textView.text.length) stringValue];
//    NSLog(@"%@", [@(textView.text.length) stringValue]);
}

#pragma mark - app methods

- (void)handleTweet:(id)sender;
{
    
}

@end
