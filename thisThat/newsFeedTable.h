//
//  newsFeedTable.h
//  thisThat
//
//  Created by James Connerton on 2015-01-08.
//  Copyright (c) 2015 James Connerton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newsFeedTable : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)segmentControl:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *newsFeedTableView;

@property (nonatomic, strong) NSMutableArray *worldMutableArray;
@property (nonatomic, strong) NSMutableArray *friendsMutableArray;
@end
