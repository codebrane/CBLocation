// "The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
//
// The Original Code is CBLocation https://github.com/codebrane/CBLocation
//
// The Initial Developer of the Original Code is Alistair Young alistair@codebrane.com
// All Rights Reserved.

/**
 * CBLocation.
 *
 * Location utilities for iOS devices
 *
 * @author alistair
 */

#import <Foundation/Foundation.h>

#import "CBLatLon.h"

@interface CBLocation : NSObject

/**
 * Converts OSGB36 coordinates to WGS84 coordinates.
 * OSGB36 is the latitude/longitutde system used by the United Kingdom Ordnance Survey.
 * WGS84 is the latitude/longitutde system used by the iPhone.
 *
 * @param latitude the latitude in OSGB36 format
 * @param longitude the longitude in OSGB36 format
 * @param error pointer to an NSError object. This should be set to nil
 * @return CBLatLon object containing the latitude and longitude in WGS84 format,
 * or nil if an error occurred, in which case error will point to a valid
 * NSError object with the error details.
 */
-(CBLatLon*)convertOSGB36toWGS84:(double)latitude longitude:(double)longitude error:(NSError **)error;

/**
 * Converts WGS84 coordinates to OSGB36 coordinates.
 * OSGB36 is the latitude/longitutde system used by the United Kingdom Ordnance Survey.
 * WGS84 is the latitude/longitutde system used by the iPhone.
 *
 * @param latitude the latitude in WGS84 format
 * @param longitude the longitude in WGS84 format
 * @param error pointer to an NSError object. This should be set to nil
 * @return CBLatLon object containing the latitude and longitude in OSGB36 format,
 * or nil if an error occurred, in which case error will point to a valid
 * NSError object with the error details.
 */
-(CBLatLon*)convertWGS84toOSGB36:(double)latitude longitude:(double)longitude error:(NSError **)error;

/**
 * Converts an OSGB36 latitude and longitude to a United Kingdom Ordnance Survey grid reference.
 *
 * @param latitude the latitude in OSGB36 format
 * @param longitude the longitude in OSGB36 format
 * @param error pointer to an NSError object. This should be set to nil
 * @return autoreleased NSString containing the eight figure grid reference, of the form:
 * NS 5951 6547
 * or nil if an error occurred, in which case error will point to a valid
 * NSError object with the error details.
 */
-(NSString *)OSGridRefFromLatitude:(double)latitutde longitude:(double)longitude error:(NSError **)error;

@end
