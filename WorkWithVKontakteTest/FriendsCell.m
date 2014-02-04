//
//  FriendsCell.m
//  WorkWithVKontakteTest
//
//  Created by Roman Rybachenko on 1/30/14.
//  Copyright (c) 2014 Roman Rybachenko. All rights reserved.
//

#import "FriendsCell.h"

@implementation FriendsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)writeMessage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(writeMessagePressedInCellwithTag:)]) {
        [self.delegate writeMessagePressedInCellwithTag:self.tag];
    }
}

- (IBAction)deleteFromFriends:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteFromFiendsPressedInCellwithTag:)]) {
        [self.delegate deleteFromFiendsPressedInCellwithTag:self.tag];
    }
}
@end
