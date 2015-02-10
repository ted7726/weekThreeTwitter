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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.userProfile.layer.cornerRadius = 5;
    self.userProfile.clipsToBounds = YES;
    
}


- (void)setTweet:(Tweet *)tweet{
    
    //self.tweet = [tweet mutableCopy];
    [self.userProfile setImageWithURL:[NSURL URLWithString:tweet.user.profileName]];
    self.nameLabel.text = tweet.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
    self.tweetTextLabel.text = tweet.text;
    
//    NSLog(@"Tweet: %@", tweet);
    self.createdAtLabel.text = [self stringFromTimeIntervalSinceNow:tweet.createdAt];

    if(tweet.retweet){
        [self.retweetImage setImage:[UIImage imageNamed:@"retweet.png"]];
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweeted",tweet.retweetUser.name];
    }else{
        [self.retweetImage setImage:nil];
        self.retweetLabel.text = @"";
    }
    
    self.retweeted = tweet.retweeted;
    self.favorited = tweet.favorited;
    if(_retweeted){
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
    }else{
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateNormal];
    }
    
    if(_favorited){
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    }else{
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateNormal];
    }
    
    
    
    
    //NSLog(@"userProfile: %@, nameLabel: %@, username: %@, text: %@,",);
    
}
- (void) layoutSubviews{
    [super layoutSubviews];
    self.tweetTextLabel.preferredMaxLayoutWidth = self.tweetTextLabel.frame.size.width;
    
}

- (NSString *)stringFromTimeIntervalSinceNow:(NSDate *)date {
    NSInteger ti = (NSInteger)[date timeIntervalSinceNow];
    NSInteger hours = -(ti / 3600);
    
    if (hours <24){
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
    NSLog(@"retweet!");
    if(_retweeted){
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
    }else{
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateNormal];
    }
    _retweeted = !_retweeted;
    
}
- (IBAction)favoriteButton:(id)sender {
    NSLog(@"favorite!");
    if(_favorited){
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
        
    }else{
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateNormal];
    }
    _favorited = !_favorited;
    
}

@end
