//
//  FOAASField.h
//  FOAAS
//
//  Created by Tibor Kolozsi on 19/02/16.
//  Copyright © 2016 FOAAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FOAASField : NSObject

@property (nonatomic, strong) NSString *field;
@property (nonatomic, strong) NSString *name;

- (instancetype)initWithJSON:(NSDictionary *)JSON;

@end
