//
//  Tweet.h
//  Twitter
//
//  Created by WeiSheng Su on 2/7/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *countRetweets;
@property (nonatomic, strong) NSString *countFavorites;
@property (nonatomic, strong) NSString *id_str;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) User *retweetUser;
@property (nonatomic, assign) BOOL retweet;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, assign) BOOL favorited;





- (id) initWithDictionary: (NSDictionary *)dictionary;

+ (NSArray *) tweetsWithArray:(NSArray * )array;

@end
