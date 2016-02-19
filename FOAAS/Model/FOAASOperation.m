//
//  FOAASOperation.m
//  FOAAS
//
//  Created by Tibor Kolozsi on 19/02/16.
//  Copyright © 2016 FOAAS. All rights reserved.
//

#import "FOAASOperation.h"

@implementation FOAASOperation

- (instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [super init];
    if (self) {
        self.name = JSON[@"name"];
        self.url = JSON[@"url"];
        NSMutableArray *fields = [[NSMutableArray alloc] init];
        NSArray<NSDictionary *> *fieldsJSON = JSON[@"fields"];
        for (NSDictionary *fieldJSON in fieldsJSON) {
            FOAASField *field = [[FOAASField alloc] initWithJSON:fieldJSON];
            [fields addObject:field];
        }
        self.fields = [[NSArray alloc] initWithArray:fields];
    }
    return self;
}

- (NSString *)description {
    NSMutableString *string = [NSMutableString stringWithFormat:@"{name %@, url: %@, fields: %@}", self.name, self.url, self.fields];
    return string;
}

@end
