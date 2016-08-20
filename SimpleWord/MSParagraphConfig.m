//
//  MSParagraphStyle.m
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/15.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "MSParagraphConfig.h"

NSString * const MSParagraphTypeName = @"MSParagraphType";
NSString * const MSParagraphIndentName = @"MSParagraphIndent";

@implementation MSParagraphConfig

static CGFloat const kIndentPerLevel = 40.f;
static NSInteger const kMaxIndentLevel = 6;

- (instancetype)init {
    if (self = [super init]) {
        _type = MSParagraphTypeNone;
        _indentLevel = 0;
    }
    return self;
}

- (instancetype)initWithParagraphStyle:(NSParagraphStyle *)paragraphStyle type:(MSParagraphType)type {
    if (self = [super init]) {
        _indentLevel = paragraphStyle.headIndent / kIndentPerLevel;
    }
    return self;
}

- (void)setIndentLevel:(NSInteger)indentLevel {
    if (indentLevel < 0) {
        indentLevel = 0;
    }
    else if (indentLevel > kMaxIndentLevel) {
        indentLevel = kMaxIndentLevel;
    }
    _indentLevel = indentLevel;    
}

- (NSParagraphStyle *)paragraphStyle {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    paragraphStyle.headIndent = kIndentPerLevel * self.indentLevel;
    paragraphStyle.firstLineHeadIndent = kIndentPerLevel * self.indentLevel;
    return paragraphStyle;
}

@end
