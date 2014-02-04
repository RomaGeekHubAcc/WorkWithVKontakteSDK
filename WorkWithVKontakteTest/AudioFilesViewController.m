//
//  AudioFilesViewController.m
//  WorkWithVKontakteTest
//
//  Created by Roman Rybachenko on 1/28/14.
//  Copyright (c) 2014 Roman Rybachenko. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "AudioFilesCell.h"
#import "Player.h"

#import "AudioFilesViewController.h"



@interface AudioFilesViewController ()
{
    NSTimer *timer;
    NSDictionary *currentTrackDict;
    NSInteger currentTrackIndex;
    UIView *selectedBackgroundView;
    BOOL orRandomPlaying;
    UIColor *backgroundColor;
    UIColor *selectedBackgroundColor;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *playingTitlelabel;
@property (weak, nonatomic) IBOutlet UISlider *sliderOutlet;
@property (weak, nonatomic) IBOutlet UISegmentedControl *loopRandomOutlet;


- (IBAction)slider:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)nextTrack:(id)sender;
- (IBAction)previousTrack:(id)sender;
- (IBAction)loopRandomControl:(id)sender;

@end


@implementation AudioFilesViewController

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
	
    self.title = @"Pleyer";
    
    currentTrackIndex = 0;
    
    _loopRandomOutlet.selectedSegmentIndex = 0;
    
    backgroundColor = self.view.backgroundColor;
    selectedBackgroundColor = [UIColor colorWithRed:16/255.0 green:185/255.0 blue:221/255.0 alpha:1.0];
    
    selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = selectedBackgroundColor;
    selectedBackgroundView.layer.masksToBounds = YES;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    _sliderOutlet.minimumValue = 0;
    [_sliderOutlet setValue:0];
}


#pragma mark - UITableViewDataSource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.audioFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellAudioFiles = @"audioFilesCell";
    
    AudioFilesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellAudioFiles forIndexPath:indexPath];
    
    cell.mytitleLabel.textColor  = [UIColor whiteColor];
    cell.durationLabel.textColor = [UIColor whiteColor];
    
    cell.selectedBackgroundView = selectedBackgroundView;
    
    NSDictionary *audioFileDict = [self.audioFiles objectAtIndex:indexPath.row];
    
    cell.mytitleLabel.text = [NSString stringWithFormat:@"%@ - %@",[audioFileDict objectForKey:@"artist"], [audioFileDict objectForKey:@"title"]];
    cell.durationLabel.text = [self convertTime:[[audioFileDict objectForKey:@"duration"] integerValue]];
    
    return cell;
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[Player sharedPlayer] stop];
    [self recreateTimer];
    
    currentTrackDict = [self.audioFiles objectAtIndex:indexPath.row];
    currentTrackIndex = indexPath.row;
    NSString *audioTrackURL = [currentTrackDict objectForKey:@"url"];
    
    [[Player sharedPlayer] playWithStringPath:audioTrackURL];
    
    _playingTitlelabel.text = [NSString stringWithFormat:@"%@ - %@",[currentTrackDict objectForKey:@"artist"], [currentTrackDict objectForKey:@"title"]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == currentTrackIndex) {
        cell.backgroundColor = selectedBackgroundColor;
    }
    else {
        cell.backgroundColor = backgroundColor;
    }
}



#pragma mark - Private methods

-(NSString*)convertTime:(NSUInteger)time{
    
    int h = floor(time / 3600);
    int min = floor(time % 3600 / 60);
    int sec = floor(time % 3600 % 60);
    
    NSString *strH = h >= 10 ? [NSString stringWithFormat:@"%d", h] : [NSString stringWithFormat:@"0%d", h];
    NSString *strMin = min >= 10 ? [NSString stringWithFormat:@"%d", min] : [NSString stringWithFormat:@"0%d", min];
    NSString *strSec = sec >= 10 ? [NSString stringWithFormat:@"%d", sec] : [NSString stringWithFormat:@"0%d", sec];
    
    if ( !h ) {
        return [NSString stringWithFormat:@"%@:%@", strMin, strSec];
    }
    
    return [NSString stringWithFormat:@"%@:%@:%@",strH, strMin, strSec];
}

