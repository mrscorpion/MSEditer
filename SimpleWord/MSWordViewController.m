//
//  MSWordViewController.m
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/13.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "MSWordViewController.h"
#import "MSWordView.h"
#import "MSSegmentedControl.h"
#import "MSStyleSettingsController.h"
#import "MSImageSettingsController.h"
#import "MSTextStyle.h"
#import "MSParagraphConfig.h"
#import "NSTextAttachment+MSText.h"

@interface MSWordViewController () <UITextViewDelegate, UITextFieldDelegate, MSSegmentedControlDelegate, MSStyleSettingsControllerDelegate, MSImageSettingsControllerDelegate>

@property (nonatomic, assign) CGFloat keyboardSpacingHeight;
@property (nonatomic, strong) MSSegmentedControl *contentInputAccessoryView;

@property (nonatomic, readonly) UIStoryboard *MS_storyboard;
@property (nonatomic, strong) MSStyleSettingsController *styleSettingsViewController;
@property (nonatomic, strong) MSImageSettingsController *imageSettingsViewController;


@property (nonatomic, assign) CGFloat inputViewHeight;

@property (nonatomic, strong) MSTextStyle *currentTextStyle;
@property (nonatomic, strong) MSParagraphConfig *currentParagraphConfig;

@end

@implementation MSWordViewController
{
    NSRange _lastSelectedRange;
    BOOL _keepCurrentTextStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *items = @[
                       [UIImage imageNamed:@"ABC_icon"],
                       [UIImage imageNamed:@"style_icon"],
                       [UIImage imageNamed:@"img_icon"],
                       [UIImage imageNamed:@"@_icon"],
                       [UIImage imageNamed:@"comment_icon"],
                       [UIImage imageNamed:@"clear_icon"]
                       ];
    _contentInputAccessoryView = [[MSSegmentedControl alloc] initWithItems:items];
    _contentInputAccessoryView.delegate = self;
    _contentInputAccessoryView.changeSegmentManually = YES;
    _contentInputAccessoryView.backgroundColor = [UIColor orangeColor];
    
    _textView = [[MSWordView alloc] init];
    _textView.delegate = self;
    _textView.titleTextField.delegate = self;
    [self.view addSubview:_textView];
    _textView.backgroundColor = [UIColor lightTextColor];
    
    [self setCurrentParagraphConfig:[[MSParagraphConfig alloc] init]];
    [self setCurrentTextStyle:[MSTextStyle textStyleWithType:MSTextStyleFormatNormal]];
    [self updateParagraphTypingAttributes];
    [self updateTextStyleTypingAttributes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [_contentInputAccessoryView addTarget:self action:@selector(changeTextInputView:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutTextView];
    
    CGRect rect = self.view.bounds;
    rect.size.height = 40.f;
    self.contentInputAccessoryView.frame = rect;
}

- (void)layoutTextView {
    CGRect rect = self.view.bounds;
    rect.origin.y = [self.topLayoutGuide length];
    rect.size.height -= (rect.origin.y + self.keyboardSpacingHeight);
    self.textView.frame = rect;
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (self.keyboardSpacingHeight == keyboardSize.height) {
        return;
    }
    self.keyboardSpacingHeight = keyboardSize.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutTextView];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.keyboardSpacingHeight == 0) {
        return;
    }
    self.keyboardSpacingHeight = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutTextView];
    } completion:nil];
}

#pragma mark - <UITextViewDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length == 0) {
        textField.text = textField.placeholder;
    }
    self.textView.editable = NO;
    [textField resignFirstResponder];
    self.textView.editable = YES;
    return YES;
}

#pragma mark - <UITextViewDelegate>

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self.contentInputAccessoryView setSelectedSegmentIndex:0 animated:NO];
    _textView.inputAccessoryView = self.contentInputAccessoryView;
    [self.imageSettingsViewController reload];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    _textView.inputAccessoryView = nil;
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {

    if (_lastSelectedRange.location != textView.selectedRange.location) {
        
        if (_keepCurrentTextStyle) {
            // 如果当前行的内容为空，TextView 会自动使用上一行的 typingAttributes，所以在删除内容时，保持 typingAttributes 不变
            [self updateTextStyleTypingAttributes];
            [self updateParagraphTypingAttributes];
            _keepCurrentTextStyle = NO;
        }
        else {
            self.currentTextStyle = [self textStyleForSelection];
            self.currentParagraphConfig = [self paragraphForSelection];
            [self updateTextStyleTypingAttributes];
            [self updateParagraphTypingAttributes];
            [self reloadSettingsView];
        }
    }
    _lastSelectedRange = textView.selectedRange;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if (range.location == 0 && range.length == 0 && text.length == 0) {
        // 光标在第一个位置时，按下退格键，则删除段落设置
        self.currentParagraphConfig.indentLevel = 0;
        [self updateParagraphTypingAttributes];
    }
    _lastSelectedRange = NSMakeRange(range.location + text.length - range.length, 0);
    if (text.length == 0 && range.length > 0) {
        _keepCurrentTextStyle = YES;
    }
//    NSLog(@"%@", self.textView.attributedText);
    return YES;
}

