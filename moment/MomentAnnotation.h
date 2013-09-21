//
//  MomentAnnotation.h
//  moment
//
//  Created by Raj Ramamurthy on 9/21/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MomentAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign)   CLLocationCoordinate2D  coordinate;
@property (nonatomic, copy)     NSString*               title;
@property (nonatomic, copy)     NSString*               subtitle;

@end
