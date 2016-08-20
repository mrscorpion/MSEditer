//
//  MSStyleParagraphCell.m
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/13.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "MSStyleParagraphCell.h"

@interface MSStyleParagraphCell ()

@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UIButton *numberListButton;
@property (weak, nonatomic) IBOutlet UIButton *checkboxButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation MSStyleParagraphCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (UIButton *button in @[_listButton, _numberListButton, _checkboxButton, _leftButton, _rightButton]) {
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setType:(NSInteger)type {
    self.listButton.selected = type == 1;
    self.numberListButton.selected = type == 2;
    self.checkboxButton.selected = type == 3;
}

- (NSInteger)type {
    if (self.listButton.selected) {
        return 1;
    }
    else if (self.numberListButton.selected) {
        return 2;
    }
    else if (self.checkboxButton.selected) {
        return 3;
    }
    return 0;
}

- (BOOL)isList {
    return self.listButton.selected;
}

- (BOOL)isNumberList {
    return self.numberListButton.selected;
}

- (BOOL)isCheckBox {
    return self.checkboxButton.selected;
}

- (void)buttonAction:(UIButton *)sender {
    
    if (sender == self.leftButton) {
        [self.delegate MS_paragraphChangeIndentWithDirection:MSStyleIndentDirectionLeft];
    }
    else if (sender == self.rightButton) {
        [self.delegate MS_paragraphChangeIndentWithDirection:MSStyleIndentDirectionRight];
    }
    else {
        __block NSInteger type = 0;
        NSArray *buttons = @[self.listButton, self.numberListButton, self.checkboxButton];
        [buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            if (sender == button) {
                button.selected = !button.selected;
                if (button.selected) {
                    type = [@[self.listButton, self.numberListButton, self.checkboxButton] indexOfObject:button] + 1;
                }
                else {
                    type = 0;
                }
            }
            else {
                button.selected = NO;
            }
        }];
        [self.delegate MS_paragraphChangeType:type];
    }
}

@end
