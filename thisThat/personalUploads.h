//
//  personalUploads.h
//  thisThat
//
//  Created by James Connerton on 2014-10-29.
//  Copyright (c) 2014 James Connerton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface personalUploads : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
- (IBAction)upload:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *upload;
- (IBAction)settings:(id)sender;

- (IBAction)tapGesture:(id)sender;
@property (nonatomic, strong)  UIView *myView;
@property (strong, nonatomic)  UIView *addionalView;


@property (strong, nonatomic)  UIImageView *additionalImageViewOne;
@property (strong, nonatomic)  UIView *textView;
@property (strong, nonatomic) UILabel *textViewLabel;
@property (strong, nonatomic)  UIImageView *additionalImageViewTwo;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end
