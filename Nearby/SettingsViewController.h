//
//  SettingsViewController.h
//  NearbyApp
//
//  Created by Jayant Madugula on 6/27/13.
//  Copyright (c) 2013 Jayant Madugula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <iAd/iAd.h>
#import "SpecificFiltersViewController.h"
#import "LocationsViewController.h"
#import "NearbyLocationObjects.h"
#import "JMPreferencesViewController.h"

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UIAlertViewDelegate, ADBannerViewDelegate>
{
    NSArray* iconsArray;
    NSArray* titleArray;
    
    UIActivityIndicatorView* activityIndicator;
}

@property (strong, nonatomic) IBOutlet UITableView *theTableView;
@property NSString *currentRequest;

- (void)searchButtonNotification:(NSNotification *)notification;
- (void)showSearchResults:(NSString *)searchCategory withIndexPath:(NSIndexPath *)indexPath;

@end
