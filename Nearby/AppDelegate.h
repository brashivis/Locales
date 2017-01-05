//
//  AppDelegate.h
//  NearbyApp
//
//  Created by Jayant Madugula on 6/24/13.
//  Copyright (c) 2013 Jayant Madugula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationsViewController.h"
#import "DetailsViewController.h"
#import "NearbyLocationObjects.h"
#import "SettingsViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    UINavigationController* nvc;
    UINavigationController* specificNavigationController;
    LocationsViewController* lvc;
    //DetailsViewController* dvc;
    NearbyLocationObjects* nlo;
    SettingsViewController* svc;
    SpecificFiltersViewController* specificfvc;
}

@property (strong, nonatomic) UIWindow *window;

@end
