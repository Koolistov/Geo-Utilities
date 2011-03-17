//
//  CLLocation+Navigation.m
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

//
// This is an adaptation of the work done by Chris Veness (Attribution 3.0 Unported (CC BY 3.0)):
// Latitude/longitude spherical geodesy formulae & scripts (c) Chris Veness 2002-2010  
// http://www.movable-type.co.uk/scripts/latlong.html
//

#import "CLLocation+Navigation.h"

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (x * (180.0 / M_PI))
#define EARTH_RADIUS 6371009.0; // Earth radius in meters (same unit as d) (Using mean radius as defined on Wikipedia)

@implementation CLLocation (Navigation)

#pragma mark Circle Paths
- (CLLocationDistance)kv_distanceUsingHaversineAlongCirclePathToCoordinate:(CLLocationCoordinate2D)destination {
// Haversine formula:
//
//    R = earth’s radius (mean radius = 6,371km)
//    Δlat = lat2− lat1
//    Δlong = long2− long1
//    a = sin²(Δlat/2) + cos(lat1).cos(lat2).sin²(Δlong/2)
//    c = 2.atan2(√a, √(1−a))
//    d = R.c
//
//    (Note that angles need to be in radians to pass to trig functions).
//
// JavaScript:
//    var R = 6371; // km
//    var dLat = (lat2-lat1).toRad();
//    var dLon = (lon2-lon1).toRad();
//    var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
//    Math.cos(lat1.toRad()) * Math.cos(lat2.toRad()) *
//    Math.sin(dLon/2) * Math.sin(dLon/2);
//    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
//    var d = R * c;

    double lat1 = degreesToRadians(self.coordinate.latitude);
    double lon1 = degreesToRadians(self.coordinate.longitude);
    double lat2 = degreesToRadians(destination.latitude);
    double lon2 = degreesToRadians(destination.longitude);
    double R = EARTH_RADIUS;
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;
    double a = sin(dLat / 2.0) * sin(dLat / 2.0) + cos(lat1) * cos(lat2) * sin(dLon / 2.0) * sin(dLon / 2.0);
    double c = 2.0 * atan2(sqrt(a), sqrt(1.0 - a));
    double d = R * c;

    return d;
}

- (CLLocationDistance)kv_distanceUsingSphericalLawOfCosinesAlongCirclePathToCoordinate:(CLLocationCoordinate2D)destination {
// Spherical law
// of cosines:	d = acos(sin(lat1).sin(lat2)+cos(lat1).cos(lat2).cos(long2−long1)).R
// JavaScript:
// var R = 6371; // km
// var d = Math.acos(Math.sin(lat1)*Math.sin(lat2) +
//                  Math.cos(lat1)*Math.cos(lat2) *
//                  Math.cos(lon2-lon1)) * R;

    double lat1 = degreesToRadians(self.coordinate.latitude);
    double lon1 = degreesToRadians(self.coordinate.longitude);
    double lat2 = degreesToRadians(destination.latitude);
    double lon2 = degreesToRadians(destination.longitude);
    double R = EARTH_RADIUS;
    double dLon = lon2 - lon1;
    double d = acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(dLon)) * R;

    return d;
}

- (CLLocationDirection)kv_intialBearingOnCirclePathToCoordinate:(CLLocationCoordinate2D)destination {
// Formula:	θ =	atan2(	sin(Δlong).cos(lat2),
//                      cos(lat1).sin(lat2) − sin(lat1).cos(lat2).cos(Δlong) )
// JavaScript:
//    var y = Math.sin(dLon) * Math.cos(lat2);
//    var x = Math.cos(lat1)*Math.sin(lat2) -
//    Math.sin(lat1)*Math.cos(lat2)*Math.cos(dLon);
//    var brng = Math.atan2(y, x).toDeg();

    double lat1 = degreesToRadians(self.coordinate.latitude);
    double lon1 = degreesToRadians(self.coordinate.longitude);
    double lat2 = degreesToRadians(destination.latitude);
    double lon2 = degreesToRadians(destination.longitude);
    double dLon = lon2 - lon1;
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double bearing = atan2(y, x);

    return fmod((radiansToDegrees(bearing) + 360.0), 360.0);
}

- (CLLocationDirection)kv_finalBearingOnCirclePathToCoordinate:(CLLocationCoordinate2D)destination {
    // Calculate initial bearing of reverse path
    double lat1 = degreesToRadians(destination.latitude);
    double lon1 = degreesToRadians(destination.longitude);
    double lat2 = degreesToRadians(self.coordinate.latitude);
    double lon2 = degreesToRadians(self.coordinate.longitude);
    double dLon = lon2 - lon1;
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double bearing = atan2(y, x);
    double initialBearingReversePath = fmod((radiansToDegrees(bearing) + 360.0), 360.0);

    // Flip result
    return fmod((initialBearingReversePath + 180.0), 360.0);
}

