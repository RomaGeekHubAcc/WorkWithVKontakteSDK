//
//  FriendsCell.h
//  WorkWithVKontakteTest
//
//  Created by Roman Rybachenko on 1/30/14.
//  Copyright (c) 2014 Roman Rybachenko. All rights reserved.
//


@protocol ButtonsOnFriendsCellDelegate <NSObject>

-(void) writeMessagePressedInCellwithTag:(NSInteger)tag;
-(void) deleteFromFiendsPressedInCellwithTag:(NSInteger)tag;

@end


@interface FriendsCell : UITableViewCell

@property (weak) id <ButtonsOnFriendsCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *friendPhoto;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;

- (IBAction)writeMessage:(id)sender;
- (IBAction)deleteFromFriends:(id)sender;

@end
