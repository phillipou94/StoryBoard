//
//  WritingViewController.m
//  Storyboard
//
//  Created by Phillip Ou on 8/2/14.
//  Copyright (c) 2014 Philip Ou. All rights reserved.
//

#import "WritingViewController.h"
#import <Parse/Parse.h>

@interface WritingViewController ()

@end

@implementation WritingViewController

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.textView.delegate = self;
    
    NSLog(@"%@",self.messageLocation);
    self.chosenImageView.image = self.chosenImage;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
-(void)dismissKeyboard {
    [self.textView resignFirstResponder];
    [self.titleTextField resignFirstResponder];
}
-(void) viewWillAppear:(BOOL)animated{
     //[self.chosenImageView setImage: self.chosenImage];
    
    
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
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}
- (IBAction)shareButton:(id)sender {
    PFObject *message = [PFObject objectWithClassName:@"Messages"];
    
    NSData *imageData = UIImageJPEGRepresentation(self.chosenImage, 0.7);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    message[@"file"] = imageFile;
    message[@"location"]=self.messageLocation;
    message[@"whoTook"]= [PFUser currentUser];
    message[@"whoTookId"]= [[PFUser currentUser]objectId];
    message[@"whoTookName"] =self.currentUser.username;
    if(self.titleTextField.text.length ==0){
        self.titleTextField.text = @"Untitled";
    }
    [message setObject: [self.titleTextField text] forKey:@"title"];
    
    [message setObject: [self.textView text] forKey:@"story"];
    
    
    [message saveInBackground];
    [self.tabBarController setSelectedIndex:0];
    
}

@end
