//
//  Downloader.m
//  WorkWithVKontakteTest
//
//  Created by Roman Rybachenko on 1/28/14.
//  Copyright (c) 2014 Roman Rybachenko. All rights reserved.
//

#import "Downloader.h"


@interface Downloader ()
{
    __block VKUser *currentUser;
}

@end


@implementation Downloader


#pragma mark - Allocators

+(Downloader*) sharedInstance {
    
    static Downloader *__sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[Downloader alloc] init];
    });
    return __sharedInstance;
}



#pragma mark - Public methods

-(void) downloadUser {
    
    if (!currentUser) {
        currentUser = [[VKUser alloc]init];
    }
    
    VKRequest *callingRequest = [[VKApi users] get:@{ VK_API_FIELDS : @"uid,first_name,last_name,sex,bdate,city,country,photo_100,online,online_mobile,lists,domain,contacts, connections,education,universities,schools,can_post,can_see_all_posts,can_see_audio, can_write_private_message,status,last_seen,common_count,relation,relatives,counters" }];
    
	[callingRequest executeWithResultBlock: ^(VKResponse *response) {
        
        
        $l(@"response.json- > %@", response.json);
        if ([response.json isKindOfClass:[NSArray class]] ) {
            NSArray *respAr = response.json;
            
            if (respAr.count == 1 && [[respAr firstObject] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dictResp = [respAr firstObject];
                
                currentUser.first_name = [dictResp objectForKey:@"first_name"];
                currentUser.last_name  = [dictResp objectForKey:@"last_name"];
                currentUser.bdate      = [dictResp objectForKey:@"bdate"];
                currentUser.photo_100  = [dictResp objectForKey:@"photo_100"];
                
                currentUser.counters = [dictResp objectForKey:@"counters"];
                
                
            }
        }
        
	} errorBlock: ^(VKError *error) {
	    NSLog(@"---- ERROR -> %@", error);
	}];
}

-(VKUser *) getCurrentUser {
    
    [self downloadUser];
    
    return currentUser;
}

@end
