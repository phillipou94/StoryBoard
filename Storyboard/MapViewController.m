//
//  MapViewController.m
//  Storyview
//
//  Created by Phillip Ou on 8/11/14.
//  Copyright (c) 2014 Philip Ou. All rights reserved.
//

#import "MapViewController.h"
#import <Parse/Parse.h>
#import "GeoPointAnnotation.h"
#import <math.h>
#import "FeedViewController.h"

@interface MapViewController ()

@property (strong,nonatomic) PFObject *selectedObject;

@end

@implementation MapViewController


- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d andSubtitle:(NSString *)sbtitle {
    self = [super init];
    
    if (self) {
        self.title = ttl;
        self.coordinate = c2d;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;

    [self.map setMapType:MKMapTypeStandard];
    [self.map setScrollEnabled:YES];
    [self.map setDelegate:self];

    self.slider.minimumValue = 0.2;
    self.slider.maximumValue = 10;
    [self.slider setValue:self.searchRadius];
    self.searchRadiusLabel.text = [NSString stringWithFormat:@"%.01f miles",self.slider.value];

    
    MKCoordinateRegion  user = { {0.0, 0.0} , {0.0, 0.0} };
    user.center.latitude = self.userLocation.latitude;
    user.center.longitude = self.userLocation.longitude;
    
    
    double scalingFactor = cos(2*3.14*self.userLocation.latitude/360.0);
    
    user.span.latitudeDelta=self.searchRadius/69.0;
    user.span.longitudeDelta=self.searchRadius/ABS(scalingFactor * 69.0);
   
    
    [self.map setRegion:user animated:YES];
    
    for (PFObject *object in self.objects) {
        GeoPointAnnotation *geoPointAnnotation = [[GeoPointAnnotation alloc]
                                                  initWithObject:object];
        geoPointAnnotation.objectAcquired = object;
        
        [self.map addAnnotation:geoPointAnnotation];
        
    }

}


-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKPinAnnotationView *MyPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    MyPin.pinColor = MKPinAnnotationColorRed;
    MyPin.draggable = NO;
    MyPin.highlighted = YES;
    MyPin.animatesDrop=TRUE;
    MyPin.canShowCallout = YES;
   
    
    return MyPin;
}



- (IBAction)sliderChanged:(id)sender {
   
 
    double scalingFactor = cos(2*3.14*self.userLocation.latitude/360.0);
    
    MKCoordinateRegion  user = { {0.0, 0.0} , {0.0, 0.0} };
    user.center.latitude = self.userLocation.latitude;
    user.center.longitude = self.userLocation.longitude;
    user.span.latitudeDelta=self.slider.value/69.0;
    user.span.longitudeDelta=self.slider.value/ABS(scalingFactor * 69.0);
    
    [self.map setRegion:user animated:TRUE];
    
    self.searchRadiusLabel.text = [NSString stringWithFormat:@"%.01f miles",self.slider.value];
    
    [self.delegate receiveDataFromMap:self.slider.value];
    
    
    
}



@end
