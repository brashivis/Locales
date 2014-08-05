//
//  DetailsViewController.m
//  NearbyApp
//
//  Created by iD Student on 6/24/13.
//  Copyright (c) 2013 iD Student. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController
@synthesize mapView;
@synthesize addressString, coordinate, mapItem, phoneString, tableView;

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
    
    updateMap = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkMap) userInfo:nil repeats:YES];
    
    mapView.showsUserLocation = YES;
    mapView.showsBuildings = YES;
    mapView.pitchEnabled = YES;
    mapView.rotateEnabled = YES;
    mapView.showsPointsOfInterest = NO;
    
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
    
    annotation.coordinate = mapItem.placemark.coordinate;
    annotation.title = mapItem.name;
    annotation.subtitle = self.addressString;
    
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkMap
{
    MKCoordinateRegion coordinateRegion =  MKCoordinateRegionMakeWithDistance(coordinate, 2500, 2500);

    [mapView setRegion:coordinateRegion animated: YES];
    
    //NSLog(@"%f, %f", (float)(mapView.userLocation.coordinate.longitude), (float)(mapView.userLocation.coordinate.longitude));
    
    if (mapView.userLocation.coordinate.longitude != 0)
    {
        [updateMap invalidate];
    }
}

- (IBAction)goToCurrentLocation:(id)sender
{
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 2500, 2500);
    [mapView setRegion:coordinateRegion animated:YES];
}

//not being used right now; get the average of the coordinates and open the view centered on the middle of the two points
- (double)getDistance
{
    double xCenter = coordinate.latitude;
    double yCenter = coordinate.longitude;
    double xUser = mapView.userLocation.coordinate.latitude;
    double yUser = mapView.userLocation.coordinate.longitude;
    
    NSLog(@"xCenter: %f\nyCenter: %f\nxUser: %f\nyUser: %f", xCenter, yCenter, xUser, yUser);
    
    double distance = (xCenter - xUser) * (xCenter - xUser) + (yCenter - yUser) * (yCenter - yUser);
    distance = sqrt(distance);
    NSLog(@"%f", distance);
    return distance * 100;
}

- (IBAction)goToMapsApp:(id)sender
{
    [mapItem openInMapsWithLaunchOptions:nil];
}

#pragma mark Phone Call Methods
- (IBAction)makePhoneCall:(id)sender
{
    NSString* queryString = [@"Call " stringByAppendingString:self.title];
    queryString = [queryString stringByAppendingString:@"?"];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:queryString message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { [self callNumber]; }
    else [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)callNumber
{
    NSLog(@"Entered");
    NSString* callString = [@"tel:" stringByAppendingString: self.phoneString];
    [callString stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSLog(@"%@", callString);
    NSURL* callURL = [[NSURL alloc] initWithString:callString];
    [[UIApplication sharedApplication] openURL:callURL];
}

#pragma mark TableView SetUp Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"Call";
        cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    }
    if (indexPath.row == 1)
    {
        cell.textLabel.text = @"Get Directions";
        cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    }
    if (indexPath.row == 2)
    {
        cell.textLabel.text = @"Visit Website";
        cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
//    cell.textLabel.textColor = [UIColor colorWithRed:(250/255.0) green:98.0/255 blue:103/255.0 alpha:1.0];
}

// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}



// Override to support editing the table view.
/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete)
 {
 [self.tableView beginUpdates];
 NSLog(@"%d", indexPath.row);
 [dataArray removeObjectAtIndex:indexPath.row]; //not working, saying unrecognized selector sent to selector
 [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 [self.tableView endUpdates];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }*/


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0)
    {
        [self makePhoneCall:nil];
    }
    if (indexPath.row == 1)
    {
        [mapItem openInMapsWithLaunchOptions:nil];
    }
    if (indexPath.row == 2)
    {
        if (self.url)
        {
            [[UIApplication sharedApplication] openURL:self.url];
        }
        else
        {
            NSString* request = self.title;
            request = [request stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            NSString* urlRequest = [NSString stringWithFormat:@"https://www.google.com/search?q=%@", request];
            
            NSURL* googleURL = [[NSURL alloc] initWithString:urlRequest];
            [[UIApplication sharedApplication] openURL:googleURL];
        }
    }
}

@end





