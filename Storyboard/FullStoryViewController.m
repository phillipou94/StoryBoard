//
//  FullStoryViewController.m
//  Storyboard
//
//  Created by Phillip Ou on 8/2/14.
//  Copyright (c) 2014 Philip Ou. All rights reserved.
//

#import "FullStoryViewController.h"
#import "ViewStoryViewController.h"

@interface FullStoryViewController ()

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
    //self.navigationItem.
    //self.tabBarController.tabBar.hidden=NO;
    NSLog(@"here!: %@",self.selectedMessage);
    self.titleLabel.text = [self.selectedMessage objectForKey:@"title"];
    self.textField.text = [self.selectedMessage objectForKey:@"story"];
    
    PFFile *imageFile = [self.selectedMessage objectForKey: @"file"];
    
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageFile.url]];
    
    
    //self.imageView.image =
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.clipsToBounds = YES;
    [self.imageView setImage:[UIImage imageWithData:imageData]];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButton:(id)sender {
    //[self prepareForSegue:@"backToTab" sender:self];
    [self performSegueWithIdentifier:@"back" sender:self];
    
    
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