//
//  DetailViewController.m
//  moment
//
//  Created by Mayank Jain on 9/22/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "DetailViewController.h"
#import "LocationManager.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#define METERS_PER_MILE 1609.344

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString *)nibName {
    return @"DetailViewController";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.captionLabel.text = [self.object objectForKey:@"caption"];
    PFGeoPoint * geo = [self.object objectForKey:@"geo"];
    
    self.location = [[CLLocation alloc] initWithLatitude:geo.latitude longitude:geo.longitude];
    CLLocation *userLocation = [[AppDelegate sharedLocationManager] location];
    
    self.distance = [userLocation distanceFromLocation:self.location];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.0f meters away", self.distance];
}

- (void) viewDidAppear:(BOOL)animated
{
    
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 1.5 * self.distance, 1.5 * self.distance);
    [self.mapView setRegion:viewRegion animated:YES];
    
    MomentAnnotation *myAnnotation = [[MomentAnnotation alloc] init];
    myAnnotation.coordinate = self.location.coordinate;
    myAnnotation.title = @"Photo";
    [self.mapView addAnnotation:myAnnotation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteButtonPressed:(id)sender {
    [self.deleteButton setEnabled:NO];
    [self.object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];

}

- (IBAction)likeButtonPressed:(id)sender {
    [self.likeButton setEnabled:NO];
    if(self.object[@"Likes"] == NULL){
        self.object[@"Likes"] = @1;
    }
    else{
        [self.object incrementKey:@"Likes"];
    }
    [self.object saveInBackground];
}
@end