- (CLLocationCoordinate2D)kv_midPointOnCirclePathToCoordinate:(CLLocationCoordinate2D)destination {
// Formula:	Bx = cos(lat2).cos(Δlong)
//    By = cos(lat2).sin(Δlong)
//    latm = atan2(sin(lat1) + sin(lat2), √((cos(lat1)+Bx)² + By²))
//    lonm = lon1 + atan2(By, cos(lat1)+Bx)
// JavaScript:
//    var Bx = Math.cos(lat2) * Math.cos(dLon);
//    var By = Math.cos(lat2) * Math.sin(dLon);
//    var lat3 = Math.atan2(Math.sin(lat1)+Math.sin(lat2),
//                          Math.sqrt( (Math.cos(lat1)+Bx)*(Math.cos(lat1)+Bx) + By*By) );
//    var lon3 = lon1 + Math.atan2(By, Math.cos(lat1) + Bx);

    double lat1 = degreesToRadians(self.coordinate.latitude);
    double lon1 = degreesToRadians(self.coordinate.longitude);
    double lat2 = degreesToRadians(destination.latitude);
    double lon2 = degreesToRadians(destination.longitude);
    double dLon = lon2 - lon1;
    double x = cos(lat2) * cos(dLon);
    double y = cos(lat2) * sin(dLon);
    double lat3 = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + x) * (cos(lat1) + x) + y * y));
    double lon3 = lon1 + atan2(y, cos(lat1) + x);
    CLLocationCoordinate2D midPoint = CLLocationCoordinate2DMake(radiansToDegrees(lat3), radiansToDegrees(lon3));

    return midPoint;
}

- (CLLocationCoordinate2D)kv_destinationCoordinateOnCirclePathUsingInitialBearing:(CLLocationDirection)initialBearing andDistance:(CLLocationDistance)distance {
// Formula:	lat2 = asin(sin(lat1)*cos(d/R) + cos(lat1)*sin(d/R)*cos(θ))
//  lon2 = lon1 + atan2(sin(θ)*sin(d/R)*cos(lat1), cos(d/R)−sin(lat1)*sin(lat2))
//  d/R is the angular distance (in radians), where d is the distance travelled and R is the earth’s radius
// JavaScript:
//    var lat2 = Math.asin( Math.sin(lat1)*Math.cos(d/R) +
//                         Math.cos(lat1)*Math.sin(d/R)*Math.cos(brng) );
//    var lon2 = lon1 + Math.atan2(Math.sin(brng)*Math.sin(d/R)*Math.cos(lat1),
//                                 Math.cos(d/R)-Math.sin(lat1)*Math.sin(lat2));
    double lat1 = degreesToRadians(self.coordinate.latitude);
    double lon1 = degreesToRadians(self.coordinate.longitude);
    double brng = degreesToRadians(initialBearing);
    double d = distance;
    double R = EARTH_RADIUS;
    double lat2 = asin(sin(lat1) * cos(d / R) + cos(lat1) * sin(d / R) * cos(brng));
    double lon2 = lon1 + atan2(sin(brng) * sin(d / R) * cos(lat1), cos(d / R) - sin(lat1) * sin(lat2));
    CLLocationCoordinate2D destination = CLLocationCoordinate2DMake(radiansToDegrees(lat2), radiansToDegrees(lon2));

    return destination;
}

