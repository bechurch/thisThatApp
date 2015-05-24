//
//  MainPage.h
//  thisThat
//
//  Created by James Connerton on 2015-01-21.
//  Copyright (c) 2015 James Connerton. All rights reserved.
//




#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>

@interface MainPage : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UIAlertViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
//Actions
- (IBAction)settings:(id)sender;
- (IBAction)upload:(id)sender;

//firstLaunch

@property (nonatomic, strong) UIView *firstLaunchView;
@property (nonatomic, strong) UIScrollView *firstLaunchScrollView;
//settings

@property (nonatomic, strong) UIButton *exitFirstViewButton;
@property int exitFirstViewCounter;
@property (nonatomic, strong) UIButton *exitSecondViewButton;
@property int exitSecondViewCounter;
@property (nonatomic, strong) UIPanGestureRecognizer *exitAnyViewButtonPanGesture;
@property (nonatomic, strong) UIView *settingsView;
@property (nonatomic, strong) UIView *settingsInstructionsView;
@property (nonatomic, strong) UIScrollView *settingsInstructionViewScrollView;
@property (nonatomic, strong) UITableView *settingsTableview;
@property (nonatomic, strong) NSArray *settingsSection0LabelArray;
@property (nonatomic, strong) NSArray *settingsSection1LabelArray;
@property (nonatomic, strong) NSArray *settingsSection2LabelArray;
@property (nonatomic, strong) NSArray *settingsSection3LabelArray;
@property (nonatomic, strong) NSArray *settingsSection4LaeblArray;
@property (nonatomic, strong) NSArray *twitterIntstagramImagesArray;
@property (nonatomic, strong) UINavigationBar *settingsNavigationBar;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizerSettingsView;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizerInstructionsView;

//main page


@property (nonatomic, strong) UIButton *feedImageButton;
@property (nonatomic, strong) UIButton *feedButton;
@property (nonatomic, strong) UIButton *personalImageButton;
@property (nonatomic, strong) UIButton *personalButton;
@property (nonatomic, strong) UIButton *votedImageButton;
@property (nonatomic, strong) UIButton *votedButton;

/////////////////////////////////////////////////////////////////////////////////////////////////////
// newsFeed

@property (nonatomic, strong) NSMutableArray *newsFeedArray;
@property (nonatomic, strong) UIView *newsFeedView;
@property (nonatomic, strong) UIView *newsFeedViewForLabels;
@property (nonatomic, strong) UIView *newsFeedViewForFullSizeImageView;
@property (nonatomic, strong) UIImageView *newsFeedImageViewOne;
@property (nonatomic, strong) UIImageView *newsFeedImageViewTwo;
@property (nonatomic, strong) UIImageView *newsFeedImageOneCheckMarkView;
@property (nonatomic, strong) UIImageView *newsFeedImageOneXMarkView;
@property (nonatomic, strong) UIImageView *newsFeedImageTwoCheckMarkView;
@property (nonatomic, strong) UIImageView *newsFeedImageTwoXMarkView;
@property (nonatomic, strong) UIImageView *newsFeedVoteForThisImageView;
@property (nonatomic, strong) UIImageView *newsFeedVoteForThatImageView;
@property (nonatomic, strong) UIImageView *newsFeedNotThatImageView;
@property (nonatomic, strong) UIImageView *newsFeedNotThisImageView;
@property (nonatomic, strong) UIImageView *newsFeedFullSizeImageView;
@property (nonatomic, strong) UIImage *newsFeedTempImageOne;
@property (nonatomic, strong) UIImage *newsFeedTempImageTwo;
@property (nonatomic, strong) NSMutableDictionary *newsFeedImageOneDictionary;
@property (nonatomic, strong) NSMutableDictionary *newsFeedImageTwoDictionary;
@property (nonatomic, strong) UITapGestureRecognizer *newsFeedTapGestureToCloseFullSizeImageView;
@property (nonatomic, strong) UITapGestureRecognizer *newsFeedTapGestureToOpenImageViewOne;
@property (nonatomic, strong) UITapGestureRecognizer *newsFeedTapGestureToOpenImageViewTwo;
//@property (nonatomic, strong) UITapGestureRecognizer *newsFeedTapGestureCloseImage
@property (nonatomic, strong) UIPanGestureRecognizer *newsFeedPanGestureImageViewOne;
@property (nonatomic, strong) UIPanGestureRecognizer *newsFeedPanGestureImageViewTwo;
@property (nonatomic, strong) UIPanGestureRecognizer *newsFeedPanToZoomInOnFullSizeImageView;
@property (nonatomic, strong) UIPinchGestureRecognizer *newsFeedPinchGesture;
@property (nonatomic, strong) UILabel *newsFeedTextContentLabel;
@property (nonatomic, strong) UILabel *newsFeedTimeStampLabel;
@property (nonatomic, strong) UILabel *newsFeedUsernameLabel;
@property (nonatomic, strong) UILabel *newsFeedTotalNumberOfVotesLabel;
@property (nonatomic, strong) UILabel *newsFeedLocationLabel;
@property (nonatomic, strong) UILabel *newsFeedImageViewOnePercentageLabel;
@property (nonatomic, strong) UILabel *newsFeedImageViewTwoPercentageLabel;
@property (nonatomic, strong) UIButton *newsFeedBlueMenuButton;
@property (nonatomic, strong) UIButton *newsFeedCloseViewButton;
@property int newsFeedCounter;
@property int initalizeNewsFeedCounterSecondRetrevial;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// personalPosts