#pragma mark - Change InputView

- (void)MS_segmentedControl:(MSSegmentedControl *)control didTapAtIndex:(NSInteger)index {
    
    if (index == control.numberOfSegments - 1) {
        [self.textView resignFirstResponder];
        return;
    }
    if (index != control.selectedSegmentIndex) {
        [control setSelectedSegmentIndex:index animated:YES];
    }
}

- (UIStoryboard *)MS_storyboard {
    static dispatch_once_t onceToken;
    static UIStoryboard *storyboard;
    dispatch_once(&onceToken, ^{
        storyboard = [UIStoryboard storyboardWithName:@"MSWord" bundle:nil];
    });
    return storyboard;
}

- (MSStyleSettingsController *)styleSettingsViewController {
    if (!_styleSettingsViewController) {
        _styleSettingsViewController = [self.MS_storyboard instantiateViewControllerWithIdentifier:@"style"];
        _styleSettingsViewController.textStyle = self.currentTextStyle;
        _styleSettingsViewController.delegate = self;
        _styleSettingsViewController.view.backgroundColor = [UIColor redColor];
    }
    return _styleSettingsViewController;
}

- (MSImageSettingsController *)imageSettingsViewController {
    if (!_imageSettingsViewController) {
        _imageSettingsViewController = [self.MS_storyboard instantiateViewControllerWithIdentifier:@"image"];
        
        // Q2: ToDo 这里怎么挂了？  -[UIViewController setDelegate:]: unrecognized selector sent to instance 0x1460142d0
        _imageSettingsViewController.delegate = self;
        _imageSettingsViewController.view.backgroundColor = [UIColor greenColor];
    }
    return _imageSettingsViewController;
}

- (void)changeTextInputView:(MSSegmentedControl *)control {
    
    CGRect rect = self.view.bounds;
    rect.size.height = self.keyboardSpacingHeight - CGRectGetHeight(self.contentInputAccessoryView.frame);
    switch (control.selectedSegmentIndex) {
        case 1:
        {
            UIView *inputView = [[UIView alloc] initWithFrame:rect];
            self.styleSettingsViewController.view.frame = rect;
            [inputView addSubview:self.styleSettingsViewController.view];
            self.textView.inputView = inputView;
            break;
        }
        case 2:
        {
            UIView *inputView = [[UIView alloc] initWithFrame:rect];
            self.imageSettingsViewController.view.frame = rect;
            [inputView addSubview:self.imageSettingsViewController.view];
            self.textView.inputView = inputView;
            break;
        }
        default:
            self.textView.inputView = nil;
            break;
    }
    [self.textView reloadInputViews];
}

#pragma mark - settings

// 刷新设置界面
- (void)reloadSettingsView {
    
    self.styleSettingsViewController.textStyle = self.currentTextStyle;
    [self.styleSettingsViewController setParagraphConfig:self.currentParagraphConfig];
    [self.styleSettingsViewController reload];
}

- (MSTextStyle *)textStyleForSelection {
    
    MSTextStyle *textStyle = [[MSTextStyle alloc] init];
    UIFont *font = self.textView.typingAttributes[NSFontAttributeName];
    NSDictionary<NSString *, id> *fontAttributes = font.fontDescriptor.fontAttributes;
    if (![font.fontName isEqualToString:[UIFont systemFontOfSize:15].fontName]) {
        // TODO: 通过fontName来判断粗体（待修改）
        textStyle.bold = YES;
    }
    if (fontAttributes[@"NSCTFontMatrixAttribute"]) {
        // 通过是否包含 matrix 判断斜体
        textStyle.italic = YES;
    }
    textStyle.fontSize = [fontAttributes[@"NSFontSizeAttribute"] floatValue];
    textStyle.textColor = self.textView.typingAttributes[NSForegroundColorAttributeName] ?: textStyle.textColor;
    if (self.textView.typingAttributes[NSUnderlineStyleAttributeName]) {
        textStyle.underline = [self.textView.typingAttributes[NSUnderlineStyleAttributeName] integerValue] == NSUnderlineStyleSingle;
    }
    return textStyle;
}

