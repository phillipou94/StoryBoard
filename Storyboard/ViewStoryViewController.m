//
//  ViewStoryViewController.m
//  Storyboard
//
//  Created by Phillip Ou on 8/2/14.
//  Copyright (c) 2014 Philip Ou. All rights reserved.
//

#import "ViewStoryViewController.h"
#import "FullStoryViewController.h"
#import "Parse/Parse.h"

@interface ViewStoryViewController ()


@end

@implementation ViewStoryViewController

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
    
    [self.view setUserInteractionEnabled:YES];
    
    if([[self.selectedMessage objectForKey:@"story"] length]!=0){
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(fullStoryButton:)];
    
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    // [self.imageView addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeUp];}

    [super viewDidLoad];


    
    NSLog(@"%@",self.selectedMessage.objectId);
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated{
    self.titleLabel.text = [self.selectedMessage objectForKey:@"title"];
    self.storyView.text = [self.selectedMessage objectForKey:@"story"];
    
    PFFile *imageFile = [self.selectedMessage objectForKey: @"file"];
    
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageFile.url]];
    
    
    //self.imageView.image =
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.clipsToBounds = YES;
    [self.imageView setImage:[UIImage imageWithData:imageData]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fullStoryButton:(id)sender {
    
   [self performSegueWithIdentifier:@"fullStory" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"fullStory"]){
        FullStoryViewController *viewController = [segue destinationViewController];
        //WritingViewController *viewController = [[WritingViewController alloc]init];
        
        viewController.selectedMessage = self.selectedMessage;
    }
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

@end
