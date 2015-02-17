//
//  User.h
//  Twitter
//
//  Created by WeiSheng Su on 2/7/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *screenName;
@property (nonatomic,strong) NSString *profileName;
@property (nonatomic,strong) NSString *bannerImage;
@property (nonatomic,strong) NSString *tagline;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *followersCount;
@property (nonatomic,strong) NSString *followingCount;
@property (nonatomic,strong) NSString *tweetsCount;


@property (nonatomic, strong) NSDictionary *dictionary;



- (id) initWithDictionary: (NSDictionary *)dictionary;
    
+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;
+ (void)logout;

@end
