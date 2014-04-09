//
//  MDWampError.m
//  MDWamp
//
//  Created by Niko Usai on 08/03/14.
//  Copyright (c) 2014 mogui.it. All rights reserved.
//

#import "MDWampError.h"

@implementation MDWampError
- (id)initWithPayload:(NSArray *)payload
{
    self = [super init];
    if (self) {
        NSMutableArray *tmp = [payload mutableCopy];
        id first = [tmp shift];
        if ([first isKindOfClass:[NSString class]]) {
            // version 1 error
            self.callID = first;
            self.error = [tmp shift];
            self.errorDesc = [tmp shift];
            if ([tmp count] > 0) self.arguments = [tmp shift];
        } else {
            self.type = first;
            self.request = [tmp shift];
            self.details = [tmp shift];
            self.error = [tmp shift];
            if ([tmp count] > 0) self.arguments = [tmp shift];
            if ([tmp count] > 0) self.argumentsKw = [tmp shift];
        }
    }
    return self;
}


- (NSArray *)marshallFor:(MDWampVersion)version
{
    if (version == kMDWampVersion1) {
        if (!self.arguments) {
            return @[@4, self.callID, self.error, self.errorDesc];
        } else {
            return @[@4, self.callID, self.error, self.errorDesc, self.arguments];
        }
    } else {
        if (self.arguments && self.argumentsKw) {
            return @[@8, self.type, self.request, self.details, self.error,
                     self.arguments, self.argumentsKw ];
        } else if(self.arguments) {
            return @[@8, self.type, self.request, self.details, self.error,
                     self.arguments ];
        } else {
            return @[@8, self.type, self.request, self.details, self.error ];
        }
    }
}

@end