@property (nonatomic, strong) NSMutableArray *personalPostsArray;
@property (nonatomic, strong) UITableView *personalPostsTableView;
@property (nonatomic, strong) UIView *personalPostsViewForImageViews;
@property (nonatomic, strong) UIView *personalPostsViewForFullSizeImageView;
@property (nonatomic, strong) UIImageView *personalPostsImageViewOne;
@property (nonatomic, strong) UIImageView *personalPostsImageViewTwo;
@property (nonatomic, strong) UIImageView *personalPostsFullSizeImageView;
@property (nonatomic, strong) UIPinchGestureRecognizer *personalPostsPinchGestureImageViews;
@property (nonatomic, strong) UIPinchGestureRecognizer *personalPostsPinchGesture;
@property (nonatomic, strong) UITapGestureRecognizer *personalPostsTapGestureToOpenImageViewOne;
@property (nonatomic, strong) UITapGestureRecognizer *personalPostsTapGestureToOpenImageViewTwo;
@property (nonatomic, strong) UITapGestureRecognizer *personalPostsTapGestureToCloseFullSizeImageView;
@property (nonatomic, strong) UIPanGestureRecognizer *personalPostsPanToZoomInOnFullSizeImageView;
@property (nonatomic, strong) NSIndexPath *personalPostsIndexPath;
@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, strong) UIView *swagViewForReal;



//int
@property int voteCounter;
//ActivityIndicator
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UIView *invisibleView;
@property (nonatomic, strong) UIView *invisibleView2;
@property (nonatomic, strong) UIView *invisibleViewTableView;


