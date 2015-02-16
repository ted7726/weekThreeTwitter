//
//  TweetsCell.h
//  Twitter
//
//  Created by WeiSheng Su on 2/8/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
@interface TweetsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImage;
@property (weak, nonatomic) IBOutlet UIImageView *userProfile;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;


@property (nonatomic, strong) Tweet *tweet;

@end
