//
//  ResponseContentViewController.h
//  SampleAppClient
//
//  Created by James Wang on 1/17/14.
//  Copyright (c) 2014 James Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResponseContentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *contents;

@end