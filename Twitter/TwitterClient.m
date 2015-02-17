//
//  TwitterClient.m
//  Twitter
//
//  Created by WeiSheng Su on 2/7/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"wfvYAhoEbEJY0QM1j4LMZeOY0";
NSString * const kTwitterConsumerSecret = @"zFMYrEUtOeLLg1AIjXAoNLEvinvy9GXGp0T32Yn5npm1q5apCY";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";


@implementation TwitterClient

+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(instance == nil){
            instance = [[TwitterClient alloc]initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    return instance;
}

- (void)loginWithCompetion:(void (^)(User *, NSError *))completion{
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"got the request token!");
        
        NSURL *authURL = [NSURL URLWithString:
                          [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@",requestToken.token]];
        [[UIApplication sharedApplication]openURL:authURL];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the request token!");
        self.loginCompletion(nil,error);
    }];
    
}

- (void)openURL:(NSURL *)url{
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        
        [self.requestSerializer saveAccessToken:accessToken];
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"current user: %@",user.name);
            self.loginCompletion(user,nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed getting current user");
            self.loginCompletion(nil,error);
        }];
        
        [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *tweets = [Tweet tweetsWithArray:responseObject];
            for(Tweet *tweet in tweets){
                NSLog(@"Tweet: %@, created at: %@",tweet.text, tweet.createdAt);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed getting tweets");
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"failed to get the access token!");
    }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params
                    completion:(void (^)(NSArray *, NSError *))completion{
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets =[Tweet tweetsWithArray:responseObject];
        completion(tweets,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
    }];
}

- (void)mentionsTimelineWithParams:(NSDictionary *)params
                    completion:(void (^)(NSArray *, NSError *))completion{
    [self GET:@"1.1/statuses/mentions_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets =[Tweet tweetsWithArray:responseObject];
        completion(tweets,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
    }];
}


- (AFHTTPRequestOperation *)updateWithStatus:(NSString *)status
                                     success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"status": status};
    return [self POST:@"1.1/statuses/update.json" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)toggleRetweetWithId:(NSString *)tweetId
                                      retweeted:(BOOL)retweeted
                                        success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString * url = [NSString stringWithFormat:@"%@%@%@%@",@"1.1/statuses/",(retweeted ? @"destroy/":@"retweet/"),tweetId,@".json"];
    NSLog(@"%@",url);
    return [self POST:url parameters:nil success:success failure:failure];
}
- (AFHTTPRequestOperation *)toggleFavoriteWithId:(NSString *)tweetId
                                       favorited:(BOOL)favorited
                                         success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString * endPoint = [NSString stringWithFormat:@"%@%@%@",@"1.1/favorites/",(favorited ? @"destroy":@"create"),@".json"];
    NSDictionary *parameters = @{@"id": tweetId};
    return [self POST:endPoint parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)timelineForUser:(NSString *)screenName
                                    success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"screen_name": screenName};
    return [self POST:@"1.1/statuses/user_timeline.json" parameters:parameters success:success failure:failure];
}



- (void)timelineForUser:(NSString *)screenName completion:(void (^)(NSArray *, NSError *))completion{
    NSDictionary *params = @{@"screen_name": screenName};
    [self GET:@"1.1/statuses/user_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets =[Tweet tweetsWithArray:responseObject];
        completion(tweets,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
    }];
}






@end
