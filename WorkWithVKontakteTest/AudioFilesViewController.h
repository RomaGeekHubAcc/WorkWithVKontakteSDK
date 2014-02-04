//
//  AudioFilesViewController.h
//  WorkWithVKontakteTest
//
//  Created by Roman Rybachenko on 1/28/14.
//  Copyright (c) 2014 Roman Rybachenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioFilesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *audioFiles;

@end
