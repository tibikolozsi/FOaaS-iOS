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

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


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
    return 400;
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
