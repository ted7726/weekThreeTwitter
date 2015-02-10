//
//  NewTweetView.h
//  Twitter
//
//  Created by WeiSheng Su on 2/9/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@class NewTweetView;

@interface NewTweetView : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end
