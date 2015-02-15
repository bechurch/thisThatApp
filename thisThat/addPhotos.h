//
//  addPhotos.h
//  thisThat
//
//  Created by James Connerton on 2015-01-25.
//  Copyright (c) 2015 James Connerton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addPhotos : UIViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSArray *cellTextLabelArray;
@property (nonatomic, strong) NSString *textFieldString;
@property (nonatomic, strong) NSObject *selectedRow;
@property (nonatomic, strong) UIImageView *imageViewOne;
- (IBAction)previewButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *previewButton;
@property (nonatomic, strong) UIImageView *imageViewTwo;
@property (nonatomic, strong) UIImageView *imageViewOneTemp;
@property (nonatomic, strong) UIImageView *imageViewTwoTemp;
@property (nonatomic, strong) UIView *showPhotosView;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecogizer;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIButton *chosePhotoButton;
@property (nonatomic, strong) UIImage *imageTempOne;
@property (nonatomic, strong) UIImage *imageTempTwo;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureFullSizeImageOne;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureCloseFullSizeImage;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureFullSizeImageTwo;
@property (nonatomic, strong) UIImageView *fullSizeImageView;
@property int x;
@property (nonatomic, strong) UIView *additionalView;
@property (nonatomic, strong) UIProgressView *progressView;
@property float update;

@end
