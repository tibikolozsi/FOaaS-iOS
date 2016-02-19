//
//  FOAASOperation.h
//  FOAAS
//
//  Created by Tibor Kolozsi on 19/02/16.
//  Copyright © 2016 FOAAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FOAASField.h"

@interface FOAASOperation : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSArray<FOAASField *> *fields;

- (instancetype)initWithJSON:(NSDictionary *)JSON;

@end
