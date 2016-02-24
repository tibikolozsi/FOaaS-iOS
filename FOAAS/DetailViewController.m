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
#import <MMPulseView/MMPulseView.h>

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) MMPulseView *pulseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

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
    
    for (FOAASField *field in self.operation.fields) {
        NSLog(@"field: %@", field);
    }
    
    MMPulseView *pulseView = [[MMPulseView alloc] init];
    pulseView.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    pulseView.colors = @[(__bridge id)[UIColor colorWithRed:0.996 green:0.647 blue:0.008 alpha:1].CGColor,
                         (__bridge id)[UIColor colorWithRed:1 green:0.31 blue:0.349 alpha:1].CGColor];
    pulseView.colors = @[(__bridge id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor,
                         (__bridge id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor];
    
    
//    CGFloat posY = (CGRectGetHeight([ui])-320)/2/CGRectGetHeight(screenRect);
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
    
    NSDictionary *metrics = @{@"kButtonDiameter" : @(kButtonDiameter), @"kPulseDiameter" : @(kPulseDiameter)};
    NSDictionary *views = NSDictionaryOfVariableBindings(btn, _pulseView);

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
//    [self.bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[btn]-2" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
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
    MMPulseView *pulseView = self.pulseView;
    [pulseView startAnimation];

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
