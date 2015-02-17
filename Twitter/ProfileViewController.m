//
//  ProfileViewController.m
//  Twitter
//
//  Created by WeiSheng Su on 2/16/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"




@interface ProfileViewController ()


@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, assign) CGRect originalInfoViewFrame;
@property (nonatomic, assign) CGRect imageViewFrame;

@end

@implementation ProfileViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_user.dictionary);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetsCell" bundle:nil] forCellReuseIdentifier:@"TweetsCell"];
    
    _userNameLabel.text = self.user.name;
    _screenNameLabel.text = [NSString stringWithFormat:@"@%@",self.user.screenName];
    [_profileImageView setImageWithURL:[NSURL URLWithString:[_user.profileName stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"]]];
    
    _profileImageView.layer.cornerRadius = 3;
    _profileImageView.clipsToBounds = YES;
    [_bannerImageView setImageWithURL:[NSURL URLWithString:_user.bannerImage]];
    
    
    _countTweetsLabel.text =_user.tweetsCount;
    _countFollowersLabel.text = _user.followersCount;
    _countFollowingLabel.text = _user.followingCount;
    
    _originalFrame = _bannerImageView.frame;
    _originalFrame.origin.x = _originalFrame.origin.x;
    _originalFrame.size.width = _originalFrame.size.width +56;
    self.bannerImageView.frame = _originalFrame;
    _originalInfoViewFrame = self.infoView.frame;
    _imageViewFrame = self.profileImageView.frame;
    
    [self.view bringSubviewToFront:self.profileImageView];
    
    [self loadTweetsByUser];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetsCell"];
    cell.tweet = _tweets[indexPath.row];
    return cell;
}

- (void) loadTweetsByUser{
    [[TwitterClient sharedInstance] timelineForUser:_user.screenName completion:^(NSArray *tweets, NSError *error) {
        NSLog(@"successfuly load user");
        [_tweets removeAllObjects];
        _tweets = [tweets mutableCopy];
        [self.tableView reloadData];
    }];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = self.tableView.contentOffset.y;
    CGRect frame = _originalFrame;
    CGRect viewFrame = _originalInfoViewFrame;
    CGRect imageFrame = _imageViewFrame;
    
    if(offset <0){
        frame.origin.y = _originalFrame.origin.y + offset;
        frame.origin.x = _originalFrame.origin.x + offset*1.8;
        frame.size.height = _originalFrame.size.height - offset*2;
        frame.size.width = _originalFrame.size.width - offset*3.2;
        viewFrame.origin.y = _originalInfoViewFrame.origin.y - offset;
        imageFrame.origin.y = imageFrame.origin.y - offset;
        self.bannerImageView.frame = frame;
        self.infoView.frame = viewFrame;
        self.profileImageView.frame = imageFrame;
        
    }else{
        self.bannerImageView.frame = _originalFrame;
        self.infoView.frame = _originalInfoViewFrame;
        self.profileImageView.frame = _imageViewFrame;
    }
    
    
    [self.view bringSubviewToFront:self.profileImageView];
    
}



@end
