//
//  FeedCell.h
//  moment
//
//  Created by Mayank Jain on 9/22/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCell : UICollectionViewCell{
    IBOutlet UIImageView *imageView;
    IBOutlet UILabel *likesLabel;
    IBOutlet UILabel *captionLabel;
}


@property (strong, nonatomic) NSString * caption;
@property (strong, nonatomic) NSString * likes;
@property (strong, nonatomic) UIImage * image;
@property (strong, nonatomic) IBOutlet UIView *labelContainer;

-(void)hideCaption;
-(void)showCaption;

@end
