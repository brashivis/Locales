//
//  SettingsViewController.m
//  NearbyApp
//
//  Created by Jayant Madugula on 6/27/13.
//  Copyright (c) 2013 Jayant Madugula. All rights reserved.
//

#import "SettingsViewController.h"
#import "JMUserLocationObjects.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize currentRequest, theTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.canDisplayBannerAds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchButtonNotification:) name:@"Search Button Tapped" object:nil];
    
    iconsArray = [[NSArray alloc] initWithObjects:@"Food.png", @"Entertainment.png", @"Attractions.png", @"Shopping.png", @"Lodging.png", @"Transportation.png", @"Healthcare.png", @"Favorites.png", nil]; //Make sure these pictures get in somewhere...!!
    titleArray = [[NSArray alloc] initWithObjects:@"Food and Drink", @"Entertainment", @"Local Attractions", @"Shopping", @"Lodging", @"Transportation", @"Healthcare", @"Favorites", nil];
    
    [self.theTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.theTableView reloadData];
}

- (void)showSearchResults:(NSString *)searchCategory withIndexPath:(NSIndexPath *)indexPath
{
    LocationsViewController* locationsVC = [[LocationsViewController alloc] init];
    locationsVC.navController = [[UINavigationController alloc] initWithRootViewController:locationsVC];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Search Dictionary"])
    {
        NSDictionary* requestDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"Search Dictionary"];
        NSArray* requestArray = [requestDictionary objectForKey:searchCategory];
        if ([requestArray count] > 0)
        {
            JMUserLocationObjects* locationObject = [[JMUserLocationObjects alloc] init];
            NearbyLocationObjects* nearbyObject = [[NearbyLocationObjects alloc] init];
            [nearbyObject beginDataRequest:locationObject.locationManager.location withRequestArray:requestArray];
            
            [activityIndicator stopAnimating];
            
            locationsVC.navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:locationsVC.navController animated:YES completion:NULL];
            
            locationsVC.title = searchCategory;
            [locationsVC.navController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                            [UIFont fontWithName:@"HelveticaNeue-Light" size:22],
                                                                            NSFontAttributeName, nil]];
            locationsVC.locationManager = locationObject.locationManager;
        }
        else
        {
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Filters Selected!" message:@"Tap the i to select some filters." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//            [alert show];
            
            [self tableView:theTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
        }
    }
    else
    {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Filters Selected!" message:@"Tap the i to select some filters." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
        
        [self tableView:theTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
    
}

- (void)searchButtonNotification:(NSNotification *)notification
{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator startAnimating];
    
    [self showSearchResults:notification.object withIndexPath:nil];
}

- (IBAction)openUserPreferencesView:(id)sender
{
    JMPreferencesViewController* prefVC = [[JMPreferencesViewController alloc] init];
    prefVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:prefVC animated:YES completion:NULL];
}

#pragma mark – TableView Action Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* requestString = titleArray[indexPath.row];
    [self showSearchResults:requestString withIndexPath:indexPath];
    
    [self.theTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    SpecificFiltersViewController* specificFiltersVC = [[SpecificFiltersViewController alloc] init];
    self.currentRequest = titleArray[indexPath.row];
    
    [self presentViewController:specificFiltersVC animated:YES completion:NULL];
    NSLog(@"%@", self.currentRequest);
    [specificFiltersVC presentData:self.currentRequest];
    
    [self.theTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark – TableView Setup Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* tableIdentifier = @"Filters";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableIdentifier];
    }
    NSUInteger row = [indexPath row];
//    cell.imageView.image = iconsArray[row];
    cell.textLabel.text = titleArray[row];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Search Dictionary"])
    {
        NSDictionary* searchDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"Search Dictionary"];
    
        NSArray* searchArray = [searchDict objectForKey:cell.textLabel.text];
        long num = [searchArray count];
        if (num == 1)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Tap to Search (%ld filter selected)", num];
        }
        else if (num == 0)
        {
            cell.detailTextLabel.text = @"Tap to Select Filters";
        }
        else { cell.detailTextLabel.text = [NSString stringWithFormat:@"Tap to Search (%ld filters selected)", num]; }
    }
    else
    {
        cell.detailTextLabel.text = @"Tap to Select Filters";
    }
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0 green:(122.0/255.0) blue:1.0 alpha:1.0];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
}
@end
