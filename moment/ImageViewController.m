//
//  ImageViewController.m
//  moment
//
//  Created by Mayank Jain on 9/21/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "ImageViewController.h"
#import "MomentAnnotation.h"
#define METERS_PER_MILE 1609.344

@interface ImageViewController ()

@property (strong, nonatomic) MomentAnnotation* myAnnotation;

@end

@implementation ImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 320)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:self.imageView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated: YES];
    UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = save;
    save.enabled=TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocationCoordinate2D zoomLocation = [[locations lastObject] coordinate];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [_mapView setRegion:viewRegion animated:YES];

    _myAnnotation = [[MomentAnnotation alloc] init];
    _myAnnotation.coordinate = zoomLocation;
    _myAnnotation.title = @"Photo";
    [_mapView addAnnotation:_myAnnotation];
    [self.locationManager stopUpdatingLocation];
}

- (IBAction)savePressed:(id)sender{
    ((UIBarButtonItem *)sender).enabled = NO;
    UIImage *image = [self.photoInfo objectForKey:@"UIImagePickerControllerEditedImage"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    [self uploadImage:imageData];
}

- (IBAction)postPost:(id)sender;
{
    // Create a PFGeoPoint using the user's location
    PFGeoPoint *currentPoint = [PFGeoPoint geoPointWithLatitude:_myAnnotation.coordinate.latitude
                                                      longitude:_myAnnotation.coordinate.longitude];

    // Create a PFObject using the Post class and set the values we extracted above
    PFObject *postObject = [PFObject objectWithClassName:@kParseObjectClassKey];
    [postObject setObject:currentPoint forKey:@kParseObjectGeoKey];

    // Set the access control list on the postObject to restrict future modifications
    // to this object
    PFACL *readOnlyACL = [PFACL ACL];
    [readOnlyACL setPublicReadAccess:YES]; // Create read-only permissions
    [readOnlyACL setPublicWriteAccess:NO];
    [postObject setACL:readOnlyACL]; // Set the permissions on the postObject
}

- (void)uploadImage:(NSData *)imageData{
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    //HUD creation here (see example for code)
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    
    // Set determinate mode
    self.HUD.mode = MBProgressHUDModeDeterminate;
    self.HUD.delegate = self;
    self.HUD.labelText = @"Uploading";
    [self.HUD show:YES];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@kParseObjectClassKey];
            [userPhoto setObject:imageFile forKey:@kParseObjectImageKey];

            // Create a PFGeoPoint using the user's location and associate it
            PFGeoPoint *currentPoint = [PFGeoPoint geoPointWithLatitude:_myAnnotation.coordinate.latitude
                                                              longitude:_myAnnotation.coordinate.longitude];
            [userPhoto setObject:currentPoint forKey:@kParseObjectGeoKey];

            // Associate this PFObject with the current user
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@kParseObjectUserKey];

            // Set the access control list to current user for security purposes
            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];

            // Save this in background
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else {
            [self.HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        self.HUD.progress = (float)percentDone/100;
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [self.HUD removeFromSuperview];
    self.HUD = nil;
}

@end
