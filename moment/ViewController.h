//
//  ViewController.h
//  moment
//
//  Created by Mayank Jain on 9/21/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "MomentAnnotation.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, MBProgressHUDDelegate, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) MBProgressHUD *refreshHUD;
@property (strong, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (strong, nonatomic) NSMutableArray *allImages;
@property (strong, nonatomic) NSMutableArray *allData;
@property (strong, nonatomic) CLLocation *lastLocation;
@property (strong, nonatomic) NSMutableArray *captions;
@property (strong, nonatomic) IBOutlet UICollectionView *photoCollectionView;

- (void) takePhoto;

@end
