//
//  personal.h
//  thisThat
//
//  Created by James Connerton on 2015-01-15.
//  Copyright (c) 2015 James Connerton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface personal : UITableViewController <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) UIImageView *additionalImageViewOne;
@property (nonatomic, strong) UIImageView *additionalImageViewTwo;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
- (IBAction)upload:(id)sender;
- (IBAction)settings:(id)sender;

@end
