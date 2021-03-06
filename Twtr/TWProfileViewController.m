//
//  TWProfileViewController.m
//  Twtr
//
//  Created by Min Lee on 2/2/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import "TWProfileViewController.h"
#import "TWNavigationManager.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface TWProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TWProfileViewController

static const int ROW_TWEETS = 0;
static const int ROW_FOLLOWERS = 1;
static const int ROW_FOLLOWING = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.navigationItem.title = @"Profile";

    TWUser *user = self.user;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrlString]];
    self.nameLabel.text = user.name;
    self.handleLabel.text = [@"@" stringByAppendingString:user.screenName];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
    }
    
    TWUser *user = self.user;
    switch(indexPath.row) {
        case ROW_TWEETS:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ Tweets", user.tweetCount];
            if (user.tweetCount > 0) {
                cell.userInteractionEnabled = YES;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                cell.userInteractionEnabled = NO;
            }
            break;
        case ROW_FOLLOWERS:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ Followers", user.followersCount];
            if (user.followersCount > 0) {
                cell.userInteractionEnabled = YES;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                cell.userInteractionEnabled = NO;
            }
            break;
        case ROW_FOLLOWING:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ Following", user.followingCount];
            if (user.followingCount > 0) {
                cell.userInteractionEnabled = YES;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                cell.userInteractionEnabled = NO;
            }
            break;
        default:
            break;
            // nothing
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch(indexPath.row) {
        case ROW_TWEETS:
        {
            UIViewController *vc = [[TWNavigationManager sharedInstance] tweetsListViewControllerForUser:self.user];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case ROW_FOLLOWERS:
        {
            UIViewController *vc = [[TWNavigationManager sharedInstance] usersListViewControllerFollowingUser:self.user];
            vc.navigationItem.title = @"Followers";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case ROW_FOLLOWING:
        {
            UIViewController *vc = [[TWNavigationManager sharedInstance] usersListViewControllerFollowedByUser:self.user];
            vc.navigationItem.title = @"Following";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
