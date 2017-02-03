//
//  TWListViewController.m
//  Twtr
//
//  Created by Min Lee on 1/30/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import "TWListViewController.h"
#import "TWTableViewCell.h"
#import "TWTwitterClient.h"
#import "AppDelegate.h"
#import "TWLoginViewController.h"
#import "TWComposeViewController.h"
#import "TWDetailViewController.h"
#import "TWNavigationManager.h"

@interface TWListViewController () <UITableViewDelegate, UITableViewDataSource, TWTableCellActionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray<TWTweet *> *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TWListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *cellNib = [UINib nibWithNibName:@"TWTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"TWTableViewCell"];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated;
{
    // reload table view in case tweet was favorited or retweeted in detail view
    [self loadTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWTableViewCell" forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    TWDetailViewController *detailViewController = [TWDetailViewController new];
    detailViewController.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)loadTweets;
{
    [[TWTwitterClient sharedInstance] timelineApi:self.api withCompletion:^(NSArray<TWTweet *> *tweets, NSError *error) {
        self.tweets = tweets;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - TWTableCellActionDelegate methods

- (void)handleRetweet:(TWTweet *)tweet;
{
    [tweet toggleRetweetWithCompletion:^(TWTweet *tweet, NSError *error) {
        if (!error) {
            [self.tableView reloadData];
        }
    }];
}

- (void)handleFavorite:(TWTweet *)tweet;
{
    [tweet toggleFavorithWithCompletion:^(TWTweet *tweet, NSError *error) {
        if (!error) {
            [self.tableView reloadData];
        }
    }];
}

- (void)handleReplyToTweet:(TWTweet *)tweet;
{
    TWComposeViewController *composeViewController = [TWComposeViewController new];
    composeViewController.replyingToTweet = tweet;
    composeViewController.replyingToUser = tweet.user;
    [self.navigationController pushViewController:composeViewController animated:YES];
}

- (void)handleProfileViewForUser:(TWUser *)user;
{
    UIViewController *profileViewController = [[TWNavigationManager sharedInstance] profileViewControllerForUser:user];
    [self.navigationController pushViewController:profileViewController animated:YES];
}

@end
