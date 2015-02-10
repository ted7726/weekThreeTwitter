//
//  User.m
//  Twitter
//
//  Created by WeiSheng Su on 2/7/15.
//  Copyright (c) 2015 Wilson Su. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"
@implementation User
static User * _currentUser = nil;
NSString * const UserDidLoginNotification =  @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";


- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileName = dictionary[@"profile_image_url"];
        self.tagline = dictionary[@"description"];
        
    }

    return self;
}

NSString * const kCurrentUserKey = @"kCurrentUserKey";


+ (User *)currentUser{
    if(_currentUser == nil){
        NSData *data =[[NSUserDefaults standardUserDefaults]objectForKey:kCurrentUserKey];
        if(data !=nil){
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
        
    }
    return _currentUser;
}
+ (void) setCurrentUser:(User *)currentUser{
    _currentUser = currentUser;
    
    if(_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (void)logout{
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
}

@end
