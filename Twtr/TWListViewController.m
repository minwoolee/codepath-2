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

@interface TWListViewController () <UITableViewDelegate, UITableViewDataSource>

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
    
    // configure navigation bar
    self.navigationItem.title = @"Home";
    UIBarButtonItem *newButton = [UIBarButtonItem new];
    newButton.target = self;
    newButton.action = @selector(handleCompose:);
    newButton.title = @"New";
    self.navigationItem.rightBarButtonItem = newButton;

    UIBarButtonItem *signOutButton = [UIBarButtonItem new];
    signOutButton.target = self;
    signOutButton.action = @selector(handleSignOut:);
    signOutButton.title = @"Sign Out";
    self.navigationItem.leftBarButtonItem = signOutButton;
    
    UINib *cellNib = [UINib nibWithNibName:@"TWTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"TWTableViewCell"];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    [self loadTweets];
}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    CGFloat top = [self.topLayoutGuide length];
//    CGFloat bottom = [self.bottomLayoutGuide length];
//    UIEdgeInsets insets = UIEdgeInsetsMake(top, 0, bottom, 0);
//    self.tableView.contentInset = insets;
//}

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
    [[TWTwitterClient sharedInstance] timelineWithCompletion:^(NSArray<TWTweet *> *tweets, NSError *error) {
        self.tweets = tweets;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)handleCompose:(id)sender;
{
    [self.navigationController pushViewController:[TWComposeViewController new] animated:YES];
}

- (void)handleSignOut:(id)sender;
{
    UIAlertController *confirmSignOut = [UIAlertController alertControllerWithTitle:@"Sign out?"
                                                                            message:nil
                                                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [[TWNavigationManager sharedInstance] logOut];
                                                         [self presentViewController:[TWLoginViewController new] animated:YES completion:^{
                                                             //
                                                         }];
                                                     }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             // do nothing
                                                         }];
    
    [confirmSignOut addAction:okAction];
    [confirmSignOut addAction:cancelAction];
    [self presentViewController:confirmSignOut animated:YES completion:nil];
}

@end
