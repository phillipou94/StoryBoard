//
//  FeedViewController.h
//  Storyboard
//
//  Created by Phillip Ou on 8/2/14.
//  Copyright (c) 2014 Philip Ou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SettingsViewController.h"
@interface FeedViewController : PFQueryTableViewController<CLLocationManagerDelegate,MyDataDelegate>
@property (strong, nonatomic) PFGeoPoint *selfLocation;
@property (strong, nonatomic) PFUser *currentUser;
+ (void)geoPointForCurrentLocationInBackground:(void ( ^ ) ( PFGeoPoint *geoPoint , NSError *error ))geoPointHandler;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *messagesNear;
@property (strong,nonatomic) PFObject *selectedMessage;
@property (strong, nonatomic) NSArray *photosArray;
@property int preferenceIndex;


@property int loadCount;


@property (strong, nonatomic) IBOutlet UIButton *discoverButton;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;


@end
