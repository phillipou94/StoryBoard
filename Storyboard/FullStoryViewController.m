//
//  FullStoryViewController.m
//  Storyboard
//
//  Created by Phillip Ou on 8/2/14.
//  Copyright (c) 2014 Philip Ou. All rights reserved.
//

#import "FullStoryViewController.h"
#import "ViewStoryViewController.h"
#import "Reachability.h"

@interface FullStoryViewController ()
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation FullStoryViewController

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
    [super viewDidLoad];
    
    [self.view setUserInteractionEnabled:YES];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButton:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    self.titleLabel.text = [self.selectedMessage objectForKey:@"title"];
    self.titleLabel.adjustsFontSizeToFitWidth=YES;
    self.textField.text = [self.selectedMessage objectForKey:@"story"];
    
    PFFile *imageFile = [self.selectedMessage objectForKey: @"file"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageFile.url]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MMM d yyyy" options:0 locale:nil];
    [formatter setDateFormat:dateFormat];
    
    self.dateLabel.text= [formatter stringFromDate:self.selectedMessage.createdAt];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.clipsToBounds = YES;
    [self.imageView setImage:[UIImage imageWithData:imageData]];
    

}

-(void)viewWillAppear:(BOOL)animated{
    if (![self connected]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There is no network connection" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        // connected, do some internet stuff
    }
    
    [super viewWillAppear:animated];
}

#pragma mark - Navigation

- (IBAction)backButton:(id)sender {
    
    [self performSegueWithIdentifier:@"back" sender:self];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    FullStoryViewController *viewController = [segue destinationViewController];
    viewController.selectedMessage = self.selectedMessage;

}

#pragma mark - Network

- (BOOL)connected{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


@end
