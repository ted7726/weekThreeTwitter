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
    
}


- (void)singleTapGestureCaptured{
    NSLog(@"tap on the image!");
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
    NSLog(@"retweet!");
    if(_retweeted){
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
        [[TwitterClient sharedInstance] destroyWithId:self.tweet.id_str success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"successfully destroy retweet");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Fail to destroy retweet");
        }];
    }else{
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateNormal];
        [[TwitterClient sharedInstance] retweetWithId:self.tweet.id_str success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"successfully retweet");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"fail to retweet");
        }];
    }
    _retweeted = !_retweeted;
    [self viewDidLoad];
}
- (IBAction)favoriteButton:(id)sender {
    NSLog(@"favorite!");
    if(_favorited){
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
        [[TwitterClient sharedInstance] removeFavoriteWithId:self.tweet.id_str success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"successfully remove");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"fail to remove");
        }];
    }else{
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateNormal];
        
        [[TwitterClient sharedInstance] favoriteWithId:self.tweet.id_str success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"successfully favorite");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"fail to favorite");
        }];
        
    }
    _favorited = !_favorited;
    [self viewDidLoad];
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
