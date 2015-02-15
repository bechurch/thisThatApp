//
//  MainPage.h
//  thisThat
//
//  Created by James Connerton on 2015-01-21.
//  Copyright (c) 2015 James Connerton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPage : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>
//Actions
- (IBAction)settings:(id)sender;
- (IBAction)upload:(id)sender;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// newsFeed
- (IBAction)newsFeed:(id)sender;


@property (nonatomic, strong) NSMutableArray *newsFeedArray;
@property (nonatomic, strong) UIView *newsFeedView;
@property (nonatomic, strong) UIView *viewForLabels;
@property (nonatomic, strong) UIView *loadningView;
@property (nonatomic, strong) UIImageView *imageViewOneCurrent;
@property (nonatomic, strong) UIImageView *imageViewOneBehind;
@property (nonatomic, strong) UIImageView *imageViewTwoCurrent;
@property (nonatomic, strong) UIImageView *imageViewTwoBehind;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// personalPosts
- (IBAction)personalPosts:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *personalPostsButton;
@property (nonatomic, strong) NSMutableArray *personalPostsArray;
@property (nonatomic, strong) UITableView *personalPostsTableView;
@property (nonatomic, strong) UIImageView *fullSizeImageViewTableView;
//Gestures
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizerPersonalPosts;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizerNewsFeed;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizerImageOne;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizerImageTwo;
@property (nonatomic, strong) UITapGestureRecognizer *tapToOpenImageOne;
@property (nonatomic, strong) UITapGestureRecognizer *tapToOpenImageTwo;
@property (nonatomic, strong) UITapGestureRecognizer *tapToCloesImage;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressRecognizer;

//int
@property int counterPersonalPostsArray;
@property int newsFeedCounter;
@property int voteCounter;


//Labels
@property (nonatomic, strong) UILabel *textContentLabel;
@property (nonatomic, strong) UILabel *timeStampLabel;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *imageOnePercentage;
@property (nonatomic, strong) UILabel *imageTwoPercentage;


//ActivityIndicator
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

//Lines
@property (nonatomic, strong) UIView *horizontalLineLabelView;
@property (nonatomic, strong) UIView *verticalLineOneLabelView;
//
@property (nonatomic, strong) UIView *viewForFullSizeImageView;
@property (nonatomic, strong) UIImageView *fullSizeImageView;
@property (nonatomic, strong) UIImage *tempImageOneCurrent;
@property (nonatomic, strong) UIImage *tempImageOneBehind;
@property (nonatomic, strong) UIImage *tempImageTwoCurrent;
@property (nonatomic, strong) UIImage *tempImageTwoBehind;
@end
