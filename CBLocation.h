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

#import <Foundation/Foundation.h>

#import "CBLatLon.h"

typedef struct {
  double a;
  double b;
  double f;
} Ellipse;

typedef struct {
  // m
  double tx;
  double ty;
  double tz;
  // sec
  double rx;
  double ry;
  double rz;
  // ppm
  double s;
} HelmertTransform;

@interface CBLocation : NSObject {
  // ellipse parameters
  Ellipse *WGS84;
  Ellipse *Airy1830;
  
  // helmert transform parameters
  HelmertTransform *WGS84toOSGB36;
  HelmertTransform *OSGB36toWGS84;
  
  // Airy 1830 major & minor semi-axes
  double a;
  double b;
  
  // NatGrid scale factor on central meridian
  double F0;
  
  // NatGrid true origin
  double lat0;
  double lon0;
  
  // northing & easting of true origin, metres
  double N0;
  double E0;
  
  // eccentricity squared
  double e2;
  
  double n;
  double n2;
  double n3;
}

@property double a;
@property double b;
@property double F0;
@property double lat0;
@property double lon0;
@property double N0;
@property double E0;
@property double e2;
@property double n;
@property double n2;
@property double n3;

-(double)degreesToRadians:(double)degrees;
-(double)radiansToDegrees:(double)radians;

-(double)cosLatitude:(double)latitude;
-(double)cos3Latitude:(double)latitude;
-(double)cos5Latitude:(double)latitude;
-(double)sinLatitude:(double)latitude;
-(double)tan2Latitude:(double)latitude;
-(double)tan4Latitude:(double)latitude;

-(double)nu:(double)latitude;
-(double)rho:(double)latitude;
-(double)eta2:(double)latitude;
-(double)Ma:(double)latitude;
-(double)Mb:(double)latitude;
-(double)Mc:(double)latitude;
-(double)Md:(double)latitude;
-(double)M:(double)latitude;
-(double)I:(double)latitude;
-(double)II:(double)latitude;
-(double)III:(double)latitude;
-(double)IIIA:(double)latitude;
-(double)IV:(double)latitude;
-(double)V:(double)latitude;
-(double)VI:(double)latitude;
-(double)dLon:(double)longitude;
-(double)dLon2:(double)longitude;
-(double)dLon3:(double)longitude;
-(double)dLon4:(double)longitude;
-(double)dLon5:(double)longitude;
-(double)dLon6:(double)longitude;
-(double)N:(double)latitude longitude:(double)longitude;
-(double)E:(double)latitude longitude:(double)longitude;

-(CBLatLon*)OSGB36toWGS84:(double)latitude longitude:(double)longitude;
-(CBLatLon*)WGS84toOSGB36:(double)latitude longitude:(double)longitude;
-(CBLatLon*)convert:(double)latitude longitude:(double)longitude ellipse1:(Ellipse*)ellipse1 helmert:(HelmertTransform*)helmert ellipse2:(Ellipse*)ellipse2;

-(NSString *)gridrefNumToLet:(double)E N:(double)N digits:(int)digits;



-(CBLatLon*)convertOSGB36toWGS84:(double)latitude longitude:(double)longitude;
-(CBLatLon*)convertWGS84toOSGB36:(double)latitude longitude:(double)longitude;
-(NSString *)OSGridFromLatitude:(double)latitutde andLongitude:(double)longitude;


@end
