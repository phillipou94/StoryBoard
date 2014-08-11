//
//  SettingsViewController.m
//  Storyboard
//
//  Created by Phillip Ou on 8/6/14.
//  Copyright (c) 2014 Philip Ou. All rights reserved.
//

#import "SettingsViewController.h"
#import "FeedViewController.h"



@interface SettingsViewController ()
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSString *initialState;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property int preference;





@end



@implementation SettingsViewController

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
    self.currentUser = [PFUser currentUser];
    self.slider.value = self.searchRadius;
    self.slider.minimumValue = 0.2;
    self.slider.maximumValue = 10;
    self.radiusLabel.text=[NSString stringWithFormat: @"%.01f miles",self.searchRadius ];
    self.initialState= self.currentUser[@"Anonymous"];
    self.usernameLabel.text=self.currentUser.username;
    self.privacyPolicy.hidden=YES;
    
    //self.slider.continuous=NO;
    
   
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)sliderChanged:(id)sender
{
    
    float val = self.slider.value/1.0;
    self.radiusLabel.text = [NSString stringWithFormat:@"%.01f miles",val];
    self.searchRadius=val;
    [self.delegate recieveData:self.searchRadius];
    
    
}

- (IBAction)segmentChanged:(id)sender {
   // NSLog(@"%d",self.segmentController.selectedSegmentIndex);
    [self.preferenceDelegate receivePreference: self.segmentController.selectedSegmentIndex];
    //[self.delegate recieveData:self.segmentController.selectedSegmentIndex];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
 if([self.currentUser[@"Anonymous"]isEqualToString:@"Yes"]){
        [self.anonSwitch setOn:YES];
        self.anonymousLabel.hidden=NO;
     
    }
    else{
        [self.anonSwitch setOn:NO];
         self.anonymousLabel.hidden=YES;
        
    }
        self.preference=[self.currentUser[@"preferencesIndex"] integerValue];
    [self.segmentController setSelectedSegmentIndex:self.preference];

    [self.slider setValue:self.searchRadius];
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logout:(id)sender {
    [PFUser logOut];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *loginNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
    [self presentViewController:loginNavigationController animated:NO completion:nil];

    
    
}


-(void)viewWillDisappear:(BOOL)animated{
   
    if(self.anonSwitch.isOn){
        
        [self.currentUser setObject:@"Yes" forKey:@"Anonymous"];
        
    }
    else{
        [self.currentUser setObject:@"No" forKey:@"Anonymous"];
    }
    [self.currentUser setObject:[NSNumber numberWithInteger:self.segmentController.selectedSegmentIndex] forKey:@"preferencesIndex"];
    
    if(![self.initialState isEqualToString:self.currentUser[@"Anonymous"]]|| self.preference!=[self.currentUser[@"preferencesIndex"] intValue]){
        [self.currentUser saveInBackground];
        //NSLog(@"changed");
    }
    //NSLog(@"didn't change");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)showPrivacyPolicy:(id)sender {
    if(self.privacyPolicy.hidden==NO){
        self.privacyPolicy.hidden=YES;
    }
    else{
        self.privacyPolicy.hidden=NO;}
    
}


- (IBAction)anonSwitch:(id)sender {
    if(self.anonSwitch.isOn==NO){
        self.anonymousLabel.hidden=YES;
        
    }
    if(self.anonSwitch.isOn==YES){
        self.anonymousLabel.hidden=NO;
        
    }
}






@end
