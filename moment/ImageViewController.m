//
//  ImageViewController.m
//  moment
//
//  Created by Mayank Jain on 9/21/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "ImageViewController.h"
#import "MomentAnnotation.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#define METERS_PER_MILE 1609.344

@interface ImageViewController ()

@property (strong, nonatomic) MomentAnnotation* myAnnotation;
@property BOOL didAddAnnotation;

@end

@implementation ImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 320)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view insertSubview:self.imageView belowSubview:self.textField];
        _didAddAnnotation = NO;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.textField.delegate = self;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated: YES];
    UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = save;
    save.enabled=TRUE;

    if (!_didAddAnnotation) {
        _didAddAnnotation = YES;
        CLLocationCoordinate2D zoomLocation = [[AppDelegate sharedLocationManager] location].coordinate;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        [_mapView setRegion:viewRegion animated:YES];

        _myAnnotation = [[MomentAnnotation alloc] init];
        _myAnnotation.coordinate = zoomLocation;
        _myAnnotation.title = @"Photo";
        [_mapView addAnnotation:_myAnnotation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePressed:(id)sender{
    ((UIBarButtonItem *)sender).enabled = NO;
    UIImage *image = [self.photoInfo objectForKey:@"UIImagePickerControllerEditedImage"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    [self uploadImage:imageData];
}

- (IBAction)postPost:(id)sender;
{
    // Create a PFGeoPoint using the user's location
    PFGeoPoint *currentPoint = [PFGeoPoint geoPointWithLatitude:_myAnnotation.coordinate.latitude
                                                      longitude:_myAnnotation.coordinate.longitude];

    FMDatabase * db = ((AppDelegate *)[UIApplication sharedApplication].delegate).db;
    NSString * query = [NSString stringWithFormat:@"INSERT INTO Photos VALUES (%f, %f", _myAnnotation.coordinate.latitude, _myAnnotation.coordinate.longitude];
    [db executeQuery:query];

    // Create a PFObject using the Post class and set the values we extracted above
    PFObject *postObject = [PFObject objectWithClassName:@kParseObjectClassKey];
    [postObject setObject:currentPoint forKey:@kParseObjectGeoKey];

    // Set the access control list on the postObject to restrict future modifications
    // to this object
    PFACL *readOnlyACL = [PFACL ACL];
    [readOnlyACL setPublicReadAccess:YES]; // Create read-only permissions
    [readOnlyACL setPublicWriteAccess:NO];
    [postObject setACL:readOnlyACL]; // Set the permissions on the postObject
}

- (void)uploadImage:(NSData *)imageData{
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    //HUD creation here (see example for code)
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    
    // Set determinate mode
    self.HUD.mode = MBProgressHUDModeDeterminate;
    self.HUD.delegate = self;
    self.HUD.labelText = @"Uploading";
    [self.HUD show:YES];
    
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:imageData forKey:@"image"];
    __block NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDictionary *parameters = @{@"foo": array};
    
    [manager POST:[kIPAdresss stringByAppendingString:@"/upload"] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //        [formData appendPartWithFormData:imageData name:@"file"];
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        param = [@{@"title": self.textField.text,
                                                                @"geoLong": [NSString stringWithFormat:@"%f", _myAnnotation.coordinate.longitude],
                                                                @"geoLat": [NSString stringWithFormat:@"%f", _myAnnotation.coordinate.latitude],
                                                                @"image_url": responseObject[@"image_url"],
                                                                @"slug": responseObject[@"slug"]} mutableCopy];
        
//        NSURL *url = [NSURL URLWithString:@"http://someurl.com/"];
//        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
//        // don't forget to set parameterEncoding!
//        httpClient.parameterEncoding = AFJSONParameterEncoding;
//        NSDictionary *params = @{@"key" : @"value"};
//        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:params];
//        AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:nil failure:nil];
//        [operation start];
        
        NSString * paramextenstion = [NSString stringWithFormat:@"/create?title=%@&geoLong=%@&geoLat=%@&image_url=%@&slug=%@", self.textField.text, [NSString stringWithFormat:@"%f", _myAnnotation.coordinate.longitude], [NSString stringWithFormat:@"%f", _myAnnotation.coordinate.latitude], responseObject[@"image_url"], responseObject[@"slug"]];
        
        
        
        [manager POST:[[kIPAdresss stringByAppendingString:paramextenstion] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@kParseObjectClassKey];
            [userPhoto setObject:imageFile forKey:@kParseObjectImageKey];

            // Create a PFGeoPoint using the user's location and associate it
            PFGeoPoint *currentPoint = [PFGeoPoint geoPointWithLatitude:_myAnnotation.coordinate.latitude
                                                              longitude:_myAnnotation.coordinate.longitude];
            [userPhoto setObject:currentPoint forKey:@kParseObjectGeoKey];

            // Associate this PFObject with the current user
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@kParseObjectUserKey];
            if(![self.textField.text isEqualToString:@""]){
                [userPhoto setObject:self.textField.text forKey:@kParseObjectCaption];
            }

            // Set the access control list to current user for security purposes
//            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];

            // Save this in background
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else {
            [self.HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        self.HUD.progress = (float)percentDone/100;
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [self.HUD removeFromSuperview];
    self.HUD = nil;
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
    //    self.view.backgroundColor = [UIColor aquaColor];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self animateTextField:self.textField up:YES withInfo:notification.userInfo];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self animateTextField:self.textField up:NO withInfo:notification.userInfo];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up withInfo:(NSDictionary *)userInfo
{
    const int movementDistance = 30; // tweak as needed
    NSTimeInterval movementDuration;
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&movementDuration]; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationCurve: animationCurve];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
