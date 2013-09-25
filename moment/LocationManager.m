//
//  LocationManager.m
//  moment
//
//  Created by Mayank Jain on 9/24/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager() {
@private
    CLLocationManager *manager;
}

@end

static LocationManager *sharedLocationManager = nil;

@implementation LocationManager

+(id)initLocationManager {
    @synchronized(self) {
        if(sharedLocationManager == nil)
            sharedLocationManager = [[LocationManager alloc] init];
    }
    return sharedLocationManager;
}

-(id)init {
    if(self = [super init]) {
        manager = [[CLLocationManager alloc] init];
        [manager setDelegate:self];
    }
    return self;
}

#pragma mark -
#pragma mark Location Methods

-(void)startLocationUpdates {
    [manager startUpdatingLocation];
}

-(void)stopLocationUpdates {
    [manager stopUpdatingLocation];
}

#pragma mark -
#pragma mark Location Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if([locations count] > 0) {
        _lastLocation = locations[0];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LocationUpdate object:_lastLocation];
    }
}


@end
