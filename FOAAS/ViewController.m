//
//  ViewController.m
//  FOAAS
//
//  Created by Tibor Kolozsi on 18/02/16.
//  Copyright © 2016 FOAAS. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FOAASManager.h"
#import "FOAASOperation.h"
#import "StickyCollectionViewCell.h"
#import "UIColor+Hex.h"
#import <STPopup/STPopup.h>
#import "DetailViewController.h"

static const float kCellHeight = 100.f;
static const float kItemSpace = -20.f;
static NSString *kCellIdentifier = @"kCellIdentifier";

@interface ViewController () <AVSpeechSynthesizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic, strong) NSArray<FOAASOperation *> *operations;
@property (nonatomic, strong) NSArray<NSString *> *colorsArray;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) DetailViewController *currentDetailViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    self.synthesizer.delegate = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    __weak ViewController *weakSelf = self;

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [weakSelf speakText:@"Hello"];
//    });
    
    [FOAASManager getOperationsWithSuccess:^(id _Nullable operations) {
        weakSelf.operations = [NSArray arrayWithArray:operations];
        [weakSelf.collectionView reloadData];
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    self.colorsArray = @[@"EE5464", @"DC4352", @"FD6D50", @"EA583F", @"F6BC43", @"8DC253", @"4FC2E9", @"3CAFDB", @"5D9CEE", @"4B89DD", @"AD93EE", @"977BDD", @"EE87C0", @"D971AE", @"903FB1", @"9D56B9", @"227FBD", @"2E97DE"];
}

- (void)speakText:(NSString *)text {
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:text];
    //utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-au"];
    [self.synthesizer speakUtterance:utterance];
}

#pragma mark -=CollectionView datasource=-
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.operations.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StickyCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.customBackgroundView.backgroundColor = [self colorForIndexPath:indexPath];
    FOAASOperation *currentOperation = self.operations[indexPath.item];
    cell.titleLabel.text = currentOperation.name;
    
    return cell;
}

- (UIColor *)colorForIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = [UIColor colorFromHexString:self.colorsArray[indexPath.item % self.colorsArray.count]];
    return color;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FOAASOperation *currentOperation = self.operations[indexPath.item];

    self.currentDetailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewController"];
    self.currentDetailViewController.operation = currentOperation;
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:self.currentDetailViewController];
    [popupController setNavigationBarHidden:YES];
    UIView *containerView = [popupController containerView];
    containerView.backgroundColor = [UIColor clearColor];
    self.currentDetailViewController.view.backgroundColor = [self colorForIndexPath:indexPath];
    
    CGRect rect = CGRectMake(0, 0, self.currentDetailViewController.contentSizeInPopup.width, self.currentDetailViewController.contentSizeInPopup.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                     byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(12.0, 12.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    containerView.layer.mask = maskLayer;
    
    popupController.style = STPopupStyleBottomSheet;
    if (NSClassFromString(@"UIBlurEffect")) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        popupController.backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    }
    [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
    [popupController presentInViewController:self];
}

- (void)backgroundViewDidTap {
    __weak ViewController *weakSelf = self;
    [self.currentDetailViewController.popupController dismissWithCompletion:^{
        weakSelf.currentDetailViewController = nil;
    }];
}

#pragma mark -=CollectionView layout=-
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.view.bounds), kCellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kItemSpace;
}


@end
