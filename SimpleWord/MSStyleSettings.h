//
//  MSStyleSettings.h
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/15.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#ifndef MSStyleSettings_h
#define MSStyleSettings_h

static NSString * const MSStyleSettingsBoldName = @"bold";
static NSString * const MSStyleSettingsItalicName = @"italic";
static NSString * const MSStyleSettingsUnderlineName = @"underline";
static NSString * const MSStyleSettingsFontSizeName = @"fontSize";
static NSString * const MSStyleSettingsTextColorName = @"textColor";
static NSString * const MSStyleSettingsFormatName = @"format";

@protocol MSStyleSettings <NSObject>

- (void)MS_didChangeStyleSettings:(NSDictionary *)settings;

@end

#endif /* MSStyleSettings_h */
