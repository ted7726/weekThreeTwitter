//
//  TwitterClient.h
//  Twitter
//
//  Created by WeiSheng Su on 2/7/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager
@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);
+ (TwitterClient *) sharedInstance;

- (void) loginWithCompetion:(void (^)(User *user, NSError *error))completion;
- (void) openURL:(NSURL *)url;

- (void) homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void) mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)timelineForUser:(NSString *)screenName completion:(void (^)(NSArray *, NSError *))completion;

- (AFHTTPRequestOperation *)updateWithStatus:(NSString *)status
                                     success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;


- (AFHTTPRequestOperation *)toggleRetweetWithId:(NSString *)tweetId
                                      retweeted:(BOOL)retweeted
                                        success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)toggleFavoriteWithId:(NSString *)tweetId
                                       favorited:(BOOL)favorited
                                         success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;


@end
