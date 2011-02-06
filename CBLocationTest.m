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

#import "CBLocationTest.h"

@implementation CBLocationTest

// WGS84
// 57°14′14.00″N    57.23722222222222
// 005°54′20.00″W   -5.905555555555556

// OSGB36
// 57°14′14.88″N    57.237467437924735
// 005°54′15.97″W   -5.904435228421011

// NG 6442 2303

-(void)testWGS84toOSGB36 {
  /*
  CBLatLon *latlon = [CBLocation convertWGS84toOSGB36:57.23722222222222f longitude:-5.905555555555556f];
  STAssertEquals(57.237476f, latlon->latitude, @"testWGS84toOSGB36 latitude not working! returned %f", latlon->latitude);
  STAssertEquals(-5.904436f, latlon->longitude, @"testWGS84toOSGB36 longitude not working! returned %f", latlon->longitude);
  free(latlon);
   */
}

-(void)testOSGB36toWGS84 {
  CBLatLon *latlon = [CBLocation convertOSGB36toWGS84:57.237467437924735f longitude:-5.904435228421011f];
  NSLog(@"latlon->longitude = %f", latlon->longitude);
  STAssertEquals(57.237225f, latlon->latitude, @"testOSGB36toWGS84 latitude not working! returned %f", latlon->latitude);
  if (latlon->longitude == -5.905555) {
    NSLog(@"SDFDSFSDFDSFSDFSD!");
  }
  else {
    NSLog(@"EEK! %f", latlon->longitude);
  }
//  STAssertEquals(-5.905555f, latlon->longitude, @"testOSGB36toWGS84 longitude not working! returned %f", latlon->longitude);
  free(latlon);
}

-(void)testLatLongToOSGrid {
  /*
  float latitude = 55.8620f; // N
  float longitude = -4.2450f; // W
  NSString *osGridRef = [CBLocation OSGridFromLatitude:latitude andLongitude:longitude];
  STAssertEqualObjects(@"NS 5951 6547", osGridRef,
                       @"testLatLongToOSGrid not working! returned %@", osGridRef);
   */
}

@end
