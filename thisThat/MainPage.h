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

//settings
@property (nonatomic, strong) UIView *settingsView;
@property (nonatomic, strong) UITableView *settingsTableview;
@property (nonatomic, strong) NSArray *settingsSection1LabelArray;
@property (nonatomic, strong) NSArray *settingsSection2LabelArray;
@property (nonatomic, strong) NSArray *settingsSection3LabelArray;
@property (nonatomic, strong) NSArray *settingsSection4LaeblArray;
@property (nonatomic, strong) UINavigationBar *settingsNavigationBar;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizerSettingsView;
///
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// newsFeed
- (IBAction)newsFeed:(id)sender;

@property (nonatomic, strong) UIImageView *imageViewForYOUYOLO;
@property (nonatomic, strong) NSMutableArray *newsFeedArray;
@property (nonatomic, strong) UIView *newsFeedView;
@property (nonatomic, strong) UIView *viewForLabels;
@property (nonatomic, strong) UIImageView *imageViewOneCurrent;
@property (nonatomic, strong) UIImageView *imageViewTwoCurrent;
@property (nonatomic, strong) NSMutableDictionary *newsFeedMutableDictionary;
@property (nonatomic, strong) NSMutableDictionary *newsFeedImageOneDictionary;
@property (nonatomic, strong) NSMutableDictionary *newsFeedImageTwoDictionary;
@property (nonatomic, strong) NSMutableArray *newsFeedImagesMutableArray;
@property (nonatomic, strong) UIImageView *newsFeedImageOneCheckMarkView;
@property (nonatomic, strong) UIImageView *newsFeedImageOneXMarkView;
@property (nonatomic, strong) UIImageView *newsFeedImageTwoCheckMarkView;
@property (nonatomic, strong) UIImageView *newsFeedImageTwoXMarkView;
@property (nonatomic, strong) UIButton *yellowMenuButotn;
@property (nonatomic, strong) UIImageView *voteForThisImageView;
@property (nonatomic, strong) UIImageView *voteForThatImageView;
@property (nonatomic, strong) UIImageView *notThatImageView;
@property (nonatomic, strong) UIImageView *notThisImageView;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// personalPosts
- (IBAction)personalPosts:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *personalPostsButton;
@property (nonatomic, strong) NSMutableArray *personalPostsArray;
@property (nonatomic, strong) UITableView *personalPostsTableView;
@property (nonatomic, strong) UIImageView *fullSizeImageViewTableView;
@property (nonatomic, strong) UIView *personalPostsBothImagesBackGroundView;
@property (nonatomic, strong) UIImageView *personalPostsImageOne;
@property (nonatomic, strong) UIImageView *personalPostsImageTwo;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizerPersonalPostsPreviewImages;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UITapGestureRecognizer *personalPostsTapImageOne;
@property (nonatomic, strong) UITapGestureRecognizer *personalPostsTapImageTwo;
@property (nonatomic, strong) NSIndexPath *personalPostsIndexPath;
@property (nonatomic, strong) UIView *personalPostsViewForFullSizeImageView;
@property (nonatomic, strong) UIImageView *personalPostsFullSizeImageView;
@property (nonatomic, strong) UITapGestureRecognizer *personalPostsTapToCloseFullSizeImageView;
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
@property (nonatomic, strong) UILabel *totalNumberOfVotes;
@property (nonatomic, strong) UILabel *locationWhereThisThatPosted;
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
@property (nonatomic, strong) UIView *invisibleView;
@property (nonatomic, strong) UIView *invisibleViewTableView;
@property (nonatomic, strong) UIView *viewNewsFeedImageOneOverlay;
@property (nonatomic, strong) UIView *viewNewsFeedImageTwoOverlay;



//add photos
@property (nonatomic, strong) UIView *addPhotosView;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchToCloseView;
@property int selectedCameraInt;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong)  NSIndexPath *cellIndex;
@property (nonatomic, strong) UIView *exampleTableViewCellView;
@property (nonatomic, strong) UIButton *buttonImageOne;
@property (nonatomic, strong) UIButton *buttonImageTwo;
@property (nonatomic, strong) UITextView *textViewInput;
@property (nonatomic, strong) UILabel *uploadUsernameLabel;
@property (nonatomic, strong) UIImage *uploadTempImageOne;
@property (nonatomic, strong) UIImage *uploadTempImageTwo;
@property (nonatomic, strong) UIButton *uploadPreviewButton;
@property (nonatomic, strong) UIButton *uploadthisThatButton;
@property (nonatomic, strong) UIView *uploadTempImageView;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchToCloseUploadPreview;
@property (nonatomic, strong) UISwitch *showLocationSwitch;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UITapGestureRecognizer *uploadTapFullSizeImageOne;
@property (nonatomic, strong) UITapGestureRecognizer *uploadTapFullSizeImageTwo;
@property (nonatomic, strong) UIView *uploadViewForFullSizeImageView;
@property (nonatomic, strong) UIImageView *uploadFullSizeImageView;
@property (nonatomic, strong) UITapGestureRecognizer *uploadCloseFullSizeImageView;
@property (nonatomic, strong) UILabel *uploadTimeStampLabel;
@property (nonatomic, strong) UILabel *uploadEnableLocationLabel;
@property (nonatomic, strong) NSString *uploadTextViewString;
@property (nonatomic, strong) UIButton *viewLibraryPhotosButton;
@property (nonatomic, strong) UIView *uploadThisThatView;
@property (nonatomic, strong) UIPanGestureRecognizer *uploadThisThatPanGestureRecognizer;
@property (nonatomic, strong) UIView *uploadingNavBarView;
@property (nonatomic, strong) UILabel *uploadingNavBarLabel;
@property (nonatomic, strong) UIImageView *uploadingNavBarImageView;
@property (nonatomic, strong) NSMutableDictionary *uploadErrorSaveContentsDictionary;
@property (nonatomic, strong) NSString *uploadPathString;
@property (nonatomic, strong) NSData *uploadImageOneData;
@property (nonatomic, strong) NSData *uploadImageTwoData;
@property (nonatomic, strong) NSDictionary *uploadTextViewParameters;
@property (nonatomic, strong) UIButton *retryUploadButton;
@property (nonatomic, strong) UIButton *deleteFailedUploadButton;

- (IBAction)postsVotedOn:(id)sender;
@property (nonatomic, strong) UITableView *postsVotedOnTableView;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizerPostsVotedOn;
@property (nonatomic, strong) NSMutableArray *postsVotedOnArray;
@property (nonatomic, strong) UIView *postsVotedOnBothPhotosView;
@property (nonatomic, strong) UIImageView *postsVotedOnImageViewOne;
@property (nonatomic, strong) UIImageView *postsVotedOnImageViewTwo;
@property (nonatomic, strong) UIImageView *postsVotedOnFullSizeImageView;
@property (nonatomic, strong) UIView *postsVotedOnFullSizeViewForImageView;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizerPostsVotedOnPreviewView;
@property (nonatomic, strong) UITapGestureRecognizer *postsVotedOnTapImageOneFullSize;
@property (nonatomic, strong) UITapGestureRecognizer *postsVotedOnTapImageTwoFullSize;
@property (nonatomic, strong) NSIndexPath *postsVotedOnInexPath;
@property (nonatomic, strong) UITapGestureRecognizer *postsVotedOnTapCloseFullSizeImageView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchToCloseLoadingView;


@property (nonatomic, strong) UIAlertView *alertViewLogin;
@property (nonatomic, strong) UIAlertView *alertViewOffline;
@end