- (MSParagraphConfig *)paragraphForSelection {
    
    NSParagraphStyle *paragraphStyle = self.textView.typingAttributes[NSParagraphStyleAttributeName];
    MSParagraphType type = [self.textView.typingAttributes[MSParagraphTypeName] integerValue];
    MSParagraphConfig *paragraphConfig = [[MSParagraphConfig alloc] initWithParagraphStyle:paragraphStyle type:type];
    return paragraphConfig;
}

// 获取所有选中的段落，通过"\n"来判断段落。
- (NSArray *)rangesOfParagraphForCurrentSelection {
    
    NSRange selection = self.textView.selectedRange;
    NSInteger location;
    NSInteger length;
    
    NSInteger start = 0;
    NSInteger end = selection.location;
    NSRange range = [self.textView.text rangeOfString:@"\n"
                                              options:NSBackwardsSearch
                                                range:NSMakeRange(start, end - start)];
    location = (range.location != NSNotFound) ? range.location + 1 : 0;
    
    start = selection.location + selection.length;
    end = self.textView.text.length;
    range = [self.textView.text rangeOfString:@"\n"
                                      options:0
                                        range:NSMakeRange(start, end - start)];
    length = (range.location != NSNotFound) ? (range.location + 1 - location) : (self.textView.text.length - location);
    
    range = NSMakeRange(location, length);
    NSString *textInRange = [self.textView.text substringWithRange:range];
    NSArray *components = [textInRange componentsSeparatedByString:@"\n"];
    
    NSMutableArray *ranges = [NSMutableArray array];
    for (NSInteger i = 0; i < components.count; i++) {
        NSString *component = components[i];
        if (i == components.count - 1) {
            if (component.length == 0) {
                break;
            }
            else {
                [ranges addObject:[NSValue valueWithRange:NSMakeRange(location, component.length)]];
            }
        }
        else {
            [ranges addObject:[NSValue valueWithRange:NSMakeRange(location, component.length + 1)]];
            location += component.length + 1;
        }
    }
    if (ranges.count == 0) {
        return nil;
    }
    return ranges;
}

- (void)updateTextStyleTypingAttributes {
    NSMutableDictionary *typingAttributes = [self.textView.typingAttributes mutableCopy];
    typingAttributes[NSFontAttributeName] = self.currentTextStyle.font;
    typingAttributes[NSForegroundColorAttributeName] = self.currentTextStyle.textColor;
    typingAttributes[NSUnderlineStyleAttributeName] = @(self.currentTextStyle.underline ? NSUnderlineStyleSingle : NSUnderlineStyleNone);
    self.textView.typingAttributes = typingAttributes;
}

- (void)updateParagraphTypingAttributes {
    NSMutableDictionary *typingAttributes = [self.textView.typingAttributes mutableCopy];
    typingAttributes[MSParagraphTypeName] = @(self.currentParagraphConfig.type);
    typingAttributes[NSParagraphStyleAttributeName] = self.currentParagraphConfig.paragraphStyle;
    self.textView.typingAttributes = typingAttributes;
}

- (void)updateTextStyleForSelection {
    if (self.textView.selectedRange.length > 0) {
        [self.textView.textStorage addAttributes:self.textView.typingAttributes range:self.textView.selectedRange];
    }
}

- (void)updateParagraphForSelectionWithKey:(NSString *)key {
    NSRange selectedRange = self.textView.selectedRange;
    NSArray *ranges = [self rangesOfParagraphForCurrentSelection];
    if (!ranges) {
        if (self.currentParagraphConfig.type == 0) {
            NSMutableDictionary *typingAttributes = [self.textView.typingAttributes mutableCopy];
            typingAttributes[NSParagraphStyleAttributeName] = self.currentParagraphConfig.paragraphStyle;
            self.textView.typingAttributes = typingAttributes;
            return;
        }
        ranges = @[[NSValue valueWithRange:NSMakeRange(0, 0)]];
    }
    NSInteger offset = 0;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    for (NSValue *rangeValue in ranges) {
        
        NSRange range = NSMakeRange(rangeValue.rangeValue.location + offset, rangeValue.rangeValue.length);
        MSParagraphType type;
        if ([key isEqualToString:MSParagraphTypeName]) {
            
            type = self.currentParagraphConfig.type;
            if (self.currentParagraphConfig.type == MSParagraphTypeNone) {
                [attributedText deleteCharactersInRange:NSMakeRange(range.location, 1)];
                offset -= 1;
            }
            else {
                NSTextAttachment *textAttachment = [NSTextAttachment checkBoxAttachment];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
                [attributedString addAttributes:self.textView.typingAttributes range:NSMakeRange(0, 1)];
                [attributedText insertAttributedString:attributedString atIndex:range.location];
                offset += 1;
            }
            //            switch (self.currentParagraphConfig.type) {
            //                case MSParagraphTypeNone:
            //
            //                    break;
            //                case MSParagraphTypeNone:
            //
            //                    break;
            //                case MSParagraphTypeNone:
            //
            //                    break;
            //                case MSParagraphTypeNone:
            //
            //                    break;
            //            }
        }
        else {
            [attributedText addAttribute:NSParagraphStyleAttributeName value:self.currentParagraphConfig.paragraphStyle range:range];
        }
    }
    if (offset > 0) {
        _keepCurrentTextStyle = YES;
        selectedRange = NSMakeRange(selectedRange.location + 1, selectedRange.length + offset - 1);
    }
    self.textView.allowsEditingTextAttributes = YES;
    self.textView.attributedText = attributedText;
    self.textView.allowsEditingTextAttributes = NO;
    self.textView.selectedRange = selectedRange;
}

