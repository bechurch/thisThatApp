//
//  tableViewCustomCell.h
//  thisThat
//
//  Created by James Connerton on 2015-01-25.
//  Copyright (c) 2015 James Connerton. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol customCellDelegate <NSObject>
@end

@interface tableViewCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *cellTextField;
@property (weak, nonatomic) IBOutlet UIButton *uploadthisThatButton;
@property (nonatomic, strong) id<customCellDelegate> delegate;

@end
