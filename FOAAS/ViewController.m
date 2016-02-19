//
//  ViewController.m
//  FOAAS
//
//  Created by Tibor Kolozsi on 18/02/16.
//  Copyright © 2016 FOAAS. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVSpeechSynthesizerDelegate>

@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    self.synthesizer.delegate = self;
    __weak ViewController *weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf speakText:@"Hello"];
    });
}

- (void)speakText:(NSString *)text {
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:text];
    //utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-au"];
    [self.synthesizer speakUtterance:utterance];
}


@end
