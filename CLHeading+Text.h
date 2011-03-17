//
//  CLHeading+Text.h
//  Koolistov
//
//  Created by Johan Kool on 22-11-10.
//  Copyright 2010-2011 Koolistov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CLHeading (Text)

+ (NSString *)kv_textualRepresentationForDirection:(CLLocationDirection)direction level:(NSUInteger)level localized:(BOOL)localized;
+ (NSString *)kv_textualRepresentationForDirection:(CLLocationDirection)direction;
+ (NSString *)kv_localizedTextualRepresentationForDirection:(CLLocationDirection)direction;

- (NSString *)kv_textualRepresentation;
- (NSString *)kv_localizedTextualRepresentation;

@end
