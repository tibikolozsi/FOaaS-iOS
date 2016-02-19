//
//  DetailViewController.m
//  FOAAS
//
//  Created by Tibor Kolozsi on 19/02/16.
//  Copyright © 2016 FOAAS. All rights reserved.
//

#import "DetailViewController.h"
#import <STPopup/STPopup.h>

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation DetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.operation.name;
}

- (void)commonInit {
    self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, 400);
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
