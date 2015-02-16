//
//  Tweet.m
//  Twitter
//
//  Created by WeiSheng Su on 2/7/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import "Tweet.h"
#import "TwitterClient.h"

@implementation Tweet


- (id) initWithDictionary: (NSDictionary *)dictionary{
    self = [super init];
    if (self){
        self.countFavorites = [dictionary[@"favorite_count"] stringValue];
        self.countRetweets = [dictionary[@"retweet_count"] stringValue];
        
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        
        
        self.id_str = dictionary[@"id_str"];
        
        self.retweet = (dictionary[@"retweeted_status"]!=nil);
        if (self.retweet){
            self.retweetUser = [[User alloc] initWithDictionary:dictionary[@"user"]];
            dictionary = [dictionary[@"retweeted_status"] mutableCopy];
            self.retweet_id_str = dictionary[@"id_str"];
            NSLog(@"retweet %@",dictionary);
        }
        
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.tweetByCurrentUser = [self.user.screenName isEqualToString:User.currentUser.screenName];
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



- (void)toggleRetweet:(NSDictionary *)params completion:(void (^)(NSString * retweetCount, NSError *error))completion{
    [[TwitterClient sharedInstance] toggleRetweetWithId:(_retweeted ? _retweet_id_str : _id_str) retweeted:_retweeted success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"success to retweet response: %d %@",_retweeted, responseObject);
        NSString * retweetCount;
        if(!_retweeted){
            _retweet_id_str = responseObject[@"id_str"];
            retweetCount = [responseObject[@"retweet_count"] stringValue];
            NSLog(@"retweet id %@, id %@",_retweet_id_str,_id_str);
        }else{
            NSInteger count = [responseObject[@"retweet_count"] integerValue] -1;
            retweetCount = [NSString stringWithFormat:@"%ld",count];
        }
        _retweeted = !_retweeted;
        completion(retweetCount,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail to retweet id %@, id %@",_retweet_id_str,_id_str);
        completion(nil,error);
    }];
    
}

- (void)toggleFavorite:(NSDictionary *)params completion:(void (^)(NSString *, NSError *error))completion{
    [[TwitterClient sharedInstance] toggleFavoriteWithId:_id_str favorited:_favorited success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _favorited = !_favorited;
        NSString * favoriteCount = [responseObject[@"favorite_count"] stringValue];
        completion(favoriteCount,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail to favorite id %@",_id_str);
        completion(nil,error);
    }];
}






@end
