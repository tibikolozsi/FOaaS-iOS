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
#import "FOAASResponse.h"

@implementation FOAASManager

+ (void)getOperationsWithSuccess:(void (^)(id _Nullable))success
                         failure:(void (^)(NSError * _Nonnull))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://foaas.com/operations" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
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

+ (void)getResponseWithOperationString:(NSString *)operationString
                               success:(void (^)(FOAASResponse * _Nullable foasResponse))success
                               failure:(void (^)(NSError * _Nonnull error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString *getURLString = [NSString stringWithFormat:@"https://foaas.com%@", operationString];
    [manager GET:getURLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        FOAASResponse *response = [[FOAASResponse alloc] initWithJSON:JSON];
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end
