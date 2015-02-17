//
//  TweetsViewController.h
//  Twitter
//
//  Created by WeiSheng Su on 2/8/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@class TweetsViewController;

@protocol TweetsViewControllerDelegate <NSObject>
- (void)onMenuButton;
- (void)tapOnCellProfileImage:(User *)user;
@end


@interface TweetsViewController : UIViewController

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MenuViewController *menuViewController;
//@property (nonatomic, strong) NSMutableArray *tweets;

@property (nonatomic, weak) id <TweetsViewControllerDelegate> delegate;

@end






static NSMutableArray *currentTweets;