// Intersection of two paths given start points and bearings.
- (CLLocationCoordinate2D)kv_intersectionCoordinateForCirclePathWithBearing:(CLLocationDirection)initialBearing1 andCirclePathFromCoordinate:(CLLocationCoordinate2D)departure2 bearing:(CLLocationDirection)initialBearing2 {
//    LatLon.intersection = function(p1, brng1, p2, brng2) {
//        brng1 = typeof brng1 == 'number' ? brng1 : typeof brng1 == 'string' && trim(brng1)!='' ? +brng1 : NaN;
//        brng2 = typeof brng2 == 'number' ? brng2 : typeof brng2 == 'string' && trim(brng2)!='' ? +brng2 : NaN;
//        lat1 = p1._lat.toRad(), lon1 = p1._lon.toRad();
//        lat2 = p2._lat.toRad(), lon2 = p2._lon.toRad();
//        brng13 = brng1.toRad(), brng23 = brng2.toRad();
//        dLat = lat2-lat1, dLon = lon2-lon1;
//
//        dist12 = 2*Math.asin( Math.sqrt( Math.sin(dLat/2)*Math.sin(dLat/2) +
//                                        Math.cos(lat1)*Math.cos(lat2)*Math.sin(dLon/2)*Math.sin(dLon/2) ) );
//        if (dist12 == 0) return null;
//
//        // initial/final bearings between points
//        brngA = Math.acos( ( Math.sin(lat2) - Math.sin(lat1)*Math.cos(dist12) ) /
//                          ( Math.sin(dist12)*Math.cos(lat1) ) );
//        if (isNaN(brngA)) brngA = 0;  // protect against rounding
//        brngB = Math.acos( ( Math.sin(lat1) - Math.sin(lat2)*Math.cos(dist12) ) /
//                          ( Math.sin(dist12)*Math.cos(lat2) ) );
//
//        if (Math.sin(lon2-lon1) > 0) {
//            brng12 = brngA;
//            brng21 = 2*Math.PI - brngB;
//        } else {
//            brng12 = 2*Math.PI - brngA;
//            brng21 = brngB;
//        }
//
//        alpha1 = (brng13 - brng12 + Math.PI) % (2*Math.PI) - Math.PI;  // angle 2-1-3
//        alpha2 = (brng21 - brng23 + Math.PI) % (2*Math.PI) - Math.PI;  // angle 1-2-3
//
//        if (Math.sin(alpha1)==0 && Math.sin(alpha2)==0) return null;  // infinite intersections
//        if (Math.sin(alpha1)*Math.sin(alpha2) < 0) return null;       // ambiguous intersection
//
//        //alpha1 = Math.abs(alpha1);
//        //alpha2 = Math.abs(alpha2);
//        // ... Ed Williams takes abs of alpha1/alpha2, but seems to break calculation?
//
//        alpha3 = Math.acos( -Math.cos(alpha1)*Math.cos(alpha2) +
//                           Math.sin(alpha1)*Math.sin(alpha2)*Math.cos(dist12) );
//        dist13 = Math.atan2( Math.sin(dist12)*Math.sin(alpha1)*Math.sin(alpha2),
//                            Math.cos(alpha2)+Math.cos(alpha1)*Math.cos(alpha3) )
//        lat3 = Math.asin( Math.sin(lat1)*Math.cos(dist13) +
//                         Math.cos(lat1)*Math.sin(dist13)*Math.cos(brng13) );
//        dLon13 = Math.atan2( Math.sin(brng13)*Math.sin(dist13)*Math.cos(lat1),
//                            Math.cos(dist13)-Math.sin(lat1)*Math.sin(lat3) );
//        lon3 = lon1+dLon13;
//        lon3 = (lon3+Math.PI) % (2*Math.PI) - Math.PI;  // normalise to -180..180º
//
//        return new LatLon(lat3.toDeg(), lon3.toDeg());

    double lat1 = degreesToRadians(self.coordinate.latitude);
    double lon1 = degreesToRadians(self.coordinate.longitude);
    double lat2 = degreesToRadians(departure2.latitude);
    double lon2 = degreesToRadians(departure2.longitude);
    double brng13 = degreesToRadians(initialBearing1);
    double brng23 = degreesToRadians(initialBearing2);
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;
    double dist12 = 2.0 * asin(sqrt(sin(dLat / 2.0) * sin(dLat / 2.0) + cos(lat1) * cos(lat2) * sin(dLon / 2.0) * sin(dLon / 2.0)));

    if (dist12 == 0.0) return self.coordinate;  // same coordinates so return any of the coordinates
    double brngA = acos((sin(lat2) - sin(lat1) * cos(dist12)) / (sin(dist12) * cos(lat1)));
    if (isnan(brngA)) brngA = 0.0;
    double brngB =  acos( ( sin(lat1) - sin(lat2) * cos(dist12) ) / ( sin(dist12) * cos(lat2) ) );
    double brng12, brng21;
    if (sin(dLon) > 0.0) {
        brng12 = brngA;
        brng21 = 2.0 * M_PI - brngB;
    } else {
        brng12 = 2.0 * M_PI - brngA;
        brng21 = brngB;
    }
    double alpha1 = fmod((brng13 - brng12 + M_PI), (2.0 * M_PI)) - M_PI;  // angle 2-1-3
    double alpha2 = fmod((brng21 - brng23 + M_PI), (2.0 * M_PI)) - M_PI;  // angle 1-2-3
    if (sin(alpha1) == 0.0 && sin(alpha2) == 0.0) return CLLocationCoordinate2DMake(-91.0, -181.0);  // return invalid coordinate: infinite intersections
    if (sin(alpha1) * sin(alpha2) < 0.0) return CLLocationCoordinate2DMake(-91.0, -181.0);           // return invalid coordinate: ambiguous intersection
    double alpha3 = acos(-cos(alpha1) * cos(alpha2) +
                         sin(alpha1) * sin(alpha2) * cos(dist12) );
    double dist13 = atan2(sin(dist12) * sin(alpha1) * sin(alpha2),
                          cos(alpha2) + cos(alpha1) * cos(alpha3) );
    double lat3 = asin(sin(lat1) * cos(dist13) +
                       cos(lat1) * sin(dist13) * cos(brng13) );
    double dLon13 = atan2(sin(brng13) * sin(dist13) * cos(lat1),
                          cos(dist13) - sin(lat1) * sin(lat3) );
    double lon3 = lon1 + dLon13;
    lon3 = fmod((lon3 + M_PI), (2.0 * M_PI)) - M_PI;  // normalise to -180..180º

    CLLocationCoordinate2D intersection = CLLocationCoordinate2DMake(radiansToDegrees(lat3), radiansToDegrees(lon3));

    return intersection;

}

