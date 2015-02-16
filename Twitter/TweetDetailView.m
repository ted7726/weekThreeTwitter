//
//  TweetDetailView.m
//  Twitter
//
//  Created by WeiSheng Su on 2/9/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import "TweetDetailView.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "NewTweetView.h"

@interface TweetDetailView ()

@end

@implementation TweetDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Tweet";
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReplyButton)];
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
    
    //self.tweet = [tweet mutableCopy];
    [self.profileImage setImageWithURL:[NSURL URLWithString:[_tweet.user.profileName stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"]]];
    self.nameLabel.text = _tweet.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@",_tweet.user.screenName];
    self.tweetTextLabel.text = _tweet.text;
    
    //    NSLog(@"Tweet: %@", tweet);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy, HH:mm"];
    self.createdAtLabel.text = [formatter stringFromDate:_tweet.createdAt];
    
    if(_tweet.retweet){
        [self.retweetImage setImage:[UIImage imageNamed:@"retweet.png"]];
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweeted",_tweet.retweetUser.name];
    }else{
        [self.retweetImage setImage:nil];
        self.retweetLabel.text = @"";
    }
    if(_tweet.countRetweets !=nil){
        self.noRetweetsLabel.text = _tweet.countRetweets;
    }
    if(_tweet.countFavorites !=nil){
        self.noFavoritesLabel.text = _tweet.countFavorites;
    }
    
    [self.replyButton setImage:[UIImage imageNamed:@"reply.png"] forState:UIControlStateNormal];
    
    [self.retweetButton setImage:[UIImage imageNamed:(_tweet.retweeted ? @"retweet_on.png" : @"retweet.png")] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:(_tweet.favorited ? @"favorite_on.png" : @"favorite.png")] forState:UIControlStateNormal];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onReplyButton{
    [self.navigationController pushViewController:[[NewTweetView alloc]init] animated:YES];
}
- (IBAction)replyButton:(id)sender {
    NSLog(@"reply");
    [self.navigationController pushViewController:[[NewTweetView alloc]init] animated:YES];
}

- (IBAction)retweetButton:(id)sender {
    [self.retweetButton setImage:[UIImage imageNamed:(_tweet.retweeted ? @"retweet.png" : @"retweet_on.png")] forState:UIControlStateNormal];
    [_tweet toggleRetweet:nil completion:^(NSString *retweetCount, NSError *error) {
        if(retweetCount){
            self.noRetweetsLabel.text = retweetCount;
        }
    }];
    
}
- (IBAction)favoriteButton:(id)sender {
    [self.favoriteButton setImage:[UIImage imageNamed:(_tweet.favorited ? @"favorite.png" : @"favorite_on.png")] forState:UIControlStateNormal];
    [_tweet toggleFavorite:nil completion:^(NSString *favoriteCount, NSError *error) {
        if (favoriteCount){
            self.noFavoritesLabel.text = favoriteCount;
        }
    }];
}

@end
