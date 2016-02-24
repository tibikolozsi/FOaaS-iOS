//
//  DetailViewController.m
//  FOAAS
//
//  Created by Tibor Kolozsi on 19/02/16.
//  Copyright © 2016 FOAAS. All rights reserved.
//

#import "DetailViewController.h"
#import "FOAAS-Bridging-Header.h"
#import "ElasticTransition.h"
#import "FOAASOperation.h"
#import "FOAASManager.h"
#import "FOAASResponse.h"
#import <MMPulseView/MMPulseView.h>

@interface DetailViewController ()

@property (nonatomic, strong) NSDictionary<NSString*, ParkedTextField *> *textFields;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) MMPulseView *pulseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@end

@implementation DetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.operation.name;
    self.bgView.backgroundColor = self.backgroundColor;
    
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.contentLength);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(12.0, 12.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = maskLayer;
    self.bgView.clipsToBounds = NO;
    
    MMPulseView *pulseView = [[MMPulseView alloc] init];
    pulseView.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    pulseView.colors = @[(__bridge id)[UIColor colorWithRed:0.996 green:0.647 blue:0.008 alpha:1].CGColor,
                         (__bridge id)[UIColor colorWithRed:1 green:0.31 blue:0.349 alpha:1].CGColor];
    pulseView.colors = @[(__bridge id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor,
                         (__bridge id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor];
    
    
    pulseView.startPoint = CGPointMake(0.5, 100.0);//posY);
    pulseView.endPoint = CGPointMake(0.5, 100.0f);// - posY);
    
    const CGFloat kButtonDiameter = 60;
    const CGFloat kPulseDiameter = 100;
    
    pulseView.minRadius = kButtonDiameter / 2.0;;
    pulseView.maxRadius = kPulseDiameter;
    
    pulseView.duration = 2;
    pulseView.count = 4;
    pulseView.lineWidth = 1.0f;
    self.pulseView = pulseView;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    self.pulseView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bgView addSubview:btn];
    [btn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [btn setTitle:@"Tap" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionPulse) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView insertSubview:self.pulseView belowSubview:btn];
    
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    
    NSDictionary *metrics = @{@"kButtonDiameter" : @(kButtonDiameter), @"kPulseDiameter" : @(kPulseDiameter)};
    NSDictionary *views = NSDictionaryOfVariableBindings(btn, _pulseView, _titleLabel);

    [self.bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pulseView]|" options:0 metrics:metrics views:views]];
    [self.bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pulseView(kPulseDiameter)]|" options:0 metrics:metrics views:views]];
    [self.bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn(kButtonDiameter)]" options:0 metrics:metrics views:views]];
    [self.bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[btn(kButtonDiameter)]" options:0 metrics:metrics views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.bgView
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0
                                                            constant:0.0]];
    [self.bgView addConstraint:[NSLayoutConstraint constraintWithItem:self.pulseView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:btn
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.0
                                                             constant:0.0]];
    [self.bgView addConstraint:[NSLayoutConstraint constraintWithItem:self.pulseView
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:btn
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0
                                                             constant:0.0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self addTextFields];
    
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.bgView addSubview:self.messageLabel];
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.textAlignment = NSTextAlignmentRight;
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bgView addSubview:self.subtitleLabel];
    
    ParkedTextField *lastParkedTextField = [self.textFields.allValues lastObject];
    NSDictionary *labelViews = NSDictionaryOfVariableBindings(_messageLabel, _subtitleLabel, _pulseView, lastParkedTextField);
    [self.bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_messageLabel]-|" options:0 metrics:nil views:labelViews]];
    [self.bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_subtitleLabel]-20-|" options:0 metrics:nil views:labelViews]];
    [self.bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastParkedTextField]-(>=80)-[_messageLabel]-[_subtitleLabel]-(>=12)-[_pulseView]" options:0 metrics:nil views:labelViews]];
    
}

- (void)addTextFields {
    UIView *viewForFields = self.bgView;
    NSMutableDictionary<NSString *, ParkedTextField *> *textFields = [[NSMutableDictionary alloc] initWithCapacity:self.operation.fields.count];
    for (FOAASField *field in self.operation.fields) {
        ParkedTextField *parkedTextField = [[ParkedTextField alloc] init];
        parkedTextField.parkedText = [NSString stringWithFormat:@":%@", field.name];
        parkedTextField.placeholderText = field.field;
        UIFont *font = [UIFont boldSystemFontOfSize:22];
        parkedTextField.font = font;
        parkedTextField.parkedTextFont = font;
        parkedTextField.translatesAutoresizingMaskIntoConstraints = NO;
        parkedTextField.textColor = [UIColor blackColor];
        parkedTextField.textAlignment = NSTextAlignmentCenter;
        
        [viewForFields addSubview:parkedTextField];
        [textFields setObject:parkedTextField forKey:field.field];
    }
    self.textFields = [NSDictionary dictionaryWithDictionary:textFields];
    
    NSArray *values = self.textFields.allValues;
    for (ParkedTextField *textField in values) {
        NSUInteger index = [values indexOfObject:textField];
        NSMutableDictionary *views = [NSMutableDictionary dictionaryWithDictionary:NSDictionaryOfVariableBindings(textField, _titleLabel)];
        [viewForFields addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textField]|" options:0 metrics:nil views:views]];
        if (index == 0) {
            [viewForFields addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]-20-[textField]" options:0 metrics:nil views:views]];
        } else {
            ParkedTextField *previousTextField = [values objectAtIndex:index - 1];
            [views setObject:previousTextField forKey:@"previousTextField"];
            [viewForFields addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousTextField]-12-[textField]" options:0 metrics:nil views:views]];
        }
    }
}

- (NSString *)parameterForField:(FOAASField *)field {
    NSString *parameter = [NSString stringWithFormat:@":%@",field.field];
    return parameter;
}

- (NSString *)textForField:(FOAASField *)field {
    NSString *text = self.textFields[field.field].typedText;
    return text;
}

- (NSString *)operationString {
    NSMutableString *operationString = [[NSMutableString alloc] initWithString:self.operation.url];
    for (FOAASField *field in self.operation.fields) {
        NSString *textForField = [self textForField:field];
        NSString *parameterForField = [self parameterForField:field];
        [operationString replaceOccurrencesOfString:parameterForField withString:textForField options:0 range:NSMakeRange(0, operationString.length)];
    }
    return operationString;
}



#pragma keyboard height

- (void)keyboardWillShow:(NSNotification *)note {
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    self.bottomConstraint.constant = CGRectGetHeight(keyboardBounds);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)note {
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    self.bottomConstraint.constant = 0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}


- (void)actionPulse {
    [self.view endEditing:YES];
    [self.pulseView startAnimation];
    
    [FOAASManager getResponseWithOperationString:[self operationString]
                                         success:^(FOAASResponse * _Nullable foaasResponse) {
                                             NSLog(@"%@",foaasResponse);
                                             self.messageLabel.text = foaasResponse.message;
                                             self.subtitleLabel.text = foaasResponse.subtitle;
                                         }
                                         failure:^(NSError * _Nonnull error) {
        
                                         }];
    
}

- (BOOL)dismissByBackgroundDrag {
    return YES;
}

- (BOOL)dismissByBackgroundTouch {
    return YES;
}

- (BOOL)dismissByForegroundDrag {
    return YES;
}

- (CGFloat)contentLength {
    return [UIScreen mainScreen].bounds.size.height;
}

- (void)commonInit {
//    self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, 400);
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

@end
