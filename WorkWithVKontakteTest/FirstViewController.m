//
//  FirstViewController.m
//  WorkWithVKontakteTest
//
//  Created by Roman Rybachenko on 1/22/14.
//  Copyright (c) 2014 Roman Rybachenko. All rights reserved.
//

#define TOKEN_KEY                @"okapitanmoykapitan"//@"nJmfTzLCZlxGfW0speCW"
#define NEXT_CONTROLLER_SEGUE_ID @"START_WORK"
#define APP_ID                   @"4136691"


#import "HomePageViewController.h"

#import "FirstViewController.h"



@interface FirstViewController ()

@end


@implementation FirstViewController


-(void) viewDidLoad
{
    [super viewDidLoad];
	
    
    [VKSdk initializeWithDelegate:self andAppId:APP_ID andCustomToken:[VKAccessToken tokenFromDefaults:TOKEN_KEY]];
}


#pragma mark - Action methods

-(IBAction) autorization:(id)sender {

    [VKSdk authorize:@[VK_PER_NOTIFY, VK_PER_FRIENDS, VK_PER_PHOTOS, VK_PER_AUDIO,VK_PER_STATUS, VK_PER_WALL, VK_PER_GROUPS,VK_PER_MESSAGES, VK_PER_NOTIFICATIONS]];
}


#pragma mark -VKSdkDelegate

-(void) vkSdkNeedCaptchaEnter:(VKError *)captchaError {
	VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
	[vc presentIn:self];
}

-(void) vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
	[self autorization:nil];
}

-(void) vkSdkUserDeniedAccess:(VKError *)authorizationError {
	[[[UIAlertView alloc] initWithTitle:nil message:@"Access denied" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

-(void) vkSdkShouldPresentViewController:(UIViewController *)controller {
	[self presentViewController:controller animated:YES completion:nil];
}

-(void) vkSdkDidReceiveNewToken:(VKAccessToken *)newToken {
	[newToken saveTokenToDefaults:TOKEN_KEY];

    HomePageViewController *homePageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomePageViewController"];
    [self.navigationController pushViewController:homePageVC animated:YES];
}

-(void) vkSdkDidAcceptUserToken:(VKAccessToken *)token {

    HomePageViewController *homePageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomePageViewController"];
    [self.navigationController pushViewController:homePageVC animated:YES];
}


@end