- (void)inserImage:(UIImage *)image {
    // textView 默认会有一些左右边距
    CGFloat width = CGRectGetWidth(self.textView.frame) - (self.textView.textContainerInset.left + self.textView.textContainerInset.right + 12.f);
    NSTextAttachment *textAttachment = [NSTextAttachment attachmentWithImage:image width:width];
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    [attributedString insertAttributedString:attachmentString atIndex:0];
    if (_lastSelectedRange.location != 0 &&
        ![[self.textView.text substringWithRange:NSMakeRange(_lastSelectedRange.location - 1, 1)] isEqualToString:@"\n"]) {
        // 上一个字符不为"\n"则图片前添加一个换行 且 不是第一个位置
        [attributedString insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:0];
    }
    [attributedString addAttributes:self.textView.typingAttributes range:NSMakeRange(0, attributedString.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    paragraphStyle.paragraphSpacingBefore = 8.f;
    paragraphStyle.paragraphSpacing = 8.f;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [attributedText replaceCharactersInRange:_lastSelectedRange withAttributedString:attributedString];
    self.textView.allowsEditingTextAttributes = YES;
    self.textView.attributedText = attributedText;
    self.textView.allowsEditingTextAttributes = NO;
}

#pragma mark - <MSStyleSettingsControllerDelegate>

- (void)MS_didChangedTextStyle:(MSTextStyle *)textStyle {
    
    self.currentTextStyle = textStyle;
    [self updateTextStyleTypingAttributes];
    [self updateTextStyleForSelection];
}

- (void)MS_didChangedParagraphIndentLevel:(NSInteger)level {
    
    self.currentParagraphConfig.indentLevel += level;
    
    NSRange selectedRange = self.textView.selectedRange;
    NSArray *ranges = [self rangesOfParagraphForCurrentSelection];
    if (ranges.count <= 1) {
        [self updateParagraphForSelectionWithKey:MSParagraphIndentName];
    }
    else {
        self.textView.allowsEditingTextAttributes = YES;
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
        for (NSValue *rangeValue in ranges) {
            NSRange range = rangeValue.rangeValue;
            self.textView.selectedRange = range;
            MSParagraphConfig *paragraphConfig = [self paragraphForSelection];
            paragraphConfig.indentLevel += level;
            [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphConfig.paragraphStyle range:range];
        }
        self.textView.attributedText = attributedText;
        self.textView.allowsEditingTextAttributes = NO;
        self.textView.selectedRange = selectedRange;
    }
    [self updateParagraphTypingAttributes];
}

- (void)MS_didChangedParagraphType:(NSInteger)type {
//    self.currentParagraphConfig.type = type;
//    
//    [self updateParagraphTypingAttributes];
//    [self updateParagraphForSelectionWithKey:MSParagraphTypeName];
}

#pragma mark - <MSImageSettingsControllerDelegate>

- (void)MS_imageSettingsController:(MSImageSettingsController *)viewController presentPreview:(UIViewController *)previewController {
    [self presentViewController:previewController animated:YES completion:nil];
}

- (void)MS_imageSettingsController:(MSImageSettingsController *)viewController insertImage:(UIImage *)image {
    // TODO: 会卡顿一下，可以先加载预览图，再替换
    [self inserImage:image];
    [self.textView resignFirstResponder];
    [self.textView scrollRangeToVisible:_lastSelectedRange];
}

- (void)MS_imageSettingsController:(MSImageSettingsController *)viewController presentImagePickerView:(UIViewController *)picker {
    [self presentViewController:picker animated:YES completion:nil];
}

//- (void)MS_imageSettingsController:(MSImageSettingsController *)viewController dismissImagePickerView:(UIViewController *)picker {
//    
//}

@end
