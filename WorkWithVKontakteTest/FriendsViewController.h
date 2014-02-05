//
//  FriendsViewController.h
//  WorkWithVKontakteTest
//
//  Created by Roman Rybachenko on 1/29/14.
//  Copyright (c) 2014 Roman Rybachenko. All rights reserved.
//


#import "FriendsCell.h"


@interface FriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, ButtonsOnFriendsCellDelegate>




@property (nonatomic, strong) NSArray *friends;

@end
