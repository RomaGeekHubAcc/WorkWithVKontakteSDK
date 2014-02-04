//
//  Downloader.h
//  WorkWithVKontakteTest
//
//  Created by Roman Rybachenko on 1/28/14.
//  Copyright (c) 2014 Roman Rybachenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Downloader : NSObject

+(Downloader*) sharedInstance;

-(VKUser *) getCurrentUser;

@end
