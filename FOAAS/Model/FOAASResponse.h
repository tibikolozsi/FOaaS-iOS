//
//  FOAASResponse.h
//  FOAAS
//
//  Created by Tibor Kolozsi on 24/02/16.
//  Copyright © 2016 FOAAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FOAASResponse : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *subtitle;

- (instancetype)initWithJSON:(NSDictionary *)JSON;

@end
