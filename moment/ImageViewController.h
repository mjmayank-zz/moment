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

@interface ImageViewController : UIViewController<CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
