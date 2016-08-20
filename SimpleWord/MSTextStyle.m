//
//  MSTextStyle.m
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/14.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "MSTextStyle.h"

@interface MSTextStyle ()

@end

@implementation MSTextStyle

- (instancetype)init {
    if (self = [super init]) {
        _fontSize = [UIFont systemFontSize];
        _textColor = [UIColor blackColor];
    }
    return self;
}

+ (instancetype)textStyleWithType:(MSTextStyleType)type {
    
    MSTextStyle *textStyle = [[self alloc] init];
    switch (type) {
        case MSTextStyleFormatTitleSmall:
            textStyle.fontSize = 18.f;
            break;
        case MSTextStyleFormatTitleMedium:
            textStyle.fontSize = 24.f;
            break;
        case MSTextStyleFormatTitleLarge:
            textStyle.fontSize = 30.f;
            break;
        default:
            return textStyle;
    }
    textStyle.bold = type == MSTextStyleFormatNormal ? NO : YES;
    return textStyle;
}

#pragma mark - setter & getter

- (MSTextStyleType)type {
    if (self.bold == YES && self.italic == NO && self.underline == NO) {
        if (self.fontSize == 18.f) {
            return MSTextStyleFormatTitleSmall;
        }
        else if (self.fontSize == 24.f) {
            return MSTextStyleFormatTitleMedium;
        }
        else if (self.fontSize == 30.f) {
            return MSTextStyleFormatTitleLarge;
        }
    }
    return MSTextStyleFormatNormal;
}

- (UIFont *)font {
    UIFont *font = self.bold ? [UIFont boldSystemFontOfSize:self.fontSize] : [UIFont systemFontOfSize:self.fontSize];
    if (self.italic) {
        CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
        UIFontDescriptor *descriptor = [UIFontDescriptor fontDescriptorWithName:font.fontName matrix:matrix];
        font = [UIFont fontWithDescriptor:descriptor size:self.fontSize];        
    }
    return font;
}

@end
