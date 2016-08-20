//
//  MSStyleFontStyleCell.m
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/13.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "MSStyleFontStyleCell.h"

@interface MSStyleFontStyleCell ()

@property (weak, nonatomic) IBOutlet UIButton *boldButton;
@property (weak, nonatomic) IBOutlet UIButton *italicButton;
@property (weak, nonatomic) IBOutlet UIButton *underLineButton;

@end

@implementation MSStyleFontStyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (UIButton *button in @[_boldButton, _italicButton, _underLineButton]) {
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)buttonAction:(UIButton *)button {
    button.selected = !button.selected;
    
    NSDictionary *settings;
    if (button == self.boldButton) settings = @{ MSStyleSettingsBoldName: @(self.bold) };
    if (button == self.italicButton) settings = @{ MSStyleSettingsItalicName: @(self.italic) };
    if (button == self.underLineButton) settings = @{ MSStyleSettingsUnderlineName: @(self.underline) };
    [self.delegate MS_didChangeStyleSettings:settings];
}

- (void)setBold:(BOOL)bold {
    self.boldButton.selected = bold;
}

- (BOOL)bold {
    return self.boldButton.selected;
}

- (void)setItalic:(BOOL)italic {
    self.italicButton.selected = italic;
}

- (BOOL)italic {
    return self.italicButton.selected;
}

- (void)setUnderline:(BOOL)underline {
    self.underLineButton.selected = underline;
}

- (BOOL)underline {
    return self.underLineButton.selected;
}

@end
