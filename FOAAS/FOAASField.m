//
//  FOAASField.m
//  FOAAS
//
//  Created by Tibor Kolozsi on 19/02/16.
//  Copyright © 2016 FOAAS. All rights reserved.
//

#import "FOAASField.h"

@implementation FOAASField

- (instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [super init];
    if (self) {
        self.field = JSON[@"field"];
        self.name = JSON[@"name"];
    }
    return self;
}

- (NSString *)description {
    NSMutableString *string = [NSMutableString stringWithFormat:@"{name %@, field: %@}", self.name, self.field];
    return string;
}


@end