//uploadPost
@property (nonatomic, strong) UIView *uploadPostView;
@property (nonatomic, strong) UIView *uploadPostExampleTableViewCellView;
@property (nonatomic, strong) UIView *uploadPostNavigationBarUploadView;
@property (nonatomic, strong) UIView *uploadPostViewForImageViews;
@property (nonatomic, strong) UIView *uploadPostViewForFullSizeImageView;
@property (nonatomic, strong) UIView *uploadPostSlideToUploadView;
@property (nonatomic, strong) UIView *uploadPostPreviewViewForLabels;
@property (nonatomic, strong) UIView *uploadPostAddPhotoBackgroundView;
@property (nonatomic, strong) UIView *uploadPostViewTypeOfPhotoMenu;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *uploadPostTempImageOne;
@property (nonatomic, strong) UIImage *uploadPostTempImageTwo;
@property (nonatomic, strong) UIImageView *uploadPostImageViewOne;
@property (nonatomic, strong) UIImageView *uploadPostImageViewTwo;
@property (nonatomic, strong) UIImageView *uploadFullSizeImageView;
@property (nonatomic, strong) UIImageView *uploadPostNavigationBarUploadImageView;
@property (nonatomic, strong) UIPinchGestureRecognizer *uploadPostPinchGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *uploadPostPinchGestureImageViews;
@property (nonatomic, strong) UITapGestureRecognizer *uploadPostTapGestureToOpenImageViewOne;
@property (nonatomic, strong) UITapGestureRecognizer *uploadPostTapGestureToOpenImageViewTwo;
@property (nonatomic, strong) UITapGestureRecognizer *uploadCloseFullSizeImageView;
@property (nonatomic, strong) UITapGestureRecognizer *uploadPostTapGestureToCloseKeyboard;
@property (nonatomic, strong) UITapGestureRecognizer *uploadPostTapGestureToCloseTypeOfPhotoMenu;
@property (nonatomic, strong) UIPanGestureRecognizer *uploadPostPanGestureSlideToUploadView;
@property (nonatomic, strong) UIPanGestureRecognizer *uploadPostPanToZoomInOnFullSizeImageView;
@property (nonatomic, strong) UIButton *uploadPostCameraButtonOne;
@property (nonatomic, strong) UIButton *uploadPostCameraButtonTwo;
@property (nonatomic, strong) UIButton *uploadPostTakePhotoButton;
@property (nonatomic, strong) UIButton *uploadPostPhotoLibraryButton;
@property (nonatomic, strong) UIButton *uploadPostNavigationBarRetryUploadButton;
@property (nonatomic, strong) UIButton *uploadPostNavigationBarDeleteUploadButton;
@property (nonatomic, strong) UIButton *uploadPostPreviewButton;
@property (nonatomic, strong) UIButton *uploadPostLibraryPhotosButton;
@property (nonatomic, strong) UIButton *uploadPostBlueMenuButton;
@property (nonatomic, strong) UIButton *uploadPostButton;
@property (nonatomic ,strong) UIButton *uploadPostExitViewButton;
@property (nonatomic, strong) UILabel *uploadPostTimeStampLabel;
@property (nonatomic, strong) UILabel *uploadPostLocationEnabledLabel;
@property (nonatomic, strong) UILabel *uploadPostUsernameLabel;
@property (nonatomic, strong) UILabel *uploadPostAddressLabel;
@property (nonatomic, strong) UILabel *uploadPostNavigationBarUploadLabel;
@property (nonatomic, strong) UILabel *uploadPostSlideToUploadLabel;
@property (nonatomic, strong) UILabel *uploadPostPreviewTextContentLabel;
@property (nonatomic, strong) UILabel *uploadPostPreviewUsernameLabel;
@property (nonatomic, strong) UILabel *uploadPostPreviewTimeStampLabel;
@property (nonatomic, strong) UILabel *uploadPostPreviewLocationLabel;
@property (nonatomic, strong) UILabel *uploadPostInstructionsLabel;
@property (nonatomic, strong) UILabel *uploadPostTextViewPlaceHolderLabel;
@property (nonatomic, strong) UILabel *uploadPostTextViewCharacterCountLabel;
@property (nonatomic, strong) NSString *uploadPostTextViewCharacterCountString;
@property (nonatomic, strong) NSString *uploadPostTextViewString;
@property (nonatomic, strong) NSString *uploadPostPathString;
@property (nonatomic, strong) NSData *uploadPostImageOneData;
@property (nonatomic, strong) NSData *uploadPostImageTwoData;
@property (nonatomic, strong) NSMutableDictionary *uploadPostErrorMutableDictionarySaveContents;
@property (nonatomic, strong) NSDictionary *uploadPostDictionaryTextViewContents;
@property (nonatomic, strong) NSIndexPath *cellIndex;
@property (nonatomic, strong) UITextView *uploadPostTextView;
@property (nonatomic, strong) UISwitch *uploadPostLocationEnabledSwitch;
@property (nonatomic, strong) UIAlertView *uploadPostNoTextContentAlertView;
@property int selectedCameraInt;

@property CGFloat maxYKeyboard;
@property CGFloat zoomInStartingYPosition;


//posts voted on

@property (nonatomic, strong) NSMutableArray *postsVotedOnArray;
@property (nonatomic, strong) UITableView *postsVotedOnTableView;
@property (nonatomic, strong) UIView *postsVotedOnViewForImageViews;
@property (nonatomic, strong) UIView *postsVotedOnViewForFullSizeImageView;
@property (nonatomic, strong) UIImageView *postsVotedOnImageViewOne;
@property (nonatomic, strong) UIImageView *postsVotedOnImageViewTwo;
@property (nonatomic, strong) UIImageView *postsVotedOnFullSizeImageView;
@property (nonatomic, strong) UIPanGestureRecognizer *postsVotedOnPanToZoomInOnFullSizeImageView;
@property (nonatomic, strong) UIPinchGestureRecognizer *postsVotedOnPinchGestureImageViews;
@property (nonatomic, strong) UIPinchGestureRecognizer *postsVotedOnPinchGesture;
@property (nonatomic, strong) UITapGestureRecognizer *postsVotedOnTapGestureToOpenImageViewOne; 
@property (nonatomic, strong) UITapGestureRecognizer *postsVotedOnTapGestureToOpenImageViewTwo;
@property (nonatomic, strong) UITapGestureRecognizer *postsVotedOnTapCloseFullSizeImageView;
@property (nonatomic, strong) NSIndexPath *postsVotedOnInexPath;
@property (nonatomic, strong) UIView *loadingView;


@property (nonatomic, strong) UIPinchGestureRecognizer *pinchToCloseLoadingView;
@property (nonatomic, strong) UIAlertView *alertViewLogin;
@property (nonatomic, strong) UIAlertView *alertViewOffline;
@end
