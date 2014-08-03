//
//  LoginViewController.m
//  Storyboard
//
//  Created by Phillip Ou on 8/2/14.
//  Copyright (c) 2014 Philip Ou. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "FeedViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([PFUser user]){
        NSLog(@"Logged in");
        [self dismissModalViewControllerAnimated:YES];
        [self.tabBarController setSelectedIndex:0];
        //[self performSegueWithIdentifier:@"loggedIn" sender:self];
               
        
    }
    
    PFLogInViewController *login = [[PFLogInViewController alloc]init];
    login.delegate = self;
    login.signUpController.delegate = self;
    login.fields = PFLogInFieldsDefault;
    [self presentModalViewController:login animated:YES];
    
}
-(void) viewDidLoad{
    
        [super viewDidLoad];
        // Do any additional setup after loading the view.
        
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
    }


-(void) loginViewcontroller: (PFLogInViewController *) logInController didLogInUser: (PFUser *)user{
    
    
    [self dismissModalViewControllerAnimated:YES];
    
}
-(void) logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user{
    [self dismissModalViewControllerAnimated:YES];
}


-(void) signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController{
    [self dismissModalViewControllerAnimated:YES];
}

    



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
