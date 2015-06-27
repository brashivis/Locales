//
//  LocationsViewController.m
//  NearbyApp
//
//  Created by iD Student on 6/24/13.
//  Copyright (c) 2013 iD Student. All rights reserved.
//

#import "LocationsViewController.h"
#import "NearbyLocationObjects.h"
#import <iAd/iAd.h>

@interface LocationsViewController ()

@end

@implementation LocationsViewController
@synthesize arrayWithNearbyLocations, locationManager, navController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.canDisplayBannerAds = YES;
    
    requestStatus = 0;
    
    UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(closeView)];
    [settingsButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:18], NSFontAttributeName, /*[UIColor colorWithRed:(250/255.0) green:98.0/255 blue:103/255.0 alpha:1.0],NSForegroundColorAttributeName,*/ nil] forState:UIControlStateNormal]; // Change color eventually...?
    
    //UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(<#selector#>)]; //NEED A BETTER FUNCTION TO SEND THIS TO.
    
    //    [self.navigationItem setRightBarButtonItem:refreshButton];
    [self.navigationItem setLeftBarButtonItem:settingsButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReceived:) name:@"Data Received Notification" object:nil
     ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchDetailsView:) name:@"Details View Notification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (mapVCLast == YES)
    {
        FullMapViewController* fullMapVC = [[FullMapViewController alloc] init];
        fullMapVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:fullMapVC animated:NO completion:NULL]; //Works, but data is gone from mapVC
        [fullMapVC loadMap:self.locationManager.location withSearchResults:self.arrayWithNearbyLocations andTitle:self.navigationItem.title];
    }
    else
    {
        mapVCLast = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeView
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark Setting Up Subviews and Getting Data
- (void)dataReceived:(NSNotification *)notification
{
//    NSLog(@"YAY: %@", notification.object);
    self.arrayWithNearbyLocations = notification.object; //Sets data to theTableView's data source.
    [theTableView reloadData];
}

- (void)launchDetailsView:(NSNotification *)notification
{
    mapVCLast = YES;
    DetailsViewController* detailsVC = notification.object;
    [self.navController pushViewController:detailsVC animated:YES];
}

#pragma mark TableView Actions Method
//Actions when a row is selected
- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearbyLocationObjects* selectedLocationObject = [arrayWithNearbyLocations objectAtIndex:indexPath.row];
    
    DetailsViewController* detailsViewControllerObject = [[DetailsViewController alloc] initWithNibName:@"DetailsViewController" bundle:[NSBundle mainBundle]];
    NSString* addressString = [[NSString alloc] init];
    if (selectedLocationObject.mapItem.placemark.subThoroughfare) { addressString =  [NSString stringWithString:selectedLocationObject.mapItem.placemark.subThoroughfare]; }
    MKMapItem* mapItem = selectedLocationObject.mapItem;
    addressString = [addressString stringByAppendingString:@" "];
    NSLog(@"placemark: %@", mapItem.placemark);
    addressString = [addressString stringByAppendingString:selectedLocationObject.mapItem.placemark.thoroughfare];
    addressString = [addressString stringByAppendingString:@", "];
    addressString = [addressString stringByAppendingString:selectedLocationObject.mapItem.placemark.locality];
    addressString = [addressString stringByAppendingString:@", "];
    addressString = [addressString stringByAppendingString:selectedLocationObject.mapItem.placemark.administrativeArea];
    
    detailsViewControllerObject.title = selectedLocationObject.mapItem.name;
    detailsViewControllerObject.addressString = addressString;
    detailsViewControllerObject.phoneString = selectedLocationObject.mapItem.phoneNumber;
    detailsViewControllerObject.url = selectedLocationObject.mapItem.url;
    detailsViewControllerObject.coordinate = selectedLocationObject.mapItem.placemark.coordinate;
    detailsViewControllerObject.mapItem = selectedLocationObject.mapItem;
    
    mapVCLast = NO;
    [self.navController pushViewController:detailsViewControllerObject animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Setting up the UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayWithNearbyLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* tableIdentifier = @"Locations";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableIdentifier];
    }
    NSUInteger row = [indexPath row];
    
    NearbyLocationObjects* selectedLocationObject = self.arrayWithNearbyLocations[row];
    cell.textLabel.text = selectedLocationObject.mapItem.name;
    cell.detailTextLabel.text = selectedLocationObject.filterType;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
}

#pragma mark Presenting View Controllers
- (IBAction)presentVC:(id)sender
{
    UIBarButtonItem* barButton = sender;
    if (barButton.tag == 1)
    {
        FullMapViewController* mapVC = [[FullMapViewController alloc] init];
        mapVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:mapVC animated:YES completion:^{
            
        }];
        [mapVC loadMap:self.locationManager.location withSearchResults:self.arrayWithNearbyLocations andTitle:self.navigationItem.title];
    }
}

#pragma mark Misc.
- (void)changeNavigationBarHidden
{
    if (self.statusBarHidden == YES)
    {
        navController.navigationBarHidden = NO;
        self.statusBarHidden = YES;
    }
    
    else if (self.statusBarHidden == NO)
    {
        navController.navigationBarHidden = YES;
        self.statusBarHidden = NO;
    }
}
@end