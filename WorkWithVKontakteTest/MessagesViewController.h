//
//  MessagesViewController.h
//  WorkWithVKontakteTest
//
//  Created by Roman Rybachenko on 1/29/14.
//  Copyright (c) 2014 Roman Rybachenko. All rights reserved.
//



@interface MessagesViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *friendPhoto;
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orOnlineLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property (nonatomic, strong) NSDictionary *friendInfo;


- (IBAction)send:(id)sender;
- (IBAction)cancel:(id)sender;

@end
