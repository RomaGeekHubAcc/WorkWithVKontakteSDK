//
//  Player.h
//  WorkWithVKontakteTest
//
//  Created by Roman Rybachenko on 1/28/14.
//  Copyright (c) 2014 Roman Rybachenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) float duration;


+(instancetype) sharedPlayer;

-(void) playWithStringPath:(NSString *)url;
-(BOOL) playerCreated;
-(float) rate;
-(void) pause;
-(void) stop;
-(void) playCurrentAudioTrack;
-(float) currentTime;
-(void) seekToTime:(CMTime)sliderValueTime;

@end
