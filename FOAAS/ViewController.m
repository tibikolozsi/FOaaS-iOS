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
#import "DetailViewController.h"
#import "FOAAS-Bridging-Header.h"
#import "ElasticTransition.h"

static const float kCellHeight = 100.f;
static const float kItemSpace = -20.f;
static NSString *kCellIdentifier = @"kCellIdentifier";

@interface ViewController () <AVSpeechSynthesizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic, strong) NSArray<FOAASOperation *> *operations;
@property (nonatomic, strong) NSArray<NSString *> *colorsArray;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) FOAASOperation *currentOperation;
@property (nonatomic, strong) ElasticTransition *transition;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    self.synthesizer.delegate = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    __weak ViewController *weakSelf = self;
    
    self.transition = [[ElasticTransition alloc] init];
    self.transition.sticky = YES;
    self.transition.transformType = NONE;
    self.transition.edge = BOTTOM;

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
    cell.customBackgroundView.backgroundColor = [self colorForIndex:indexPath.item];
    FOAASOperation *currentOperation = self.operations[indexPath.item];
    cell.titleLabel.text = currentOperation.name;
    
    return cell;
}

- (UIColor *)colorForIndex:(NSUInteger)index {
    UIColor *color = [UIColor colorFromHexString:self.colorsArray[index % self.colorsArray.count]];
    return color;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentOperation = self.operations[indexPath.item];
    [self performSegueWithIdentifier:@"kDetailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"kDetailSegue"]) {
        DetailViewController *currentDetailViewController = (DetailViewController *)segue.destinationViewController;
        currentDetailViewController.transitioningDelegate = self.transition;
        currentDetailViewController.modalPresentationStyle = UIModalPresentationCustom;
        currentDetailViewController.operation = self.currentOperation;
        currentDetailViewController.backgroundColor = [self colorForIndex:[self.operations indexOfObject:self.currentOperation]];
        
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -=CollectionView layout=-
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.view.bounds), kCellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kItemSpace;
}


@end
