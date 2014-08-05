//
//  SettingsViewController.h
//  NearbyApp
//
//  Created by iD Student on 6/27/13.
//  Copyright (c) 2013 iD Student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <iAd/iAd.h>
#import "SpecificFiltersViewController.h"
#import "LocationsViewController.h"
#import "NearbyLocationObjects.h"

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UIAlertViewDelegate, ADBannerViewDelegate>
{
    NSArray* iconsArray;
    NSArray* titleArray;
    
    UIActivityIndicatorView* activityIndicator;
}

@property (strong, nonatomic) IBOutlet UITableView *theTableView;
@property NSString *currentRequest;
@property CLLocationManager* locationManager;

- (void)searchButtonNotification:(NSNotification *)notification;
- (void)showSearchResults:(NSString *)searchCategory;
- (void)locationServicesRestart;

@end