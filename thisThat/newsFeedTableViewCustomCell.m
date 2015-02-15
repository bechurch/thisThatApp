//
//  newsFeedTableViewCustomCell.m
//  thisThat
//
//  Created by James Connerton on 2015-01-08.
//  Copyright (c) 2015 James Connerton. All rights reserved.
//

#import "newsFeedTableViewCustomCell.h"
@interface newsFeedTableViewCustomCell () <UIGestureRecognizerDelegate>
@end
@implementation newsFeedTableViewCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
    self.panRecognizer.delegate = self;
    [self.myContentView addGestureRecognizer:self.panRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(CGFloat)buttonRightWidth {
    return CGRectGetWidth(self.frame) - CGRectGetMinX(self.voteImageOneRight.frame);
}

-(CGFloat)buttonLeftWidth {
    return CGRectGetMaxX(self.voteImageTwoLeft.frame);
}

-(void)panThisCell:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognizer translationInView:self.myContentView];
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstant.constant;
            self.startingLeftLayoutConstraintConstant = self.contentViewLeftConstant.constant;
            
            break;
        case UIGestureRecognizerStateChanged: {
            
            CGPoint currentPoint = [recognizer translationInView:self.myContentView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            
            BOOL panningLeft = NO;
            if(currentPoint.x < self.panStartPoint.x) {
                panningLeft = YES;
            }
            
            if(self.startingRightLayoutConstraintConstant == 0 && self.startingLeftLayoutConstraintConstant == 0) {
            // The cell is initially closed and now being opened
                
                if(!panningLeft) { //panning right
                    CGFloat constantR = MAX(-deltaX, 0);
                    if(constantR == 0) {
                        [self resetRightConstraintConstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.contentViewRightConstant.constant = constantR;
                    }
                    CGFloat constantL = MIN(deltaX, [self buttonLeftWidth]);
                    if(constantL == [self buttonLeftWidth]) {
                        [self setConstraintsToShowLeftButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.contentViewLeftConstant.constant = constantL;
                    }
                }
                else { //panning left
                    CGFloat constantR = MIN(-deltaX, [self buttonRightWidth]);
                    if(constantR == [self buttonRightWidth]) {
                        [self setConstraintsToShowRightButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.contentViewRightConstant.constant = constantR;
                    }
                    CGFloat constantL = MIN(deltaX, 0);
                    if(constantL == 0) {
                        [self resetLeftConstraintConstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.contentViewLeftConstant.constant = constantL;
                    }
                }
            }
            else {
                // cell was open
                CGFloat adjustmentR = self.startingRightLayoutConstraintConstant - deltaX;
                CGFloat adjustmentL = self.startingLeftLayoutConstraintConstant + deltaX;
                if(!panningLeft){//panning right
                    CGFloat constantR = MAX(adjustmentR, 0);
                    if(constantR == 0) {
                        [self resetRightConstraintConstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.contentViewRightConstant.constant = constantR;
                    }
                    CGFloat constantL = MIN(adjustmentL, [self buttonLeftWidth]);
                    if(constantL == [self buttonLeftWidth]) {
                        [self setConstraintsToShowLeftButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.contentViewLeftConstant.constant = constantL;
                    }
                } else {//panning left
                    CGFloat constantR = MIN(adjustmentR, [self buttonRightWidth]);
                    if(constantR == [self buttonRightWidth]) {
                        [self setConstraintsToShowRightButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.contentViewRightConstant.constant = constantR;
                    }
                    CGFloat constantL = MAX(adjustmentL, 0);
                    if(constantL == 0) {
                        [self resetLeftConstraintConstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.contentViewLeftConstant.constant = constantL;
                    }
                }
            }
            self.contentViewRightConstant.constant = -self.contentViewLeftConstant.constant;
        }
            
            break;
        case UIGestureRecognizerStateEnded:
            
            if(self.startingRightLayoutConstraintConstant == 0 && self.startingLeftLayoutConstraintConstant == 0) {
                
                CGFloat halfOfButtoneOne = CGRectGetWidth(self.voteImageOneRight.frame)/2;
                CGFloat buttonOneMidX = CGRectGetMidX(self.voteImageOneRight.frame);
                CGFloat buttonTwoMidX = CGRectGetMidX(self.voteImageTwoLeft.frame);
                
                CGPoint currentPoint = [recognizer translationInView:self.myContentView];
                BOOL panningLeft = NO;
                if (currentPoint.x < self.panStartPoint.x) {
                    panningLeft = YES;
                }
                
                if(!panningLeft) { // panning right
                    if(self.contentViewLeftConstant.constant >= buttonTwoMidX) {
                        [self setConstraintsToShowLeftButtons:YES notifyDelegateDidOpen:YES];
                    } else {
                        [self resetLeftConstraintConstantsToZero:YES notifyDelegateDidClose:YES];
                    }
                }
                else { // panning left
                    
                    if(abs(self.contentViewRightConstant.constant) >=halfOfButtoneOne) {
                        [self setConstraintsToShowRightButtons:YES notifyDelegateDidOpen:YES];
                    } else {
                        [self resetRightConstraintConstantsToZero:YES notifyDelegateDidClose:YES];
                    }
                }
            }
            else {
                CGFloat buttonTwoMidX = CGRectGetMidX(self.voteImageTwoLeft.frame);
                CGPoint currentPoint = [recognizer translationInView:self.myContentView];
                BOOL panningLeft = NO;
                if(currentPoint.x < self.panStartPoint.x) {
                    panningLeft = YES;
                }
                if(!panningLeft) { //panning right
                    if(self.contentViewRightConstant.constant >= buttonTwoMidX) {
                        //re open all the way
                        [self setConstraintsToShowRightButtons:YES notifyDelegateDidOpen:YES];
                    }
                    else {//close
                        [self resetRightConstraintConstantsToZero:YES notifyDelegateDidClose:YES];
                    }
                }
                else {
                    if(self.contentViewLeftConstant.constant >= buttonTwoMidX) {
                        [self setConstraintsToShowLeftButtons:YES notifyDelegateDidOpen:YES];
                    } else {
                        [self resetLeftConstraintConstantsToZero:YES notifyDelegateDidClose:YES];
                    }
                }
            }
            break;
        case UIGestureRecognizerStateCancelled:
            if(self.startingRightLayoutConstraintConstant == 0) {
                [self resetRightConstraintConstantsToZero:YES notifyDelegateDidClose:YES];
            } else {
                [self setConstraintsToShowRightButtons:YES notifyDelegateDidOpen:YES];
            }
            if(self.startingLeftLayoutConstraintConstant == 0) {
                [self resetLeftConstraintConstantsToZero:YES notifyDelegateDidClose:YES];
            } else {
                [self setConstraintsToShowLeftButtons:YES notifyDelegateDidOpen:YES];
            }
            
            break;
        default:
            break;
    }
}

-(void)resetRightConstraintConstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)notiftyDelegate {
    
    if(notiftyDelegate) {
        [self.delegate cellDidClose:self];
    }
    if(self.startingRightLayoutConstraintConstant == 0 && self.contentViewRightConstant.constant ==0) {
        return;
    }
    self.contentViewRightConstant.constant = 0;
    self.contentViewLeftConstant.constant = 0;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.contentViewRightConstant.constant = 0;
        self.contentViewLeftConstant.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstant.constant;
        }];
    }];
  
}

-(void)setConstraintsToShowRightButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate {
    
    if(notifyDelegate) {
        [self.delegate cellDidOpen:self];
    }
    
    if(self.startingRightLayoutConstraintConstant == [self buttonRightWidth] && self.contentViewRightConstant.constant == [self buttonRightWidth]) {
        return;
    }
    self.contentViewLeftConstant.constant = -[self buttonRightWidth];
    self.contentViewRightConstant.constant = [self buttonRightWidth];
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.contentViewLeftConstant.constant = -[self buttonRightWidth];
        self.contentViewRightConstant.constant = [self buttonRightWidth];
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstant.constant;
        }];
    }];
    
}

