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

#import "CBLocation.h"
#import "CBLocationUtils.h"

@implementation CBLocation

+(CBLatLon *)convertOSGB36toWGS84:(float)latitude longitude:(float)longitude {
  CBLocationUtils *utils = [[CBLocationUtils alloc] init];
  LatLon* _latLon = [utils OSGB36toWGS84:latitude longitude:longitude];
  CBLatLon *latLon = malloc(sizeof(CBLatLon));
  latLon->latitude = _latLon->latitude;
  latLon->longitude = _latLon->longitude;
  free(_latLon);
  [utils release];
  return latLon;
}

+(CBLatLon *)convertWGS84toOSGB36:(float)latitude longitude:(float)longitude {
  CBLocationUtils *utils = [[CBLocationUtils alloc] init];
  LatLon* _latLon = [utils WGS84toOSGB36:latitude longitude:longitude];
  CBLatLon *latLon = malloc(sizeof(CBLatLon));
  latLon->latitude = _latLon->latitude;
  latLon->longitude = _latLon->longitude;
  free(_latLon);
  [utils release];
  return latLon;
}

+(NSString *)OSGridFromLatitude:(double)latitutde andLongitude:(double)longitude {
  CBLocationUtils *utils = [[CBLocationUtils alloc] init];
  double northing = [utils N:latitutde longitude:longitude];
  double easting = [utils E:latitutde longitude:longitude];
  NSString *gridref = [utils gridrefNumToLet:easting N:northing digits:8];
  [utils release];
  return gridref;
}

@end
