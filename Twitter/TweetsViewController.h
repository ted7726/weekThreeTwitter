//
//  TweetsViewController.h
//  Twitter
//
//  Created by WeiSheng Su on 2/8/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetsViewController : UIViewController

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;

@end
