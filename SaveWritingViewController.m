//
//  SaveWritingViewController.m
//  Storyboard
//
//  Created by Phillip Ou on 8/2/14.
//  Copyright (c) 2014 Philip Ou. All rights reserved.
//

#import "SaveWritingViewController.h"
#import <Parse/Parse.h>
@interface SaveWritingViewController ()

@end

@implementation SaveWritingViewController

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
    NSLog(@"%@",self.selectedMessage.objectId);
    self.textView.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.textView.delegate = self;
    
    PFFile *imageFile = [self.selectedMessage objectForKey: @"file"];
    
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageFile.url]];
    
    
    self.chosenImageView.image = [UIImage imageWithData:imageData];
    

    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)dismissKeyboard {
    [self.textView resignFirstResponder];
    [self.titleTextField resignFirstResponder];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}
- (void)textViewDidChange:(UITextView *)textView {
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)shareButton:(id)sender {
    PFObject *message = [PFObject objectWithClassName:@"Messages"];
    
     PFFile *imageFile = [self.selectedMessage objectForKey: @"file"];
    message[@"file"] = imageFile;
    message[@"whoTook"]= [PFUser currentUser];
    message[@"whoTookId"]= [[PFUser currentUser]objectId];
    message[@"location"] = [self.selectedMessage objectForKey:@"location"];
    if(self.titleTextField.text.length ==0){
        self.titleTextField.text = @"Untitled";
    }
    [message setObject: [self.titleTextField text] forKey:@"title"];
    [message setObject: [self.textView text] forKey:@"story"];
    
    [message setObject:[[PFUser currentUser] username] forKey:@"whoTookName"];
    [message saveInBackground];
    
    [self.selectedMessage setObject: @"sent" forKey:@"sent"];
    [self.selectedMessage saveInBackground];
    //[self.tabBarController setSelectedIndex:0];
    [self reset];
    
}

-(void) reset{
    self.selectedMessage = nil;
    //[self.tabBarController setSelectedIndex:0];
     [self performSegueWithIdentifier:@"backToTab" sender:self];
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
