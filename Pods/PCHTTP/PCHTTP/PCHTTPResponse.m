//
//  PCHTTPResponse.m
//
//  Created by Patrick Perini on 4/29/12.
//  Licensing information available in README.md
//

#import "PCHTTPResponse.h"

@implementation PCHTTPResponse

#pragma mark - Request Information
@synthesize requestURL;
@synthesize requestBody;

#pragma mark - Response Information
@synthesize status;
@synthesize data;

- (NSString *)string
{
    return [[NSString alloc] initWithData: data
                                 encoding: NSUTF8StringEncoding];
}

- (id)object
{
    if (!data) return nil;
    return [NSJSONSerialization JSONObjectWithData: data
                                           options: 0
                                             error: nil];
}

#pragma mark - Metadata
- (NSString *)description
{
    return [NSString stringWithFormat: @"%@ - %ld:\n\t%@", requestURL, status, data];
}

@end
