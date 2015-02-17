//
//  ProfileViewController.h
//  Twitter
//
//  Created by WeiSheng Su on 2/16/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "TweetsCell.h"
#import "User.h"


@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) User *user;


@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countTweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *countFollowingLabel;
@property (weak, nonatomic) IBOutlet UILabel *countFollowersLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@end
