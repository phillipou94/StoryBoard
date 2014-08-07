//
//  CameraViewController.m
//  Storyboard
//
//  Created by Phillip Ou on 8/2/14.
//  Copyright (c) 2014 Philip Ou. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>
#import "WritingViewController.h"

@interface CameraViewController ()



@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *chosenImageView;
@property (weak, nonatomic) UIImage *chosenImage;
/*@property (weak,nonatomic) IBOutlet UITextField *titleTextField;*/
@property (nonatomic,strong) PFGeoPoint *messageLocation;

@end


@implementation CameraViewController

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
    self.whereAreYouTextField.delegate = self;
    [super viewDidLoad];
    
   
   
    // Do any additional setup after loading the view.
}
-(void)dismissKeyboard {
    [self.whereAreYouTextField resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    self.titleTextField.text = nil;
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    
    //crop image into a square like instagram
    
    self.imagePicker.allowsEditing=YES;
    //if device has camera show camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    //if not show library of photos
    else{
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    //pictures only
    self.imagePicker.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeImage, nil];
    
    [self presentViewController:self.imagePicker animated:NO completion:nil];
}
- (IBAction)share:(id)sender {
    if (self.chosenImageView.image){
        NSData *imageData = UIImagePNGRepresentation(self.chosenImageView.image);
        PFFile *photoFile = [PFFile fileWithData:imageData];
        PFObject *message = [PFObject objectWithClassName:@"Messages"];
        message[@"image"] = photoFile;    //create a data type where key "image" stores value photoFile;
        message[@"whoTook"]= [PFUser currentUser];
        message[@"whoTookId"]= [[PFUser currentUser]objectId];
        
        //groups!!!
        
        [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *erorr){
            if(!succeeded){
                [self showError];
            }
        }];
    }
    else{ [self showError];}
    [self clear];
    [self.tabBarController setSelectedIndex:0];
}

-(void) showError{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not post your photo, please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
//person finished taking picture
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.chosenImage = info[UIImagePickerControllerEditedImage];
    //NSLog(@"%@",self.chosenImage);
    self.chosenImageView.image = self.chosenImage;
    [self dismissViewControllerAnimated:YES completion: nil];
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        
        //NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
        self.messageLocation = geoPoint;
    }];
    
}
///person decides to cancel picture
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //go back to home screen and clear camera of data
    [self.tabBarController setSelectedIndex:0];
    [self clear];
    
}
-(void) clear{
    self.chosenImageView.image=nil;
    self.titleTextField.text=nil;
}

//every timescreen is touched in CameraViewController, this is activated

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.titleTextField resignFirstResponder]; //!!!resign first responder take away keyboard once photo chosen
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"transition"]){
    WritingViewController *viewController = [segue destinationViewController];
    //WritingViewController *viewController = [[WritingViewController alloc]init];
        //NSLog(@"%@",self.chosenImage);
    viewController.chosenImage=self.chosenImage;
    viewController.messageLocation = self.messageLocation;
    viewController.titleText= self.titleTextField.text;
        
  
        
    }
}
- (IBAction)backButton:(id)sender {
    [self clear];
    
    [self.tabBarController setSelectedIndex: 0];
}

- (IBAction)writeYourStory:(id)sender {
   
    [self performSegueWithIdentifier:@"transition" sender:self];
     [self clear];
}


- (IBAction)saveButton:(id)sender {
    PFObject *message = [PFObject objectWithClassName:@"SavedMessages"];
    
    NSData *imageData = UIImageJPEGRepresentation(self.chosenImage, 0.7);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    message[@"file"] = imageFile;
    message[@"location"]=self.messageLocation;
    message[@"whoTook"]= [PFUser currentUser];
    message[@"whoTookId"]= [[PFUser currentUser]objectId];
    message[@"title"] = self.titleTextField.text;
    
    [message saveInBackground];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Draft Saved"
                                                        message:@"Come back and edit it anytime"
                                                       delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:nil];
    [alertView show];
    
    
     [self.tabBarController setSelectedIndex: 0];
}


@end
