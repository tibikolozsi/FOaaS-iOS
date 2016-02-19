//
//  StickyCollectionViewCell.h
//  FOAAS
//
//  Created by Tibor Kolozsi on 19/02/16.
//  Copyright © 2016 FOAAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickyCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic, readonly) UIView *customBackgroundView;
@property (weak, nonatomic, readonly) UILabel *titleLabel;

@end
