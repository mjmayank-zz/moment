//
//  DetailViewController.h
//  moment
//
//  Created by Mayank Jain on 9/22/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MomentAnnotation.h"
#import "AppDelegate.h"

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) PFObject * object;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) CLLocation *location;
@property (assign, nonatomic) CLLocationDistance distance;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)likeButtonPressed:(id)sender;

@end
