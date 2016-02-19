//
//  FOAASManager.m
//  FOAAS
//
//  Created by Tibor Kolozsi on 19/02/16.
//  Copyright © 2016 FOAAS. All rights reserved.
//

#import "FOAASManager.h"
#import <AFNetworking/AFNetworking.h>
#import "FOAASOperation.h"

@implementation FOAASManager

+ (void)getOperationsWithSuccess:(void (^)(id _Nullable))success
                         failure:(void (^)(NSError * _Nonnull))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://foaas.com/operations" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSMutableArray<FOAASOperation *> *operations = [[NSMutableArray alloc] init];
        for (id obj in responseObject) {
            FOAASOperation *operation = [[FOAASOperation alloc] initWithJSON:obj];
            [operations addObject:operation];
        }
        if (success) {
            success(operations);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error);
        }
    }];
}

@end
