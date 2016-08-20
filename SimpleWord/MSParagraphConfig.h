//
//  MSParagraphStyle.h
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/15.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const MSParagraphTypeName;
extern NSString * const MSParagraphIndentName;

typedef NS_ENUM(NSUInteger, MSParagraphType) {
    MSParagraphTypeNone = 0,
    MSParagraphTypeList,
    MSParagraphTypeNumberList,
    MSParagraphTypeCheckbox
};

@interface MSParagraphConfig : NSObject

@property (nonatomic, assign) MSParagraphType type;
@property (nonatomic, assign) NSInteger indentLevel;

@property (nonatomic, readonly) NSParagraphStyle *paragraphStyle;

- (instancetype)initWithParagraphStyle:(NSParagraphStyle *)paragraphStyle type:(MSParagraphType)type;

@end
