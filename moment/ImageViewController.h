//
//  ImageViewController.h
//  moment
//
//  Created by Mayank Jain on 9/21/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

#define kParseObjectClassKey    "geoImage"
#define kParseObjectGeoKey      "geo"
#define kParseObjectImageKey    "imageFile"
#define kParseObjectUserKey     "user"

@interface ImageViewController : UIViewController<CLLocationManagerDelegate, MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDictionary *photoInfo;
@property (strong, nonatomic)MBProgressHUD *HUD;
@property (strong, nonatomic)MBProgressHUD *refreshHUD;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
