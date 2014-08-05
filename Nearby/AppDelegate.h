//
//  AppDelegate.h
//  NearbyApp
//
//  Created by iD Student on 6/24/13.
//  Copyright (c) 2013 iD Student. All rights reserved.
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