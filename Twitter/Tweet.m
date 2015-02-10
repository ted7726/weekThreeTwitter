//
//  Tweet.m
//  Twitter
//
//  Created by WeiSheng Su on 2/7/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet


- (id) initWithDictionary: (NSDictionary *)dictionary{
    self = [super init];
    if (self){
        self.countFavorites = [dictionary[@"favorite_count"] stringValue];
        self.countRetweets = [dictionary[@"retweet_count"] stringValue];
        
        self.favorited = (((int)dictionary[@"favorited"])>0);
        self.retweeted = (((int)dictionary[@"retweeted"])>0);
        self.id_str= dictionary[@"id_str"];
        
        self.retweet = (dictionary[@"retweeted_status"]!=nil);
        if (self.retweet){
            self.retweetUser = [[User alloc] initWithDictionary:dictionary[@"user"]];
            dictionary = [dictionary[@"retweeted_status"] mutableCopy];
            NSLog(@"retweet %@",dictionary);
        }
        
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        
    
        
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formmater = [[NSDateFormatter alloc]init];
        
        formmater.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formmater dateFromString:createdAtString];
    }
    //NSLog(@"Tweet: %@",dictionary);
    return self;
}



+ (NSArray *)tweetsWithArray:(NSArray *)array{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}
@end
