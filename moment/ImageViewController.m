//
//  ImageViewController.m
//  moment
//
//  Created by Mayank Jain on 9/21/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 320)];
//        CGRect frame = self.imageView.frame;
//        self.imageView2.frame = frame;
        self.imageView2.contentMode = UIViewContentModeScaleAspectFit;
//        
        [self.view addSubview:self.imageView2];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.imageView.image = self.image;
    self.locationManager=[[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.delegate=self;
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setCameraPic:(UIImage *)image{
    self.imageView2.image = image;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
//    Foursquare *foursquare = [[Foursquare alloc] initWithClientID:@"I2J4JN5GIOMDNSFP02H3CWYTQ0L0CXMRTVRXSWVR3XRZCCJ2"
//                                                     clientSecret:@"H5MDABPQUUGLG25LEDYXH3JKBYIVGQMHALQ1VUAA2HKHSCLC"];
    
    NSLog([NSString stringWithFormat:@"%@, %@", newLocation, oldLocation]);
    
    const CLLocationDegrees latitude = newLocation.coordinate.latitude;
    const CLLocationDegrees longitude = newLocation.coordinate.longitude;
    
    NSString * query = @"";
    
//    [foursquare searchVenuesWithLatitude:latitude longitude:longitude query:query completionHandler:^(NSDictionary *results, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            NSDictionary * searchResults = [[results objectForKey:@"response"] objectForKey:@"venues"];
            //            [self.view.tableView reloadData];
//        });
//    } ];
}

@end