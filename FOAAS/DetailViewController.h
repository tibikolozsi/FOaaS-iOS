//
//  DetailViewController.h
//  FOAAS
//
//  Created by Tibor Kolozsi on 19/02/16.
//  Copyright © 2016 FOAAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FOAASOperation.h"
#import "ElasticTransition.h"

@interface DetailViewController : UIViewController <ElasticMenuTransitionDelegate>

@property (nonatomic, strong) FOAASOperation *operation;

@property (nonatomic, strong) UIColor *backgroundColor;

@end
