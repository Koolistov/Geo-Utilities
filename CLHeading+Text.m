//
//  CLHeading+Text.m
//  Koolistov
//
//  Created by Johan Kool on 22-11-10.
//  Copyright 2010-2011 Koolistov. All rights reserved.
//

#import "CLHeading+Text.h"


@implementation CLHeading (Text)

+ (NSString *)kv_textualRepresentationForDirection:(CLLocationDirection)direction level:(NSUInteger)level localized:(BOOL)localized {
    NSParameterAssert(level > 0);
    NSParameterAssert(level < 5);

    // Direction smaller than 0.0 are invalid
    if (direction < 0.0) {
        return @"?";
    }
    
    // Load strings
    NSString *N, *E, *S, *W;
    if (localized) {
        N = NSLocalizedString(@"N", @"North letter");
        E = NSLocalizedString(@"E", @"East letter");
        S = NSLocalizedString(@"S", @"South letter");
        W = NSLocalizedString(@"W", @"West letter");
    } else {
        N = @"N";
        E = @"E";
        S = @"S";
        W = @"W";
    }

    // Calculate bin size
    double binSize = 360.0 / (4.0 * level);

    // Determine bin
    long int bin = lround(direction / binSize);

    // Adjust bin for level
    switch (level) {
        case 1:
            bin = bin * 8;
            break;
        case 2:
            bin = bin * 4;
            break;
        case 3:
            bin = bin * 2;
            break;
        case 4:
            bin = bin * 1;
            break;
    }

    // Return string for bin
    switch (bin) {
        case 0:
        case 32:
            return N;
            break;
        case 1:
            return [NSString stringWithFormat:@"%@%@%@%@", N, N, N, E];
            break;
        case 2:
            return [NSString stringWithFormat:@"%@%@%@", N, N, E];
            break;
        case 3:
            return [NSString stringWithFormat:@"%@%@%@%@%@", N, E, N, N, E];
            break;
        case 4:
            return [NSString stringWithFormat:@"%@%@", N, E];
            break;
        case 5:
            return [NSString stringWithFormat:@"%@%@%@%@%@", N, E, E, N, E];
            break;
        case 6:
            return [NSString stringWithFormat:@"%@%@%@", E, N, E];
            break;
        case 7:
            return [NSString stringWithFormat:@"%@%@%@%@", E, E, N, E];
            break;
        case 8:
            return E;
            break;
        case 9:
            return [NSString stringWithFormat:@"%@%@%@%@", E, E, S, E];
            break;
        case 10:
            return [NSString stringWithFormat:@"%@%@%@", E, S, E];
            break;
        case 11:
            return [NSString stringWithFormat:@"%@%@%@%@%@", S, E, E, S, E];
            break;
        case 12:
            return [NSString stringWithFormat:@"%@%@", S, E];
            break;
        case 13:
            return [NSString stringWithFormat:@"%@%@%@%@%@", S, E, S, S, E];
            break;
        case 14:
            return [NSString stringWithFormat:@"%@%@%@", S, S, E];
            break;
        case 15:
            return [NSString stringWithFormat:@"%@%@%@%@", S, S, S, E];
            break;
        case 16:
            return S;
            break;
        case 17:
            return [NSString stringWithFormat:@"%@%@%@%@", S, S, S, W];
            break;
        case 18:
            return [NSString stringWithFormat:@"%@%@%@", S, S, W];
            break;
        case 19:
            return [NSString stringWithFormat:@"%@%@%@%@%@", S, W, S, S, W];
            break;
        case 20:
            return [NSString stringWithFormat:@"%@%@", S, W];
            break;
        case 21:
            return [NSString stringWithFormat:@"%@%@%@%@%@", S, W, W, S, W];
            break;
        case 22:
            return [NSString stringWithFormat:@"%@%@%@", W, S, W];
            break;
        case 23:
            return [NSString stringWithFormat:@"%@%@%@%@", W, W, S, W];
            break;
        case 24:
            return W;
            break;
        case 25:
            return [NSString stringWithFormat:@"%@%@%@%@", W, W, N, W];
            break;
        case 26:
            return [NSString stringWithFormat:@"%@%@%@", W, N, W];
            break;
        case 27:
            return [NSString stringWithFormat:@"%@%@%@%@%@", N, W, W, N, W];
            break;
        case 28:
            return [NSString stringWithFormat:@"%@%@", N, W];
            break;
        case 29:
            return [NSString stringWithFormat:@"%@%@%@%@%@", N, W, N, N, W];
            break;
        case 30:
            return [NSString stringWithFormat:@"%@%@%@", N, N, W];
            break;
        case 31:
            return [NSString stringWithFormat:@"%@%@%@%@", N, N, N, W];
            break;
        default:
            break;
    }
    return @"?";
}

+ (NSString *)kv_textualRepresentationForDirection:(CLLocationDirection)direction {
    return [CLHeading kv_textualRepresentationForDirection:direction level:3 localized:NO];
}
+ (NSString *)kv_localizedTextualRepresentationForDirection:(CLLocationDirection)direction {
    return [CLHeading kv_textualRepresentationForDirection:direction level:3 localized:YES];
}

- (NSString *)kv_textualRepresentation {
    return [CLHeading kv_textualRepresentationForDirection:self.trueHeading level:3 localized:NO];
}
- (NSString *)kv_localizedTextualRepresentation {
    return [CLHeading kv_textualRepresentationForDirection:self.trueHeading level:3 localized:YES];
}

@end
