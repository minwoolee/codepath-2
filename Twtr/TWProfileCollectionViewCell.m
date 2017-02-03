//
//  TWProfileCollectionViewCell.m
//  Twtr
//
//  Created by Min Lee on 2/3/17.
//  Copyright © 2017 Min Lee. All rights reserved.
//

#import "TWProfileCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface TWProfileCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;

@end

@implementation TWProfileCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUser:(TWUser *)user;
{
    _user = user;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrlString]];
    self.nameLabel.text = user.name;
    self.handleLabel.text = [@"@" stringByAppendingString:user.screenName];
}

@end
