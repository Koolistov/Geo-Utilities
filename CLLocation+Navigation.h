//
//  CLLocation+Navigation.h
//  Koolistov
//
//  Created by Johan Kool on 22-11-10.
//  Copyright 2010-2011 Koolistov. All rights reserved.
//

// based on http://www.movable-type.co.uk/scripts/latlong.html

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CLLocation (Navigation)

// This formula gives the distance between two points along a circle path using the haversine formula.
- (CLLocationDistance)kv_distanceUsingHaversineAlongCirclePathToCoordinate:(CLLocationCoordinate2D)destination;

// This formula gives the distance between two points along a circle path using the haversine formula.
- (CLLocationDistance)kv_distanceUsingSphericalLawOfCosinesAlongCirclePathToCoordinate:(CLLocationCoordinate2D)destination;

// This formula is for the initial bearing (sometimes referred to as forward azimuth) which if followed in a straight line along a great-circle arc will take you from the start point to the end point.
- (CLLocationDirection)kv_intialBearingOnCirclePathToCoordinate:(CLLocationCoordinate2D)destination;

// This formula is for the final bearing at which you arrive if you travelled in a straight line along a great-circle arc from the start point to the end point.
- (CLLocationDirection)kv_finalBearingOnCirclePathToCoordinate:(CLLocationCoordinate2D)destination;

// This is the midpoint along a great circle path between the two points.
- (CLLocationCoordinate2D)kv_midPointOnCirclePathToCoordinate:(CLLocationCoordinate2D)destination;

// Given a start point, initial bearing, and distance, this will calculate the destination point travelling along a (shortest distance) great circle arc.
- (CLLocationCoordinate2D)kv_destinationCoordinateOnCirclePathUsingInitialBearing:(CLLocationDirection)initialBearing andDistance:(CLLocationDistance)distance;

// Intersection of two paths given start points and bearings.
- (CLLocationCoordinate2D)kv_intersectionCoordinateForCirclePathWithBearing:(CLLocationDirection)initialBearing1 andCirclePathFromCoordinate:(CLLocationCoordinate2D)departure2 bearing:(CLLocationDirection)initialBearing2;

// Distance of a point from a great-circle path (sometimes called cross track error).
//- (CLLocationDistance)kv_distanceFromCirclePathFromCoordinate:(CLLocationCoordinate2D)departure toCoordinate:(CLLocationCoordinate2D)destination;

// ‘Clairaut’s formula’ will give you the maximum latitude of a great circle path, given a bearing and latitude on the great circle:
- (CLLocationDegrees)kv_maximumLatitudeOfCirclePathToCoordinate:(CLLocationCoordinate2D)destination;

// A ‘rhumb line’ (or loxodrome) is a path of constant bearing, which crosses all meridians at the same angle.

// This formula gives the (constant) bearing between two points on a rhumb line.
- (CLLocationDirection)kv_bearingOnRhumbLineToCoordinate:(CLLocationCoordinate2D)destination;

// This formula gives the distance between two points along a rhumb line.
- (CLLocationDirection)kv_distanceAlongRhumbLineToCoordinate:(CLLocationCoordinate2D)destination;

// Given a start point, bearing, and distance, this will calculate the destination point travelling along a rhumb line (constant bearing).
- (CLLocationCoordinate2D)kv_destinationCoordinateOnRhumbLineUsingBearing:(CLLocationDirection)bearing andDistance:(CLLocationDistance)distance;

@end
