//
//  NSTextAttachment+MSText.h
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/16.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSTextAttachment (MSText)

+ (instancetype)checkBoxAttachment;
+ (instancetype)attachmentWithImage:(UIImage *)image width:(CGFloat)width;

@end
