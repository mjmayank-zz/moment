//
//  FeedCell.m
//  moment
//
//  Created by Mayank Jain on 9/22/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "FeedCell.h"

@implementation FeedCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 312, 312)];
//        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self insertSubview:self.imageView belowSubview:self.captionLabel];
//        self.captionLabel.text = self.caption;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) setLikes:(NSString *)likes
{
    likesLabel.text = likes;
}

-(void) setCaption:(NSString *)caption
{
    captionLabel.text = caption;
}

-(void) setImage:(UIImage *)image
{
    imageView.image = image;
}

-(void) hideCaption
{
    [self.labelContainer setHidden:YES];
}
-(void) showCaption
{
    [self.labelContainer setHidden:NO];
}

@end
