//
//  SavedTableViewController.m
//  Storyboard
//
//  Created by Phillip Ou on 8/2/14.
//  Copyright (c) 2014 Philip Ou. All rights reserved.
//

#import "SavedTableViewController.h"
#import "SaveWritingViewController.h"

@interface SavedTableViewController ()

@end

@implementation SavedTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.currentUser = [PFUser currentUser];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void) viewDidAppear:(BOOL)animated{
    //[self loadObjects];
    
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(PFQuery*)queryForTable{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"SavedMessages"];
    // Interested in locations near user.
    
    // Limit what could be a lot of points.
    //query.limit = 10;
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    if(self.objects.count!=0){
        self.loadCount++;
        NSLog(@"searching");
        [query whereKey:@"sent" notEqualTo:@"sent"];
        [query whereKey:@"whoTookId" containsString: self.currentUser.objectId];
        [query orderByDescending:@"createdAt"];
        query.limit=20;
    }
    return query;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
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
    
    UILabel *dateLabel = (UILabel*) [cell viewWithTag:2];
    
    
   

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MMM d yyyy" options:0 locale:nil];
                                  
    [formatter setDateFormat:dateFormat];
  
    dateLabel.text= [formatter stringFromDate:message.createdAt];
    
    
    
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
    [self performSegueWithIdentifier:@"transition" sender:self];
    
    
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"transition"]){
        SaveWritingViewController *viewController = [segue destinationViewController];
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

@end