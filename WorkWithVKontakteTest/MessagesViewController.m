//
//  MessagesViewController.m
//  WorkWithVKontakteTest
//
//  Created by Roman Rybachenko on 1/29/14.
//  Copyright (c) 2014 Roman Rybachenko. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "VKSdk.h"

#import "MessagesViewController.h"


@interface MessagesViewController ()

@end


@implementation MessagesViewController

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
	
    self.title = @"My messages";
    
    _messageTextView.delegate = self;
    _messageTextView.returnKeyType = UIReturnKeyDone;
    
    
    [self.friendPhoto setImageWithURL:[NSURL URLWithString:[_friendInfo objectForKey:@"photo_100"]]];
    self.friendNameLabel.text = [NSString stringWithFormat:@"%@ %@", [_friendInfo objectForKey:@"first_name"], [_friendInfo objectForKey:@"last_name"]];
    self.orOnlineLabel.text = [self getStringOrOnlineFriend:_friendInfo];
//    [self prefersStatusBarHidden];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}


#pragma mark - Action methods

- (IBAction)send:(id)sender {
    [self getStringOrOnlineFriend:self.friendInfo];
    
    [self sendMessage];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private methods

-(NSString*) getStringOrOnlineFriend:(NSDictionary*)friendInfo {
    NSInteger online = [[friendInfo objectForKey:@"online"] integerValue];
    if (online) {
        return @"online";
    }
    return @"offline";
}

-(void) sendMessage {
    NSDictionary *parameters = @{@"user_id"  : [_friendInfo objectForKey:@"id"],
                                 @"message" : _messageTextView.text,
                                 @"v"        : @(5.7)};
    
    VKRequest *sendMessageRequest = [VKRequest requestWithMethod:@"messages.send" andParameters:parameters andHttpMethod:@"POST"];
    [sendMessageRequest executeWithResultBlock:^(VKResponse *response) {
        $l(@"--- Response.json -> %@", response.json);
    } errorBlock:^(VKError *error) {
        NSLog(@"Error - %@", error);
        $l(@"Error! - > %@", error);
    }];
}


@end
