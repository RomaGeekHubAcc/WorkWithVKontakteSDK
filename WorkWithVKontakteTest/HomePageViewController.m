//
//  HomePageViewController.m
//  WorkWithVKontakteTest
//
//  Created by Roman Rybachenko on 1/24/14.
//  Copyright (c) 2014 Roman Rybachenko. All rights reserved.
//

#import "AudioFilesViewController.h"
#import "VKSdk.h"
#import "Downloader.h"
#import "MessagesViewController.h"
#import "FriendsViewController.h"

#import "HomePageViewController.h"


@interface HomePageViewController ()
{
    __block VKUser *currentUser;
    UIView *selectedBackgroundView;
}

@property (weak, nonatomic) IBOutlet UILabel *fNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarka;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *controls;
@property (nonatomic, strong) NSArray *rowsTableView;
@property (nonatomic, strong) NSMutableArray *audioFiles;
@property (nonatomic, strong) NSArray *friends;


@end


@implementation HomePageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Home Page";
    
    selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [UIColor colorWithRed:16/255.0 green:185/255.0 blue:221/255.0 alpha:1.0];
    selectedBackgroundView.layer.masksToBounds = YES;
    
    if (!currentUser) {
        currentUser = [[VKUser alloc]init];
    }
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    if (!self.rowsTableView) {
        self.rowsTableView = [NSArray arrayWithObjects:@"Мої Друзі", @"Мої Фото", @"Мої Відеозаписи", @"Мої Аудіозаписи", @"Мої Повідомлення", @"Мо Групи", @"Мої Новини", @"Мої Налаштування", nil];
    }
    
    [self showContros:NO];
    
    _controls = [NSArray arrayWithObjects:_avatarka, _fNameLabel, _lNameLabel, _birthdayLabel, nil];
	
    
    VKRequest * callingRequest;
    callingRequest = [[VKApi users] get:@{ VK_API_FIELDS : @"uid,first_name,last_name,sex,bdate,city,country,photo_100,online,online_mobile,lists,domain,contacts, connections,education,universities,schools,can_post,can_see_all_posts,can_see_audio, can_write_private_message,status,last_seen,common_count,relation,relatives,counters" }];
	[callingRequest executeWithResultBlock: ^(VKResponse *response) {
        
//        $l("response - > %@", response.json);
        
        if ([response.json isKindOfClass:[NSArray class]] ) {
            NSArray *respAr = response.json;
            
            if (respAr.count == 1 && [[respAr firstObject] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dictResp = [respAr firstObject];
                
                currentUser.uid        = [dictResp objectForKey:@"id"];
                currentUser.first_name = [dictResp objectForKey:@"first_name"];
                currentUser.last_name  = [dictResp objectForKey:@"last_name"];
                currentUser.bdate      = [dictResp objectForKey:@"bdate"];
                currentUser.photo_100  = [dictResp objectForKey:@"photo_100"];
                currentUser.counters   = [dictResp objectForKey:@"counters"];
                
                NSInteger countAudio   = [[currentUser.counters objectForKey:@"audios"] integerValue];
                NSInteger countFriends = [[currentUser.counters objectForKey:@"friends"] integerValue];
                NSInteger countPhotos  = [[currentUser.counters objectForKey:@"photos"] integerValue];
                NSInteger countVideos  = [[currentUser.counters objectForKey:@"videos"] integerValue];
                
                self.rowsTableView = [NSArray arrayWithObjects:
                                      [NSString stringWithFormat:@"Мої Друзі (%d)", countFriends],
                                      [NSString stringWithFormat:@"Мої Фото (%d)", countPhotos],
                                      [NSString stringWithFormat:@"Мої Відеозаписи (%d)", countVideos],
                                      [NSString stringWithFormat:@"Мої Аудіозаписи (%d)", countAudio],
                                      @"Мої Повідомлення", @"Мо Групи", @"Мої Новини", @"Мої Налаштування", nil];
                [_tableView reloadData];
                [self requestGetAudio];
                [self requestGetFriends];
                
                _fNameLabel.text = currentUser.first_name;
                _lNameLabel.text = currentUser.last_name;
                _birthdayLabel.text = currentUser.bdate;
                _avatarka.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentUser.photo_100]]];
                [self showContros:YES];
            }
        }
        
        
	} errorBlock: ^(VKError *error) {
	    NSLog(@"---- ERROR -> %@", error);
	}];
    
//    currentUser = [[Downloader sharedInstance] getCurrentUser];

    
}


#pragma mark - Private methods

-(void) showContros:(BOOL)show {
    _avatarka.hidden = !show;
    _birthdayLabel.hidden = !show;
    _fNameLabel.hidden = !show;
    _lNameLabel.hidden = !show;
}

-(void) requestGetAudio {
    
    // methodName має бути audio.save    (Сохраняет аудиозаписи после успешной загрузки.)
    //                 або audio.get     (Возвращает список аудиозаписей пользователя или сообщества.)
    //                 або audio.getById (Возвращает информацию об аудиозаписях.)
    
    NSNumber *count;
    if (currentUser) {
        count = [currentUser.counters objectForKey:@"audios"];
    }

    NSDictionary *parametersRequest = @{ @"owner_id"  : currentUser.uid,
                                         @"count" : count };
    
    VKRequest *request = [VKRequest requestWithMethod:@"audio.get" andParameters:parametersRequest andHttpMethod:@"GET"];
    
    [request executeWithResultBlock: ^(VKResponse *response) {
        
//        $l(@"--- Response.json -> %@", response.json);
        
        if ([response.json isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDict = response.json;
            
            id items = [responseDict objectForKey:@"items"];
            if ([items isKindOfClass:[NSArray class]]) {
                self.audioFiles = items;
            }
        }
        
    }  errorBlock: ^(VKError *error) {
        $l(@"--- Error! - > %@", error);
    }];
}

-(void) requestGetFriends {
    
    NSDictionary *parameters = @{@"user_id" : currentUser.uid,
                                 @"fields"   : @"nickname, domain, sex, bdate, city, country, photo_100, online, relation,           last_seen, status, can_write_private_message, can_see_all_posts, can_post,"};
    
    VKRequest *friendsRequest = [[VKApi friends] get:parameters];
    
    [friendsRequest executeWithResultBlock: ^(VKResponse*response) {
        $l(@"Friends response -> %@", response.json);
        if ([[response.json objectForKey:@"items"] isKindOfClass:[NSArray class]]) {
            self.friends = [NSArray arrayWithArray:[response.json objectForKey:@"items"]];
        }
    }  errorBlock: ^(VKError *error) {
        $l(@"--- Error! - > %@", error);
    }];
    
}


#pragma mark - UITableViewDataSource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rowsTableView.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectedBackgroundView = selectedBackgroundView;
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.text = [_rowsTableView objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        FriendsViewController *friendsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsViewController"];
        friendsVC.friends = self.friends;
        [self.navigationController pushViewController:friendsVC animated:YES];
    }
    if (indexPath.row == 3) {
        AudioFilesViewController *audioFilesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AudioFilesViewController"];
        audioFilesVC.audioFiles = self.audioFiles;
        
        [self.navigationController pushViewController:audioFilesVC animated:YES];
    }
    if (indexPath.row == 4) {
        MessagesViewController *messagesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MessagesViewController"];
        [self.navigationController pushViewController:messagesVC animated:YES];
    }
}



    

@end
