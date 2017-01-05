//
//  JMUserLocationObjects.h
//  Locales
//
//  Created by Jayant Madugula on 4/13/15.
//  Copyright (c) 2015 Jayant Madugula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JMUserLocationObjects : NSObject < CLLocationManagerDelegate >
{
    
}

@property CLLocationManager* locationManager;

- (void)beginUpdatingData;

@end
