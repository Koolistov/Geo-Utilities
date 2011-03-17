//
//  CLHeading+Text.m
//  Koolistov
//
//  Created by Johan Kool on 22-11-10.
//  Copyright 2010-2011 Koolistov. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are 
//  permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this list of 
//    conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright notice, this list 
//    of conditions and the following disclaimer in the documentation and/or other materials 
//    provided with the distribution.
//  * Neither the name of KOOLISTOV nor the names of its contributors may be used to 
//    endorse or promote products derived from this software without specific prior written 
//    permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
//  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
//  THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT 
//  OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
//  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
