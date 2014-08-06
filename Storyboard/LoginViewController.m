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

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void) viewDidLoad{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
        [super viewDidLoad];
        // Do any additional setup after loading the view.
        
    }
-(void)dismissKeyboard {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
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
- (IBAction)login:(id)sender {
    NSString *username = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(username.length !=0 && password.length !=0){
        PFUser *user = [PFUser user];
        user.username = username;
        user.password = password;
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if(user){
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];}
            else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Check your username and password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            
        }];
        
            }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"One of the fields is empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }

    
}

- (IBAction)signup:(id)sender {
    NSString *username = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(username.length !=0 && password.length !=0){
        PFUser *user = [PFUser user];
        user.username = username;
        user.password = password;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error){
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error Signing Up" message:@"that username is taken, please try a new one" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
            }
        }];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"One of the fields is empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    
    

}


@end
