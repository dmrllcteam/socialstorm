//
//  UIImage+Base64Image.h
//  SocialRadar
//
//  Created by Mohit Singh on 28/06/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Base64Image)

+ (NSData *)base64DataFromString: (NSString *)string;
+ (NSString*)base64forData:(NSData*)theData;
@end
