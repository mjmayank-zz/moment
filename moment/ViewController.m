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
}

- (void)viewDidAppear:(BOOL)animated
{
    [self takePhoto];
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
//    UIImage *chosenImage = [UIImage imageNamed:@"2009-10-01 08.42.24.jpg"];


    
    [self.navigationController pushViewController:imageVC animated:YES];
    imageVC.imageView2.image = chosenImage;
    // = [[UIImageView alloc] initWithImage:chosenImage];
    //    imageVC.imageView.image = chosenImage;
//    [imageVC.view setNeedsDisplay];
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [imageVC setCameraPic:chosenImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.imageView.image = [UIImage imageNamed:@"CameraFailureImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/* Sim only */
- (void)doesNotHaveCamera {
    self.imageView.image = [UIImage imageNamed:@"CameraFailureImage"];
}

@end
