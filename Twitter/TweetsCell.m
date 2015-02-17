//
//  TweetsCell.m
//  Twitter
//
//  Created by WeiSheng Su on 2/8/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import "TweetsCell.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"


@implementation TweetsCell

- (void)awakeFromNib {
    // Initialization code
    self.tweetTextLabel.preferredMaxLayoutWidth = self.tweetTextLabel.frame.size.width;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapProfileImage)];
    [self.userProfile addGestureRecognizer:tapGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.userProfile.layer.cornerRadius = 5;
    self.userProfile.clipsToBounds = YES;
    
}


- (void)setTweet:(Tweet *)tweet{
    _tweet = tweet;
    
    
    [self.userProfile setImageWithURL:[NSURL URLWithString:_tweet.user.profileName]];
    self.nameLabel.text = _tweet.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@",_tweet.user.screenName];
    self.tweetTextLabel.text = _tweet.text;
    
//    NSLog(@"Tweet: %@", tweet);
    self.createdAtLabel.text = [self stringFromTimeIntervalSinceNow:_tweet.createdAt];

    if(_tweet.retweet){
        [self.retweetImage setImage:[UIImage imageNamed:@"retweet.png"]];
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweeted",_tweet.retweetUser.name];
    }else{
        [self.retweetImage setImage:nil];
        self.retweetLabel.text = @"";
    }
    
    [self.retweetButton setImage:[UIImage imageNamed:(_tweet.retweeted ? @"retweet_on.png" : @"retweet.png")] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:(_tweet.favorited ? @"favorite_on.png" : @"favorite.png")] forState:UIControlStateNormal];
    
}
- (void) layoutSubviews{
    [super layoutSubviews];
    self.tweetTextLabel.preferredMaxLayoutWidth = self.tweetTextLabel.frame.size.width;
    
}

- (NSString *)stringFromTimeIntervalSinceNow:(NSDate *)date {
    NSInteger ti = (NSInteger)[date timeIntervalSinceNow];
    NSInteger mins = -(ti / 60);
    NSInteger hours = -(ti / 3600);
    
    if (hours <1){
        return [NSString stringWithFormat:@"%ldm",mins];
    }else if(hours<24){
        return [NSString stringWithFormat:@"%ldh",hours];
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        return [formatter stringFromDate:date];
    }

}
- (IBAction)replyButton:(id)sender {
    NSLog(@"reply!");
    
}
- (IBAction)retweetButton:(id)sender {
    [self.retweetButton setImage:[UIImage imageNamed:(_tweet.retweeted ? @"retweet.png" : @"retweet_on.png")] forState:UIControlStateNormal];
    [_tweet toggleRetweet:nil completion:^(NSString *retweetCount, NSError *error) {
    }];
}
- (IBAction)favoriteButton:(id)sender {
    [self.favoriteButton setImage:[UIImage imageNamed:(_tweet.favorited ? @"favorite.png" : @"favorite_on.png")] forState:UIControlStateNormal];
    [_tweet toggleFavorite:nil completion:^(NSString *favoriteCount, NSError *error) {   
    }];
}

- (void)onTapProfileImage{
    [self.tweetCellDelegate tapOnCellProfileImage:_tweet.user];
}

@end
