//
//  MainViewController.m
//  Twitter
//
//  Created by WeiSheng Su on 2/16/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import "MainViewController.h"
#import "MenuViewController.h"
#import "TweetsViewController.h"
#import "TweetsCell.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"
@interface MainViewController () <TweetsViewControllerDelegate, MenuViewControllerDelegate>

@property (nonatomic, strong) UINavigationController *navigationViewController;
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, strong) TweetsViewController *tweetsViewController;
@property (nonatomic, assign) BOOL menuOpen;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init the content
    _menuViewController = [[MenuViewController alloc] init];
    _menuViewController.menuViewControllerDelegate = self;
    _tweetsViewController = [[TweetsViewController alloc]init];
    _tweetsViewController.delegate = self;
    
    _navigationViewController = [[UINavigationController alloc]initWithRootViewController:_tweetsViewController];
    _navigationViewController.navigationBar.barStyle = UIBarStyleBlack;
    //R93 G183 B248
    _navigationViewController.navigationBar.barTintColor = [UIColor colorWithRed:93/255.0f green:183/255.0f blue:248/255.0f alpha:1.0f];;
    _navigationViewController.navigationBar.translucent = NO;
    [_navigationViewController.view.layer setShadowOffset:CGSizeMake(0, 1)];
    [_navigationViewController.view.layer setShadowColor:[[UIColor darkGrayColor] CGColor]];
    [_navigationViewController.view.layer setShadowRadius:8.0];
    [_navigationViewController.view.layer setShadowOpacity:0.8];
    
    
    
    CGRect frame = _menuViewController.view.frame;
    _menuViewController.view.frame =self.view.frame;
    frame.origin.x = frame.origin.x - 300;
    _menuViewController.view.frame = frame;
    _navigationViewController.view.frame =self.view.frame;
    [self.view addSubview:_menuViewController.view];
    [self.view addSubview:_navigationViewController.view];
    
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    [_navigationViewController.view addGestureRecognizer:panGestureRecognizer];
    _menuOpen = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    CGRect frame = _navigationViewController.view.frame;
    frame.origin.x = translation.x + (_menuOpen?300:0);
    
    if(sender.state == UIGestureRecognizerStateEnded){
        if(velocity.x>0){
            frame.origin.x = 300;
            _menuOpen = YES;
        }else{
            frame.origin.x = 0;
            _menuOpen = NO;
        }
        [UIView animateWithDuration:0.4 animations:^{
            [self menuMoving:frame];
        }];
    }else{
        [self menuMoving:frame];
    }

}

- (void) menuMoving: (CGRect)frame{
    _navigationViewController.view.frame = frame;
    frame.origin.x = frame.origin.x - 300;
    _menuViewController.view.frame = frame;
    
}

- (void)onMenuButton{
    CGRect frame = _navigationViewController.view.frame;
    if(_menuOpen){
        frame.origin.x=0;
    }else{
        frame.origin.x=300;
    }
    [UIView animateWithDuration:0.4 animations:^{
        [self menuMoving:frame];
    }];

    _menuOpen = !_menuOpen;
}

- (void) closeMenu{
    
    CGRect frame = _navigationViewController.view.frame;
    frame.origin.x=0;
    [UIView animateWithDuration:0.4 animations:^{
        [self menuMoving:frame];
    }];
    _menuOpen = NO;
}

- (void)tapOnCellProfileImage:(User *)user{
    ProfileViewController *profileViewController= [[ProfileViewController alloc]init];
    profileViewController.user = user;
    [_navigationViewController pushViewController:profileViewController animated:YES];
    [self closeMenu];
}
- (void) tapOnProfile{
    ProfileViewController *profileViewController= [[ProfileViewController alloc]init];
    profileViewController.user = [User currentUser];
    [_navigationViewController pushViewController:profileViewController animated:YES];
    [self closeMenu];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        [_navigationViewController popToRootViewControllerAnimated:YES];
    }else if(indexPath.row == 1){
        [self tapOnProfile];
    }else if(indexPath.row == 2){
        [self onLogout];
    }else if(indexPath.row == 3){
        [self onMentions];
    }
    [self closeMenu];
}

- (void)onLogout{
    [User logout];
    //[currentTweets removeAllObjects];
    [self presentViewController:[[LoginViewController alloc]init] animated:YES completion:nil];
}


- (void) onMentions{
    [[TwitterClient sharedInstance] mentionsTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        [currentTweets removeAllObjects];
        currentTweets = [tweets mutableCopy];
    }];
}




@end
