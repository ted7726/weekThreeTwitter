//
//  TweetsViewController.m
//  Twitter
//
//  Created by WeiSheng Su on 2/8/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetsCell.h"
#import "TweetDetailView.h"
#import "NewTweetView.h"
#import "LoginViewController.h"
@interface TweetsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
//        
//    }];
    
    /* setup Table View */
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetsCell" bundle:nil] forCellReuseIdentifier:@"TweetsCell"];
    
    /* setup refresh Control */
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing..."];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self onRefresh];
    
    
    /* setup navigation Buttons */
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewTweet)];
    
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
    /* setup navigation Bar */
    self.title = @"Home";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //R93 G183 B248
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:93/255.0f green:183/255.0f blue:248/255.0f alpha:1.0f];;
    self.navigationController.navigationBar.translucent = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetsCell"];
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetDetailView *vc = [[TweetDetailView alloc]init];
    Tweet *tweet = self.tweets[indexPath.row];
    vc.tweet = tweet;
    vc.favorited = tweet.favorited;
    vc.retweeted = tweet.retweeted;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
    

- (void)onLogout{
    [User logout];
    [self presentViewController:[[LoginViewController alloc] init] animated:YES completion:nil];
}

- (void) onNewTweet{
    
    NewTweetView *vc = [[NewTweetView alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) onRefresh{
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.tweets = [tweets mutableCopy];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
    
}

@end
