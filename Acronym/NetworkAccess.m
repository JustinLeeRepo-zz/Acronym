//
//  NetworkAccess.m
//  Acronym
//
//  Created by Justin Lee on 1/7/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

#import "NetworkAccess.h"

@interface NetworkAccess()

@end

@implementation NetworkAccess

+ (void) accessServer:(NSString *)acronym success:(void (^)(NSURLSessionTask *task, NSArray * responseObject))success failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure
{
	NSString *urlString = @"http://www.nactem.ac.uk/software/acromine/dictionary.py";
	
	AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
	NSDictionary *parameters = @{@"sf":acronym, @"lf": @""};
	[manager GET:urlString parameters:parameters progress:nil success:success failure:failure];
}



@end