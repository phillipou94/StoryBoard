//
//  FeedViewController.m
//  Storyboard
//
//  Created by Phillip Ou on 8/2/14.
//  Copyright (c) 2014 Philip Ou. All rights reserved.
//

#import "FeedViewController.h"
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "ViewStoryViewController.h"

@interface FeedViewController ()
@property (strong, nonatomic) IBOutlet UILabel *usernamelabel;

@end
static PFGeoPoint *geoPoint;

@implementation FeedViewController


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"This is called first");
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
            
            NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
            self.selfLocation=geoPoint;
            [self.currentUser setObject:geoPoint forKey:@"currentLocation"];
            [self.currentUser saveInBackground];
        }];
        
        
       /* // This table displays items in the Todo class
        self.parseClassName = @"Messages";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES; //allows scrolling down to load more pages*/
       
    }
    
    
    return self;
}

- (void)viewDidLoad
{
    
    
    
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIFont fontWithName:@"Verdana" size:20.0], NSFontAttributeName, nil]];
    
    if ([PFUser currentUser])
    {
        NSLog(@"we are logged in already");
        [self.tabBarController setSelectedIndex:0];
    }
    else
    {
        PFLogInViewController *loginView = [[PFLogInViewController alloc] init];
        loginView.delegate = self;
        [self presentViewController:loginView animated:NO completion:nil];
    }

    self.currentUser=[PFUser currentUser];
    self.usernamelabel.text = self.currentUser.username;
    self.tabBarController.tabBar.hidden=NO;
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        
        NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
        self.selfLocation=geoPoint;
        [self.currentUser setObject:geoPoint forKey:@"currentLocation"];
        [self.currentUser saveInBackground];
        
    }];
    [super viewDidLoad];
    self.messagesNear=[[NSMutableArray alloc]init];
    

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    
   
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CLLocationManager *)locationManager {
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDelegate:self];
    // [_locationManager setPurpose:@"Your current location is used to demonstrate PFGeoPoint and Geo Queries."];
    
    return self.locationManager;
}




-(PFQuery*)queryForTable{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    // Interested in locations near user.
    
    // Limit what could be a lot of points.
    //query.limit = 10;
   /* if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }*/
    if(self.objects.count!=0){
        NSLog(@"searching");
    [query whereKey:@"location" nearGeoPoint:self.selfLocation withinMiles:0.2];
    [query orderByDescending:@"createdAt"];
    NSLog(@"%@",self.messagesNear);
    query.limit=20;
    
    }
    return query;
}


- (IBAction)discoverButton:(id)sender {
    //get user location
    NSLog(@"button Pressed");
    self.loadCount++;
    
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        
            NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
        self.selfLocation=geoPoint;
            [self.currentUser setObject:geoPoint forKey:@"currentLocation"];
            [self.currentUser saveInBackground];
        
    }];
    
    [self loadObjects];
    
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    //return self.sections.allKeys.count;
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.objects count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.hidden = YES;
    if(self.loadCount!=0){
        cell.hidden=NO;
    }
  
    PFObject *message= self.objects[indexPath.row];
    
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:2];
    UILabel *nameLabel = (UILabel*)[cell viewWithTag:3];
    
    titleLabel.text= message[@"title"];
    titleLabel.adjustsFontSizeToFitWidth=YES;
    nameLabel.text = message[@"whoTookName"];
    nameLabel.adjustsFontSizeToFitWidth=YES;
    
    PFImageView *photo = (PFImageView *)[cell viewWithTag:1];
    
    photo.file = [message objectForKey:@"file"]; //save photo.file in key image
    //handles landscape
    int orientation = photo.image.imageOrientation;
    if(orientation ==0 || orientation ==1){
        photo.contentMode = UIViewContentModeScaleAspectFit;}
    [photo loadInBackground];
    
    
    cell.selected=NO;
    
    return cell;
}

-(void) tableView: (UITableViewCell *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%d",indexPath.row);
    self.selectedMessage= self.objects[indexPath.row];
    NSLog(@"%@",self.selectedMessage.objectId);
    [self performSegueWithIdentifier:@"transition" sender:self];
    
    
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"transition"]){
        ViewStoryViewController *viewController = [segue destinationViewController];
        //WritingViewController *viewController = [[WritingViewController alloc]init];
       
        viewController.selectedMessage = self.selectedMessage;
           }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)logout:(id)sender {
    [PFUser logOut];
    PFLogInViewController *loginView = [[PFLogInViewController alloc] init];
    loginView.delegate = self;
    [self presentViewController:loginView animated:NO completion:nil];
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
   

}

@end