//
//  LocationsViewController.h
//  NearbyApp
//
//  Created by Jayant Madugula on 6/24/13.
//  Copyright (c) 2013 Jayant Madugula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DetailsViewController.h"
#import "FullMapViewController.h"
#import "NearbyLocationObjects.h"
#import "SpecificFiltersViewController.h"

@interface LocationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate>
{
    NSMutableArray* tableData;
    IBOutlet UITableView *theTableView;
    
    NSTimer* updateQuery;
    NSTimer* getPointsOfLocation;
    
    NSMutableArray* arrayWithLocations;
    BOOL requestStatus;

    NSString* languageQueryString;
    NSMutableArray* arrayOfRequests;
    
    int currentRequest;
    BOOL mapVCLast;
    
    UINavigationController* navController;
    
    CLLocation* userLocation;
}

@property BOOL statusBarHidden;

@property NSArray* arrayWithNearbyLocations;

@property CLLocationManager* locationManager;

@property UINavigationController* navController;

- (void)dataReceived:(NSNotification* )notification;
- (void)launchDetailsView:(NSNotification* )notification;

- (void)changeNavigationBarHidden;

- (NSString *)getFormattedPhoneString: (NearbyLocationObjects *)nearbyLocation;

- (IBAction)presentVC:(id)sender;

- (void)closeView;

@end
