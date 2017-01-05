//
//  JMAnnotationCallout.h
//  Nearby
//
//  Created by Jayant Madugula on 7/6/14.
//  Copyright (c) 2014 Jayant Madugula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface JMAnnotationCallout : UIView <MKAnnotation>
{
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) IBOutlet UIButton *detailsButton;

- (id)initWithTitle:(NSString *)theTitle subtitle:(NSString *)theSubtitle Coordinate:(CLLocationCoordinate2D)theCoordinate;
- (void)buttonTapped:(id)sender;

@end
