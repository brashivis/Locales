//
//  JMAnnotationCallout.m
//  Nearby
//
//  Created by Jayant Madugula on 7/6/14.
//  Copyright (c) 2014 Jayant Madugula. All rights reserved.
//

#import "JMAnnotationCallout.h"

@implementation JMAnnotationCallout

@synthesize title, subtitle, detailsButton;
@synthesize coordinate = _coordinate;


- (id)initWithTitle:(NSString *)theTitle subtitle:(NSString *)theSubtitle Coordinate:(CLLocationCoordinate2D)theCoordinate
{
    self = [super init];
    if (self)
    {
        self.title = theTitle;
        self.subtitle = theSubtitle;
        _coordinate = theCoordinate;
    }
    
    return self;
}
@end
