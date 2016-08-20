//
//  NSTextAttachment+MSText.m
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/16.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "NSTextAttachment+MSText.h"
#import "MSParagraphConfig.h"

@implementation NSTextAttachment (MSText)

+ (instancetype)checkBoxAttachment {
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.bounds = CGRectMake(0, 0, 20, 20);
    textAttachment.image = [self imageWithType:MSParagraphTypeCheckbox];
    return textAttachment;
}

+ (instancetype)attachmentWithImage:(UIImage *)image width:(CGFloat)width {
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];    
    CGRect rect = CGRectZero;
    rect.size.width = width;
    rect.size.height = width * image.size.height / image.size.width;
    textAttachment.bounds = rect;
    textAttachment.image = image;
    return textAttachment;
}

+ (UIImage *)imageWithType:(MSParagraphType)type {
    
    CGRect rect = CGRectMake(0, 0, 20, 20);
    UIGraphicsBeginImageContext(rect.size);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor redColor] setStroke];
    path.lineWidth = 2.f;
    [path stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
