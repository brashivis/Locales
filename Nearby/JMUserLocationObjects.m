//
//  JMUserLocationObjects.m
//  Locales
//
//  Created by Jayant Madugula on 4/13/15.
//  Copyright (c) 2015 Jayant Madugula. All rights reserved.
//

#import "JMUserLocationObjects.h"

@implementation JMUserLocationObjects
@synthesize locationManager;

- (void)beginUpdatingData
{
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
    
    // Set timer to fire every few seconds to update user's location based on speed.
    
    NSLog(@"LocationManager did update user location.");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation]; //Force Restart.
}


@end
