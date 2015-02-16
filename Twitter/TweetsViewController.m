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
    
    currentTweets = [[NSMutableArray alloc]init];
    
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
    

    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"write.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onNewTweet)];
    
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
    /* setup navigation Bar */
    self.title = @"Home";


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(currentTweets){
        return currentTweets.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetsCell"];
    cell.tweet = currentTweets[indexPath.row];
    
    if(currentTweets.count-2<indexPath.row){
        NSDictionary *parameters = @{@"count": @(currentTweets.count+20)};
        [[TwitterClient sharedInstance] homeTimelineWithParams:parameters completion:^(NSArray *tweets, NSError *error) {
            [currentTweets removeAllObjects];
            currentTweets = [tweets mutableCopy];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetDetailView *vc = [[TweetDetailView alloc]init];
    Tweet *tweet = currentTweets[indexPath.row];
    vc.tweet = tweet;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    CGFloat preLoadDistance = 10;
    
    if(distanceFromBottom+preLoadDistance < height){
//        NSLog(@"end of the table");
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
    

- (void)onLogout{
    [User logout];
    //[currentTweets removeAllObjects];
    self.navigationController.navigationBar.hidden = true;
    [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
    
    
}

- (void) onNewTweet{
    
    NewTweetView *vc = [[NewTweetView alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) onRefresh{
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        [currentTweets removeAllObjects];
        currentTweets = [tweets mutableCopy];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
    
}

@end
