//
//  personalPostsTableViewCell.h
//  thisThat
//
//  Created by James Connerton on 2015-02-11.
//  Copyright (c) 2015 James Connerton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface personalPostsTableViewCell : UITableViewCell <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UILabel *textContent;
@property (nonatomic, strong) UILabel *username;
@property (nonatomic, strong) UILabel *timeStamp;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *totalVotesLabel;
@property (nonatomic, strong) UIImageView *imageViewOne;
@property (nonatomic, strong) UIImageView *imageViewTwo;
@property (nonatomic, strong) UIImage *tempImageOne;
@property (nonatomic , strong) UIImage *tempImageTwo;
@property (nonatomic, strong) UIActivityIndicatorView *spinnerImageViewOne;
@property (nonatomic, strong) UIActivityIndicatorView *spinnerImageViewTwo;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureImageViewOne;
@property (nonatomic, strong) UILabel *votePercentageOneLabel;
@property (nonatomic, strong) UILabel *votePercentageTwoLabel;
@property (nonatomic, strong) UIImageView *checkMarkImageView;
@property (nonatomic, strong) UIImageView *xMarkImageView;

@end
