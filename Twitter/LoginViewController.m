//
//  LoginViewController.m
//  Twitter
//
//  Created by WeiSheng Su on 2/7/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "MainViewController.h"
#import "UIImageView+AFNetworking.h"


@interface LoginViewController ()

@end

@implementation LoginViewController
- (IBAction)onLogin:(id)sender {
    [[TwitterClient sharedInstance]loginWithCompetion:^(User *user, NSError *error) {
        if(user){
            // if successfully
            NSLog(@"Welcome to %@", user.name);
            [self goMainView];
            
        }else{
            // if error
            NSLog(@"login failed!");
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    User *user = [User currentUser];
    if (user!=nil){
        [self.loginButton setTitle:[NSString stringWithFormat:@"Welcome %@", user.name] forState:UIControlStateNormal];
        [self.profileImage setImageWithURL:[NSURL URLWithString:[user.profileName stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"]]];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
        [self performSelector:@selector(goMainView) withObject:nil afterDelay:1.0];
}

- (void) goMainView{
    User *user = [User currentUser];
    if (user!=nil){
        
        [self presentViewController:[[MainViewController alloc]init] animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
