//
//  MenuViewController.h
//  Twitter
//
//  Created by WeiSheng Su on 2/16/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol MenuViewControllerDelegate <NSObject>

-(void)tapOnProfile;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface MenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (nonatomic, weak) id <MenuViewControllerDelegate> menuViewControllerDelegate;


@end



