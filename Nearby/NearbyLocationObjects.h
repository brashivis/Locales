//
//  NearbyLocationObjects.h
//  NearbyApp
//
//  Created by Jayant Madugula on 8/7/13.
//  Copyright (c) 2013 iD Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NearbyLocationObjects : NSObject
{
    int index;
    
    NSArray* searchTermsArray;
    NSArray* keyArray;
    NSMutableArray* finalDataArray;
    
    NSDictionary* searchTermsDictionary;
    
    CLLocation* userLocation;
}

@property (retain) MKMapItem* mapItem; //NECESSARY
@property MKCoordinateRegion boundingRegion; //NEW
@property (retain) NSString* filterType;

- (void)findNearbyLocation: (NSString *)query;
- (void)collectData; //Instance-Method that manages 'findNearbyLocation' (use allValues NSDictionary method to get array of all terms, then call ^ to get data)
- (void)manageSearchFlow;
- (void)manageData:(NSArray *)searchResultsArray;
- (void)beginDataRequest:(CLLocation *)locationData withRequestArray:(NSArray *)requestArray;

@end
