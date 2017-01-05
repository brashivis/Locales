//
//  DetailsViewController.h
//  NearbyApp
//
//  Created by Jayant Madugula on 6/24/13.
//  Copyright (c) 2013 Jayant Madugula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <iAd/iAd.h>

@interface DetailsViewController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSTimer* updateMap;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property NSString* addressString;
@property NSString* phoneString;
@property NSURL* url;

@property CLLocationCoordinate2D coordinate;
@property MKMapItem* mapItem;


- (void)checkMap;

- (IBAction)goToCurrentLocation:(id)sender;

- (double)getDistance;

- (IBAction)goToMapsApp:(id)sender;

- (IBAction)makePhoneCall:(id)sender;

- (void)callNumber;

@end

