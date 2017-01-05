//
//  FullMapViewController.m
//  NearbyApp
//
//  Created by Jayant Madugula on 7/17/13.
//  Copyright (c) 2013 Jayant Madugula. All rights reserved.
//

#import "FullMapViewController.h"
#import "NearbyLocationObjects.h"

@interface FullMapViewController ()
@end

@implementation FullMapViewController


@synthesize mapView, titleBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.canDisplayBannerAds = YES;
    
    self.mapView.rotateEnabled = YES;
    self.mapView.pitchEnabled = YES;
    self.mapView.showsBuildings = YES;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = NO;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMap:(CLLocation *)userLocation withSearchResults:(NSArray *)arrayOfNearbyObjects andTitle:(NSString *)title
{
    self.titleBar.topItem.title= title;
    arrayWithNearbyObjects = arrayOfNearbyObjects;
    [self zoomToCurrentLocation:userLocation];
    [self setUpAnnotations:arrayOfNearbyObjects];
}

- (void)zoomToCurrentLocation:(CLLocation *)userLocation
{
    //Code for zooming to user's location.
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000);
    [self.mapView setRegion:viewRegion animated:YES];
}

- (void)setUpAnnotations:(NSArray *)nearbyObjectArray
{
    //Add annotations to map.
    annotationArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [nearbyObjectArray count]; i++)
    {
        NearbyLocationObjects* nearbyObject = nearbyObjectArray[i];
        
        JMAnnotationCallout* annotation = [[JMAnnotationCallout alloc] initWithTitle:nearbyObject.mapItem.name subtitle:nearbyObject.filterType Coordinate:nearbyObject.mapItem.placemark.coordinate];
        
        MKPinAnnotationView* annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
        
        annotationView.canShowCallout = YES;
        annotationView.enabled = YES;
        
        [annotationArray addObject:annotation];
    }
    //MKPlacemark conforms to the MKAnnotation protocol.
    [self.mapView addAnnotations:annotationArray];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Annotation"];
    if ([annotation isKindOfClass:[JMAnnotationCallout class]])
    {
        if (!annotationView)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
            annotationView.pinColor = MKPinAnnotationColorRed;
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            
            JMCalloutButton* button = [JMCalloutButton buttonWithType:UIButtonTypeDetailDisclosure];
            button.description = annotationView.annotation.title;
            [button addTarget:self action:@selector(calloutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        else
        {
            annotationView.annotation = annotation;
        }
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSArray* singleCallout = self.mapView.selectedAnnotations;
    JMAnnotationCallout* annotation = singleCallout[0];
    NSInteger index = [annotationArray indexOfObject:annotation];
    NearbyLocationObjects* selectedLocationObject = arrayWithNearbyObjects[index];
    
    NSString* addressString = [[NSString alloc] init];
    if (selectedLocationObject.mapItem.placemark.subThoroughfare) { addressString =  [NSString stringWithString:selectedLocationObject.mapItem.placemark.subThoroughfare]; }
    addressString = [addressString stringByAppendingString:@" "];
    addressString = [addressString stringByAppendingString:selectedLocationObject.mapItem.placemark.thoroughfare];
    addressString = [addressString stringByAppendingString:@", "];
    addressString = [addressString stringByAppendingString:selectedLocationObject.mapItem.placemark.locality];
    addressString = [addressString stringByAppendingString:@", "];
    addressString = [addressString stringByAppendingString:selectedLocationObject.mapItem.placemark.administrativeArea];
    
    
    DetailsViewController* detailsViewControllerObject = [[DetailsViewController alloc] init];
    detailsViewControllerObject.title = selectedLocationObject.mapItem.name;
    detailsViewControllerObject.addressString = addressString;
    detailsViewControllerObject.phoneString = [self getFormattedPhoneString:selectedLocationObject];
    if (selectedLocationObject.mapItem.url) { detailsViewControllerObject.url = selectedLocationObject.mapItem.url; }
    else { detailsViewControllerObject.url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com/#q=%@", selectedLocationObject.mapItem.name]]; }
    detailsViewControllerObject.coordinate = selectedLocationObject.mapItem.placemark.coordinate;
    detailsViewControllerObject.mapItem = selectedLocationObject.mapItem;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Details View Notification" object:detailsViewControllerObject];
    [self dismissViewControllerAnimated:YES completion:NULL];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (NSString *)getFormattedPhoneString: (NearbyLocationObjects *)nearbyLocation
{
    if ([nearbyLocation.mapItem.placemark.countryCode isEqual: @"US"])
    {
        int phoneNumber = [nearbyLocation.mapItem.phoneNumber intValue];
        nearbyLocation.mapItem.phoneNumber = [NSString stringWithFormat:@"%d", phoneNumber];
        
        return nearbyLocation.mapItem.phoneNumber;
    }
    else {return nearbyLocation.mapItem.phoneNumber;}
}

- (IBAction)closeView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

@end
