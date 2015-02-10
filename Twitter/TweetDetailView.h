//
//  TweetDetailView.h
//  Twitter
//
//  Created by WeiSheng Su on 2/9/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetDetailView : UIViewController

@property (nonatomic,strong) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *noRetweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *noFavoritesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (nonatomic,assign) BOOL retweeted;
@property (nonatomic,assign) BOOL favorited;

@end
