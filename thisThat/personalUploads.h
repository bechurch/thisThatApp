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
@property (weak, nonatomic) IBOutlet UIButton *upload;
- (IBAction)settings:(id)sender;

- (IBAction)tapGesture:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *addionalView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@property (weak, nonatomic) IBOutlet UIImageView *additionalImageViewOne;




@property (weak, nonatomic) IBOutlet UIImageView *additionalImageViewTwo;
@end