// - (CLLocationDistance)kv_distanceFromCirclePathFromCoordinate:(CLLocationCoordinate2D)departure toCoordinate:(CLLocationCoordinate2D)destination {
// // Formula:	dxt = asin(sin(d13/R)*sin(θ13−θ12)) * R
// //    where	 d13 is distance from start point to third point
// //    θ13 is (initial) bearing from start point to third point
// //    θ12 is (initial) bearing from start point to end point
// //    R is the earth’s radius
// // JavaScript:
// //    var dXt = Math.asin(Math.sin(d13/R)*Math.sin(brng13-brng12)) * R;
//
//    double dXt = asin(sin(d13/R)*sin(brng13-brng12)) * R;
// }

- (CLLocationDegrees)kv_maximumLatitudeOfCirclePathToCoordinate:(CLLocationCoordinate2D)destination {
// Formula:	latmax = acos(abs(sin(θ)*cos(lat)))
// JavaScript:
//    var latMax = Math.acos(Math.abs(Math.sin(brng)*Math.cos(lat)));
    double bearing = [self kv_intialBearingOnCirclePathToCoordinate:destination];
    double brng = degreesToRadians(bearing);
    double lat = degreesToRadians(self.coordinate.latitude);
    double latMax = acos(abs(sin(brng) * cos(lat)));
    return radiansToDegrees(latMax);
}
#pragma mark -

#pragma mark Rhumb Lines
- (CLLocationDirection)kv_bearingOnRhumbLineToCoordinate:(CLLocationCoordinate2D)destination {
// Formula:	Δφ = ln(tan(lat2/2+π/4)/tan(lat1/2+π/4))	 [= the ‘stretched’ latitude difference]
//    if E:W line,	q = cos(lat1)
//        otherwise,	q = Δlat/Δφ
//        d = √(Δlat² + q².Δlon²).R	[pythagoras]
//        θ = atan2(Δlon, Δφ)
//        where ln is natural log, Δlon is taking shortest route (<180º), and R is the earth’s radius
// JavaScript:
//        var dPhi = Math.log(Math.tan(lat2/2+Math.PI/4)/Math.tan(lat1/2+Math.PI/4));
//    var q = (!isNaN(dLat/dPhi)) ? dLat/dPhi : Math.cos(lat1);  // E-W line gives dPhi=0
//
//    // if dLon over 180° take shorter rhumb across 180° meridian:
//    if (Math.abs(dLon) > Math.PI) {
//        dLon = dLon>0 ? -(2*Math.PI-dLon) : (2*Math.PI+dLon);
//    }
//    var d = Math.sqrt(dLat*dLat + q*q*dLon*dLon) * R;
//    var brng = Math.atan2(dLon, dPhi);

    double lat1 = degreesToRadians(self.coordinate.latitude);
    double lon1 = degreesToRadians(self.coordinate.longitude);
    double lat2 = degreesToRadians(destination.latitude);
    double lon2 = degreesToRadians(destination.longitude);
    double dLon = lon2 - lon1;
    double dPhi = log(tan(lat2 / 2 + M_PI_4) / tan(lat1 / 2 + M_PI_4));

    if (abs(dLon) > M_PI) {
        dLon = (dLon > 0.0) ? -(2.0 * M_PI - dLon) : (2.0 * M_PI + dLon);
    }
    double brng = atan2(dLon, dPhi);
    return fmod((radiansToDegrees(brng) + 360.0), 360.0);
}

