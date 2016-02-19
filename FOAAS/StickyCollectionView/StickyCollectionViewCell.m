//
//  StickyCollectionViewCell.m
//  FOAAS
//
//  Created by Tibor Kolozsi on 19/02/16.
//  Copyright © 2016 FOAAS. All rights reserved.
//

#import "StickyCollectionViewCell.h"

@interface StickyCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *customBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation StickyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.customBackgroundView.layer.cornerRadius = 12.f;
    self.customBackgroundView.layer.masksToBounds = YES;
}

@end
