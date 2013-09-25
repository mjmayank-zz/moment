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
}

- (void) viewDidAppear:(BOOL)animated
{
    PFGeoPoint * geo = [self.object objectForKey:@"geo"];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:geo.latitude longitude:geo.longitude];
    
//    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(geo.latitude, geo.longitude);
    
    CLLocation *userLocation = [[AppDelegate sharedLocationManager] location];
    
    CLLocationDistance distance = [userLocation distanceFromLocation:location];
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f meters away", distance];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
    
    MomentAnnotation *myAnnotation = [[MomentAnnotation alloc] init];
    myAnnotation.coordinate = location.coordinate;
    myAnnotation.title = @"Photo";
    [self.mapView addAnnotation:myAnnotation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
