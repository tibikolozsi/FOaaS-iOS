//
//  FOAASResponse.m
//  FOAAS
//
//  Created by Tibor Kolozsi on 24/02/16.
//  Copyright © 2016 FOAAS. All rights reserved.
//

#import "FOAASResponse.h"

@implementation FOAASResponse

- (instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [super init];
    if (self) {
        self.message = JSON[@"message"];
        self.subtitle = JSON[@"subtitle"];
    }
    
    return self;
}

- (NSString *)description {
    NSMutableString *string = [NSMutableString stringWithFormat:@"{message: %@, subtitle: %@}", self.message, self.subtitle];
    return string;
}

@end
