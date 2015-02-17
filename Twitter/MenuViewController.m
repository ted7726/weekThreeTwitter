//
//  MenuViewController.m
//  Twitter
//
//  Created by WeiSheng Su on 2/16/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import "MenuViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *itemsText;
@property (nonatomic, strong) NSArray *itemsIcon;
@end

@implementation MenuViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view from its nib.
    _user = [User currentUser];
    
    self.nameLabel.text = User.currentUser.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@",User.currentUser.screenName];
    [self.profileImage setImageWithURL:[NSURL URLWithString:[User.currentUser.profileName stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"]]];
    [self.profileImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapProfileImage)];
    [self.profileImage addGestureRecognizer:tapGestureRecognizer];
    

    
    [self.bannerImage setImageWithURL:[NSURL URLWithString:User.currentUser.bannerImage]];
    _itemsText = @[@"Timeline", @"About me", @"Sign out", @"Mentions"];
    _itemsIcon = @[@"home.png", @"me.png", @"signout.png", @"mentions.png"];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    [cell.imageView setImage:[UIImage imageNamed:_itemsIcon[indexPath.row]]];
    [cell.textLabel setText:_itemsText[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.menuViewControllerDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itemsText.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)onTapProfileImage{
    [self.menuViewControllerDelegate tapOnProfile];
}


@end
