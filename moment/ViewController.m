//
//  ViewController.m
//  moment
//
//  Created by Mayank Jain on 9/21/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

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
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Feed"];
}

- (void)viewDidAppear:(BOOL)animated
{
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)takePhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"No Camera"
                                                              message:@"Using sample image"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];

        [myAlertView show];
        [self doesNotHaveCamera];
        return;
    }

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    ImageViewController * imageVC = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.navigationController pushViewController:imageVC animated:YES];
    imageVC.imageView.image = chosenImage;
    imageVC.photoInfo = info;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.imageView.image = [UIImage imageNamed:@"CameraFailureImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/* Sim only */
- (void)doesNotHaveCamera {
    ImageViewController * imageVC = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];
    UIImage *chosenImage = [UIImage imageNamed:@"CameraFailureImage"];
    [self.navigationController pushViewController:imageVC animated:YES];
    imageVC.imageView.image = chosenImage;
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:^{
            [self takePhoto];
    }];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL]; // Dismiss the PFSignUpViewController
}

@end
