//
//  FriendsViewController.m
//  WorkWithVKontakteTest
//
//  Created by Roman Rybachenko on 1/29/14.
//  Copyright (c) 2014 Roman Rybachenko. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "FriendsCell.h"
#import "MessagesViewController.h"

#import "FriendsViewController.h"


@interface FriendsViewController ()


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation FriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = [NSString stringWithFormat:@"My Friends (%d)", self.friends.count];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}


#pragma mark - UITableViewDataSource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellFriends = @"cellFriends";
    
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellFriends forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    NSDictionary *friendInfo = [self.friends objectAtIndex:indexPath.row];
    
    cell.firstNameLabel.text = [friendInfo objectForKey:@"first_name"];
    cell.lastNameLabel.text  = [friendInfo objectForKey:@"last_name"];
    cell.onlineLabel.text    = [self getStringOrOnlineFriend:friendInfo];
    [cell.friendPhoto setImageWithURL:[NSURL URLWithString:[friendInfo objectForKey:@"photo_100"]]];
    
    return cell;
}

#pragma mark - Private methods

-(NSString*) getStringOrOnlineFriend:(NSDictionary*)friendInfo {
    NSInteger online = [[friendInfo objectForKey:@"online"] integerValue];
    if (online) {
        return @"online";
    }
    return @"offline";
}


#pragma mark - Protocol methods

-(void) writeMessagePressedInCellwithTag:(NSInteger)tag {
    $l(@"Write message button pressed in cell - %d", tag);
    
    MessagesViewController *messageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MessagesViewController"];
    messageVC.friendInfo = [self.friends objectAtIndex:tag];
    
    [self.navigationController presentViewController:messageVC animated:YES completion:nil];
}

-(void) deleteFromFiendsPressedInCellwithTag:(NSInteger)tag {
    $l(@"Delete from friends pressed in cell - %d", tag);
}


@end
