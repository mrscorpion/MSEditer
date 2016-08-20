//
//  MSTextStyle.h
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/14.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MSTextStyleType) {
    MSTextStyleFormatNormal = 0,
    MSTextStyleFormatTitleSmall,
    MSTextStyleFormatTitleMedium,
    MSTextStyleFormatTitleLarge,
};

@interface MSTextStyle : NSObject

@property (nonatomic, assign) BOOL bold;
@property (nonatomic, assign) BOOL italic;
@property (nonatomic, assign) BOOL underline;

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, readonly) UIFont *font;

@property (nonatomic, readonly) MSTextStyleType type;
+ (instancetype)textStyleWithType:(MSTextStyleType)type;

@end
