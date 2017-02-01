//
//  TWComposeViewController.m
//  Twtr
//
//  Created by Min Lee on 1/31/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import "TWComposeViewController.h"

@interface TWComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@end

@implementation TWComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat top = [self.topLayoutGuide length];
    CGFloat bottom = [self.bottomLayoutGuide length];
    UIEdgeInsets insets = UIEdgeInsetsMake(top, 0, bottom, 0);
    self.contentInset = insets;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
