//
//  personalUploads.h
//  thisThat
//
//  Created by James Connerton on 2014-10-29.
//  Copyright (c) 2014 James Connerton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface personalUploads : UIViewController <UITableViewDelegate, UITableViewDataSource>
- (IBAction)upload:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *upload;
- (IBAction)settings:(id)sender;



@end
