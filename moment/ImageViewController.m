//
//  ImageViewController.m
//  moment
//
//  Created by Mayank Jain on 9/21/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 320)];
//        CGRect frame = self.imageView.frame;
//        self.imageView2.frame = frame;
        self.imageView2.contentMode = UIViewContentModeScaleAspectFit;
//        
        [self.view addSubview:self.imageView2];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.imageView.image = self.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setCameraPic:(UIImage *)image{
    self.imageView2.image = image;
}

@end