- (void)showCurrentTimeChanging {
    
    float duration = [[currentTrackDict objectForKey:@"duration"] floatValue];
    float currentTime = [[Player sharedPlayer] currentTime];
    
#warning спитати, як тут краще зробити. Зараз по закінченні трека тут викликається метод [self nextTrack:nil];
    if (duration <= currentTime) {
        [self nextTrack:nil];
    }
    
    _sliderOutlet.maximumValue = duration;
    [_sliderOutlet setValue:currentTime animated:YES];
    
    _durationLabel.text = [NSString stringWithFormat:@"%@   %@", [self convertTime:currentTime], [self convertTime:duration]];
}

-(void) recreateTimer {
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showCurrentTimeChanging) userInfo:nil repeats:YES];
}


#pragma mark - Action methods

- (IBAction)slider:(id)sender {
    CMTime sliderValueTime = CMTimeMakeWithSeconds(_sliderOutlet.value, 600);
    [[Player sharedPlayer] seekToTime:sliderValueTime];
}

- (IBAction)playPause:(id)sender {
    
    if (![[Player sharedPlayer] playerCreated]) {
        [self recreateTimer];
        
        currentTrackDict = [self.audioFiles firstObject];
        currentTrackIndex = 0;
        _playingTitlelabel.text = [NSString stringWithFormat:@"%@ - %@",[currentTrackDict objectForKey:@"artist"], [currentTrackDict objectForKey:@"title"]];
        NSString *url = [currentTrackDict objectForKey:@"url"];
        [[Player sharedPlayer] playWithStringPath:url];
    }
    
    
    if ([[Player sharedPlayer] rate] == 1.0) {
        [[Player sharedPlayer] pause];
    }
    else {
        [[Player sharedPlayer] playCurrentAudioTrack];
    }
}

- (IBAction)nextTrack:(id)sender {
    [[Player sharedPlayer] stop];
    [self recreateTimer];
    
    if (!orRandomPlaying) {
        if (currentTrackIndex == self.audioFiles.count - 1) {
            currentTrackIndex = 0;
            currentTrackDict = [self.audioFiles firstObject];
            NSString *audioTrackURL = [currentTrackDict objectForKey:@"url"];
            [[Player sharedPlayer] playWithStringPath:audioTrackURL];
        }
        else {
            currentTrackIndex++;
            currentTrackDict = [self.audioFiles objectAtIndex:currentTrackIndex];
            NSString *audioTrackURL = [currentTrackDict objectForKey:@"url"];
            [[Player sharedPlayer] playWithStringPath:audioTrackURL];
        }
    }
    else {
        currentTrackIndex = arc4random()%_audioFiles.count;
        currentTrackDict = [self.audioFiles objectAtIndex:currentTrackIndex];
        NSString *audioTrackURL = [currentTrackDict objectForKey:@"url"];
        [[Player sharedPlayer] playWithStringPath:audioTrackURL];
    }
    _playingTitlelabel.text = [NSString stringWithFormat:@"%@ - %@",[currentTrackDict objectForKey:@"artist"], [currentTrackDict objectForKey:@"title"]];
    
    NSIndexPath* indPath = [NSIndexPath indexPathForRow:currentTrackIndex inSection:0];
    [self.tableView scrollToRowAtIndexPath:indPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (IBAction)previousTrack:(id)sender {
    [[Player sharedPlayer] stop];
    [self recreateTimer];
    
    if (currentTrackIndex == 0) {
        currentTrackIndex = _audioFiles.count - 1;
        currentTrackDict = [self.audioFiles objectAtIndex:currentTrackIndex];
        NSString *audioTrackURL = [currentTrackDict objectForKey:@"url"];
        [[Player sharedPlayer] playWithStringPath:audioTrackURL];
    }
    else {
        currentTrackIndex--;
        currentTrackDict = [self.audioFiles objectAtIndex:currentTrackIndex];
        NSString *audioTrackURL = [currentTrackDict objectForKey:@"url"];
        [[Player sharedPlayer] playWithStringPath:audioTrackURL];
    }
    _playingTitlelabel.text = [NSString stringWithFormat:@"%@ - %@",[currentTrackDict objectForKey:@"artist"], [currentTrackDict objectForKey:@"title"]];
}

- (IBAction)loopRandomControl:(id)sender {
    if (_loopRandomOutlet.selectedSegmentIndex == 1) {
        orRandomPlaying = YES;
    }
    else {
        orRandomPlaying = NO;
    }
}


@end
