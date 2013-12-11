//
//  ViewController.m
//  moment
//
//  Created by Mayank Jain on 9/21/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "FeedCell.h"
#import "AFHTTPRequestOperationManager.h"
#include <stdlib.h>

@interface ViewController ()

@end

@implementation ViewController

#define PADDING_TOP 0 // For placing the images nicely in the grid
#define PADDING 4
#define THUMBNAIL_COLS 1
#define THUMBNAIL_WIDTH 312
#define THUMBNAIL_HEIGHT 312
#define METERS_PER_MILE 1609.344

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.allImages = [[NSMutableArray alloc] init];
        self.allData = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"FeedCell" bundle:nil];
    
    [self.photoCollectionView registerNib:nib forCellWithReuseIdentifier:@"fcell"];
    [self setTitle:@"Feed"];
    UIBarButtonItem *camera = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = camera;
    camera.enabled=TRUE;
}

- (void)viewDidAppear:(BOOL)animated
{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        [self downloadAllImages];
//    });
    [self downloadAllImages];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)takePhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"No Camera"
                                                              message:@"Using sample image"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];

        [myAlertView show];
        [self doesNotHaveCamera];
        return;
    }

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:picker animated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    ImageViewController * imageVC = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.navigationController pushViewController:imageVC animated:YES];
    imageVC.imageView.image = chosenImage;
    imageVC.photoInfo = info;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.imageView.image = [UIImage imageNamed:@"CameraFailureImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/* Sim only */
- (void)doesNotHaveCamera {
    ImageViewController * imageVC = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];
    UIImage *chosenImage = [UIImage imageNamed:@"CameraFailureImage"];
    [self.navigationController pushViewController:imageVC animated:YES];
    imageVC.imageView.image = chosenImage;
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:^{
            [self takePhoto];
    }];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL]; // Dismiss the PFSignUpViewController
}

- (void)downloadAllImages
{
    // Create a PFGeoPoint using the current location (to use in our query)
    CLLocation *currentLocation = [[AppDelegate sharedLocationManager] location];
    [AppDelegate sharedLocationManager].delegate = self;
    PFGeoPoint *userLocation =
    [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude
                           longitude:currentLocation.coordinate.longitude];

    // Construct query
    PFQuery *query = [PFQuery queryWithClassName:@kParseObjectClassKey];
    [query whereKey:@kParseObjectGeoKey nearGeoPoint:userLocation withinKilometers:2];
    
    NSString *url = [kIPAdresss stringByAppendingString:[NSString stringWithFormat:@"/all?long=%f&lat=%f", userLocation.latitude, userLocation.longitude]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.

            NSLog(@"Successfully retrieved %lu photos.", (unsigned long)objects.count);
        
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                [self.allImages removeAllObjects];
//                NSMutableArray *temp = [[NSMutableArray alloc] init];
                for (PFObject *object in objects){
                    PFFile *theImage = [object objectForKey:@kParseObjectImageKey];
                    
                    NSData *imageData = [theImage getData];
                    if(imageData != nil){
                        [self.allImages addObject:imageData];
                    }
                }
//                self.allImages = temp;
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:objects];
                    
                    self.allData = temp;
                    [self.photoCollectionView reloadData];
                });
            });
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)buttonTouched:(id)sender{
    NSLog(@"touched");
    DetailViewController *dvc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    [self.navigationController pushViewController:dvc animated:YES];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    if(self.lastLocation ==NULL){
//        self.lastLocation = locations[0];
//    }
//    CLLocationDistance distance = [locations[0] distanceFromLocation:self.lastLocation];
//    if(distance > 20.0){
//        self.lastLocation = locations[0];
//        [self downloadAllImages];
//        NSLog(@"%f", distance);
//    }
}

#pragma mark - UICollectionView Datasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeedCell * cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"fcell" forIndexPath:indexPath];
    
    [cell setImage:[UIImage imageWithData:[self.allImages objectAtIndex:indexPath.row]]];
    
    if([[self.allData objectAtIndex:indexPath.row]  objectForKey:@"caption"] != NULL){
        [cell showCaption];
        [cell setCaption:[[self.allData objectAtIndex:indexPath.row]  objectForKey:@"caption"]];
//        if([[self.allData objectAtIndex:indexPath.row]  objectForKey:@"Likes"] == NULL){
//            [cell setLikes:@"No likes"];
//        }
//        else{
//            NSString * numLikes = [[self.allData objectAtIndex:indexPath.row]  objectForKey:@"Likes"];
//            [numLikes stringByAppendingString:@"likes"];
//            [cell setLikes:numLikes];
//        }
        int likes = [[[self.allData objectAtIndex:indexPath.row]  objectForKey:@"Likes"] intValue];
        [cell setLikes:[NSString stringWithFormat:@"%d likes", likes]];
    }
    else{
        [cell hideCaption];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%d cells", self.allImages.count);
    return self.allImages.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
    NSLog(@"selected");
    DetailViewController *dvc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    dvc.object = self.allData[[indexPath row]];
    
    dvc.image = [UIImage imageWithData:[self.allImages objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:dvc animated:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
    NSLog(@"deselected");
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(320, 320);
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(4, 0, 4, 0);
}
@end
