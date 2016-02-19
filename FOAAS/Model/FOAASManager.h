//
//  FOAASManager.h
//  FOAAS
//
//  Created by Tibor Kolozsi on 19/02/16.
//  Copyright © 2016 FOAAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FOAASManager : NSObject

+ (void)getOperationsWithSuccess:(void (^)(id _Nullable))success
                         failure:(void (^)(NSError * _Nonnull))failure;

@end
