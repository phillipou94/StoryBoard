//
//  WritingViewController.h
//  Storyboard
//
//  Created by Phillip Ou on 8/2/14.
//  Copyright (c) 2014 Philip Ou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface WritingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *chosenImageView;
@property (strong, nonatomic) UIImage *chosenImage;
@property (nonatomic,strong) PFGeoPoint *messageLocation;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSString *titleText;

@property (strong, nonatomic) IBOutlet UIImageView *smallerImageView;
@property (strong, nonatomic) PFObject *selectedMessage;

@property (strong, nonatomic) IBOutlet UIButton *anonymousLabel;
@end
