//
//  NewTweetView.m
//  Twitter
//
//  Created by WeiSheng Su on 2/9/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import "NewTweetView.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface NewTweetView ()

@end

@implementation NewTweetView


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:nil];
//    
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton)];
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
    
    /* setup user */
    
    self.nameLabel.text = User.currentUser.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@",User.currentUser.screenName];
    [self.profileImage setImageWithURL:[NSURL URLWithString:[User.currentUser.profileName stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onCancelButton{
    
    
}

- (void) onTweetButton {
    NSLog(@"Text: %@",self.textView.text);
    [[TwitterClient sharedInstance] updateWithStatus:self.textView.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail to tweet, %@",error.description);
    }];
    [self.navigationController popViewControllerAnimated:YES];
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
