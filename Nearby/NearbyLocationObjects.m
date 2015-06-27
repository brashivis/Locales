//
//  NearbyLocationObjects.m
//  NearbyApp
//
//  Created by Jayant Madugula on 8/7/13.
//  Copyright (c) 2013 iD Student. All rights reserved.
//

#import "NearbyLocationObjects.h"
#import "SettingsViewController.h"

@implementation NearbyLocationObjects

@synthesize mapItem, boundingRegion, filterType;

- (void)beginDataRequest:(CLLocation *)locationData withRequestArray:(NSArray *)requestArray //Invoked by another class once per search
{
    index = 0;
    userLocation = locationData;
    searchTermsArray = requestArray;
    NSLog(@"Search Terms Array: %@", searchTermsArray);
    
    for (int i = 0; i <= 5; i++) //Starts the first five searches.
    {
        if (index < [searchTermsArray count])
        {
            [self manageSearchFlow];
        }
    }
}

- (void)manageData:(NSArray *)searchResultsArray
{
    if (searchResultsArray == nil)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Data Received Notification" object:finalDataArray];
    }
    else
    {
        if (!finalDataArray) { finalDataArray = [[NSMutableArray alloc] init]; }
        [finalDataArray addObjectsFromArray:searchResultsArray];
        [self manageSearchFlow];
    }
}


- (void)manageSearchFlow //Manages the number of searches going at once. Adds a search when another search ends.
{
    if (index < [searchTermsArray count])
    {
//        NSLog(@"If Statement");
        [self collectData];
    }
    else
    {
//        NSLog(@"Else Statement");
        [self manageData:nil];
    }
}

- (void)collectData
{
    NSString* currentRequestString = [searchTermsArray objectAtIndex:index];
    
    index++;
    [self findNearbyLocation:currentRequestString];
}


- (void)findNearbyLocation:(NSString *)query
{
    //Find way to ask one at a time (otherwise, it returns error) using search.searching property!!
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    
    MKLocalSearchRequest* localSearchRequest = [[MKLocalSearchRequest alloc] init];
    //Sets parameters for search.
    localSearchRequest.naturalLanguageQuery = query;
    
    //Customized Distance
    NSNumber* distanceNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"Distance Num"];
    double miles = [distanceNum doubleValue];
    double scalingFactor = ABS( (cos(2 * M_PI * userLocation.coordinate.latitude / 360.0) ));
    
    MKCoordinateSpan span;
    
    span.latitudeDelta = miles / 69.0;
    span.longitudeDelta = miles / (scalingFactor * 69.0);
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = userLocation.coordinate;
    
    
    localSearchRequest.region = region;
//    NSLog(@"UserLocation:%@", userLocation);
    
    MKLocalSearch* search = [[MKLocalSearch alloc] initWithRequest:localSearchRequest];
//    NSLog(@"Search object created.");
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError* error)
     {
//         NSLog(@"Search Successful");
         for (int i = 0; i < [response.mapItems count]; i++) //response.mapItems is an array of mapItems.
         {
             NearbyLocationObjects* nearbyObject = [[NearbyLocationObjects alloc] init]; //Turns mapItems into NearbyLocationObjects and sets custom properties
             nearbyObject.mapItem = [response.mapItems objectAtIndex:i];
             nearbyObject.boundingRegion = response.boundingRegion;
             nearbyObject.filterType = query;
             
             if (nearbyObject.mapItem.placemark.thoroughfare)
             {
                 [resultArray addObject:nearbyObject]; //Puts custom objects into array.
             }
             else { NSLog(@"Nope"); }
         }
         if (error) { NSLog(@"MKErrorDomain: %@", [error localizedDescription]); }
         else { [self manageData:resultArray]; }
     }];
}
@end