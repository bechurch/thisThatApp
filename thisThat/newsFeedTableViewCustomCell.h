//
//  newsFeedTableViewCustomCell.h
//  thisThat
//
//  Created by James Connerton on 2015-01-08.
//  Copyright (c) 2015 James Connerton. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SwipeableCellDelegate <NSObject>
-(void)cellDidOpen:(UITableViewCell *)cell;
-(void)cellDidClose:(UITableViewCell *)cell;
@end

@interface newsFeedTableViewCustomCell : UITableViewCell <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *voteImageOneRight;
@property (weak, nonatomic) IBOutlet UIButton *voteImageTwoLeft;
@property (weak, nonatomic) IBOutlet UIButton *skipPostLeft;
@property (weak, nonatomic) IBOutlet UIButton *skipPostRight;
@property (weak, nonatomic) IBOutlet UILabel *labelCellCount;


@property (weak, nonatomic) IBOutlet UIView *myContentView;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, assign) CGFloat startingLeftLayoutConstraintConstant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstant;
@property (nonatomic, weak) id <SwipeableCellDelegate> delegate;

@end