-(void)resetLeftConstraintConstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)notifyDelegate {
    if(self.startingLeftLayoutConstraintConstant == 0 && self.contentViewLeftConstant.constant == 0) {
        return;
    }
    self.contentViewLeftConstant.constant = 0;
    self.contentViewRightConstant.constant = 0;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.contentViewRightConstant.constant = 0;
        self.contentViewLeftConstant.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingLeftLayoutConstraintConstant = self.contentViewLeftConstant.constant;
        }];
    }];
}

-(void)setConstraintsToShowLeftButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate {
    
    if(self.startingLeftLayoutConstraintConstant == [self buttonLeftWidth] && self.contentViewLeftConstant.constant == [self buttonLeftWidth]) {
        return;
    }
    self.contentViewRightConstant.constant = - [self buttonLeftWidth];
    self.contentViewLeftConstant.constant = [self buttonLeftWidth];
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.contentViewRightConstant.constant = -[self buttonLeftWidth];
        self.contentViewLeftConstant.constant = [self buttonLeftWidth];
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingLeftLayoutConstraintConstant = self.contentViewLeftConstant.constant;
        }];
    }];
    
    
}
-(void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    float duration = 0;
    if(animated) {
        duration = 0.1;
    }
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return  YES;
}
-(void)prepareForReuse {
    [super prepareForReuse];
    [self resetRightConstraintConstantsToZero:NO notifyDelegateDidClose:NO];
    [self resetLeftConstraintConstantsToZero:NO notifyDelegateDidClose:NO];
}
-(void)openCell {
    [self setConstraintsToShowRightButtons:NO notifyDelegateDidOpen:NO];
    [self setConstraintsToShowLeftButtons:NO notifyDelegateDidOpen:NO];
}
@end
