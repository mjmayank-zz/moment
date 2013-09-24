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
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 312, 312)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
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

@end
