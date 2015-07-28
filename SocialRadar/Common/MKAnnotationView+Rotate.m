//
//  MKAnnotationView+Rotate.m
//  SocialRadar
//
//  Created by Amrit Pandey on 27/06/13.
//  Copyright (c) 2013 RRInnovation LLC. All rights reserved.
//

#import "MKAnnotationView+Rotate.h"
#import <objc/runtime.h>

static char UIB_PROPERTY_KEY_INDEX;

@implementation MKAnnotationView (Rotate)

@dynamic imgView;

-(void)rotate
{
    static int count = 0;
    
    // MKAnnotationView *pinView =(MKAnnotationView *) [mapView viewWithTag:1];
    //UIImageView *pinView = (UIImageView *)[mapViewHome viewWithTag:5];
    
    //self.image = self.imgView.image;
    
    count = count+1;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(count);
    [self.imgView setTransform:rotate];
    
    if (count==360)
    {
        count=0;
    }
    
    [self performSelector:@selector(rotate) withObject:self afterDelay:.3];
}

-(void) setImgView:(UIImageView *)imgView
{
    
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY_INDEX, imgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.imgView.tag = 100;
    
    CGRect rect = self.imgView.frame;
    rect.origin.x -= 10;
    rect.origin.y -= 10;
    self.imgView.frame = rect;
    
    if ([self viewWithTag:100] == nil)
    {
        [self addSubview:self.imgView];
    }
    
    

}

-(UIImageView*) imgView
{
    return (UIImageView*)objc_getAssociatedObject(self, &UIB_PROPERTY_KEY_INDEX);
}

@end
