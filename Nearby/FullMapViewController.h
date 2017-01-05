//
//  FullMapViewController.h
//  NearbyApp
//
//  Created by Jayant Madugula on 7/17/13.
//  Copyright (c) 2013 Jayant Madugula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JMAnnotationCallout.h"
#import "JMCalloutButton.h"
#import "DetailsViewController.h"


@interface FullMapViewController : UIViewController <MKMapViewDelegate>
{
    NSTimer* locationTimer;
    NSArray* arrayWithNearbyObjects;
    NSMutableArray* annotationArray;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *titleBar;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property NSMutableArray* arrayWithLocations;

- (void)loadMap:(CLLocation *)userLocation withSearchResults:(NSArray *)arrayOfNearbyObjects andTitle:(NSString *)title;
- (void)zoomToCurrentLocation:(CLLocation *)userLocation;
- (void)setUpAnnotations:(NSArray *)nearbyObjectArray;
- (IBAction)calloutButtonPressed;

- (IBAction)closeView:(id)sender;
@end