- (CLLocationDirection)kv_distanceAlongRhumbLineToCoordinate:(CLLocationCoordinate2D)destination {
// Formula:	Δφ = ln(tan(lat2/2+π/4)/tan(lat1/2+π/4))	 [= the ‘stretched’ latitude difference]
//    if E:W line,	q = cos(lat1)
//        otherwise,	q = Δlat/Δφ
//        d = √(Δlat² + q².Δlon²).R	[pythagoras]
//        θ = atan2(Δlon, Δφ)
//        where ln is natural log, Δlon is taking shortest route (<180º), and R is the earth’s radius
// JavaScript:
//        var dPhi = Math.log(Math.tan(lat2/2+Math.PI/4)/Math.tan(lat1/2+Math.PI/4));
//    var q = (!isNaN(dLat/dPhi)) ? dLat/dPhi : Math.cos(lat1);  // E-W line gives dPhi=0
//
//    // if dLon over 180° take shorter rhumb across 180° meridian:
//    if (Math.abs(dLon) > Math.PI) {
//        dLon = dLon>0 ? -(2*Math.PI-dLon) : (2*Math.PI+dLon);
//    }
//    var d = Math.sqrt(dLat*dLat + q*q*dLon*dLon) * R;
//    var brng = Math.atan2(dLon, dPhi);

    double lat1 = degreesToRadians(self.coordinate.latitude);
    double lon1 = degreesToRadians(self.coordinate.longitude);
    double lat2 = degreesToRadians(destination.latitude);
    double lon2 = degreesToRadians(destination.longitude);
    double R = EARTH_RADIUS;
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;
    double dPhi = log(tan(lat2 / 2 + M_PI_4) / tan(lat1 / 2 + M_PI_4));
    double q = (!isnan(dLat / dPhi) && !isinf(dLat / dPhi)) ? dLat / dPhi : cos(lat1);
    
    if (abs(dLon) > M_PI) {
        dLon = (dLon > 0.0) ? -(2.0 * M_PI - dLon) : (2.0 * M_PI + dLon);
    }
    double d = sqrt(dLat * dLat + q * q * dLon * dLon) * R;
    return d;
}

- (CLLocationCoordinate2D)kv_destinationCoordinateOnRhumbLineUsingBearing:(CLLocationDirection)bearing andDistance:(CLLocationDistance)distance {
// Formula:	α = d/R (angular distance)
//  lat2 = lat1 + α.cos(θ)
//  Δφ = ln(tan(lat2/2+π/4)/tan(lat1/2+π/4))	 [= the ‘stretched’ latitude difference]
//    if E:W line	q = cos(lat1)
//        otherwise	q = Δlat/Δφ
//        Δlon = α.sin(θ)/q
//        lon2 = (lon1+Δlon+π) % 2.π − π
//        where ln is natural log and % is modulo, Δlon is taking shortest route (<180°), and R is the earth’s radius
// JavaScript:
//        lat2 = lat1 + d*Math.cos(brng);
//    var dPhi = Math.log(Math.tan(lat2/2+Math.PI/4)/Math.tan(lat1/2+Math.PI/4));
//    var q = (!isNaN(dLat/dPhi)) ? dLat/dPhi : Math.cos(lat1);  // E-W line gives dPhi=0
//
//    var dLon = d*Math.sin(brng)/q;
//    // check for some daft bugger going past the pole, normalise latitude if so
//    if (Math.abs(lat2) > Math.PI/2) lat2 = lat2>0 ? Math.PI-lat2 : -(Math.PI-lat2);
//    lon2 = (lon1+dLon+Math.PI)%(2*Math.PI) - Math.PI;

    double lat1 = degreesToRadians(self.coordinate.latitude);
    double lon1 = degreesToRadians(self.coordinate.longitude);
    double brng = degreesToRadians(bearing);
    double d = distance;
    double R = EARTH_RADIUS;
    double lat2 = lat1 + (d / R) * cos(brng);
    double dLat = lat2 - lat1;
    double dPhi = log(tan(lat2 / 2 + M_PI_4) / tan(lat1 / 2 + M_PI_4));
    double q = (!isnan(dLat / dPhi) && !isinf(dLat / dPhi)) ? dLat / dPhi : cos(lat1);
    double dLon = (d / R) * sin(brng) / q;

    if (abs(lat2) > M_PI_2) {
        lat2 = (lat2 > 0) ? M_PI - lat2 : -(M_PI - lat2);
    }
    double lon2 = fmod((lon1 + dLon + 3 * M_PI), 2.0 * M_PI) - M_PI;
    CLLocationCoordinate2D destination = CLLocationCoordinate2DMake(radiansToDegrees(lat2), radiansToDegrees(lon2));

    return destination;

}

@end
