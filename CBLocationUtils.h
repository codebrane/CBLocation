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

typedef struct {
  float latitude;
  float longitude;
  float height;
} LatLon;

typedef struct {
  float a;
  float b;
  float f;
} Ellipse;

typedef struct {
  // m
  float tx;
  float ty;
  float tz;
  // sec
  float rx;
  float ry;
  float rz;
  // ppm
  float s;
} HelmertTransform;

@interface CBLocationUtils : NSObject {
  // ellipse parameters
  Ellipse *WGS84;
  Ellipse *Airy1830;
  
  // helmert transform parameters
  HelmertTransform *WGS84toOSGB36;
  HelmertTransform *OSGB36toWGS84;
  
  // Airy 1830 major & minor semi-axes
  float a;
  float b;
  
  // NatGrid scale factor on central meridian
  float F0;
  
  // NatGrid true origin
  float lat0;
  float lon0;
  
  // northing & easting of true origin, metres
  double N0;
  double E0;
  
  // eccentricity squared
  double e2;
  
  float n;
  float n2;
  float n3;
}

@property float a;
@property float b;
@property float F0;
@property float lat0;
@property float lon0;
@property double N0;
@property double E0;
@property double e2;
@property float n;
@property float n2;
@property float n3;

-(float)degreesToRadians:(float)degrees;
-(float)radiansToDegrees:(float)radians;

-(float)cosLatitude:(float)latitude;
-(float)cos3Latitude:(float)latitude;
-(float)cos5Latitude:(float)latitude;
-(float)sinLatitude:(float)latitude;
-(float)tan2Latitude:(float)latitude;
-(float)tan4Latitude:(float)latitude;

-(float)nu:(float)latitude;
-(float)rho:(float)latitude;
-(float)eta2:(float)latitude;
-(float)Ma:(float)latitude;
-(float)Mb:(float)latitude;
-(float)Mc:(float)latitude;
-(float)Md:(float)latitude;
-(float)M:(float)latitude;
-(float)I:(float)latitude;
-(float)II:(float)latitude;
-(float)III:(float)latitude;
-(float)IIIA:(float)latitude;
-(float)IV:(float)latitude;
-(float)V:(float)latitude;
-(float)VI:(float)latitude;
-(float)dLon:(float)longitude;
-(float)dLon2:(float)longitude;
-(float)dLon3:(float)longitude;
-(float)dLon4:(float)longitude;
-(float)dLon5:(float)longitude;
-(float)dLon6:(float)longitude;
-(float)N:(float)latitude longitude:(float)longitude;
-(float)E:(float)latitude longitude:(float)longitude;

-(LatLon*)OSGB36toWGS84:(float)latitude longitude:(float)longitude;
-(LatLon*)WGS84toOSGB36:(float)latitude longitude:(float)longitude;
-(LatLon*)convert:(float)latitude longitude:(float)longitude ellipse1:(Ellipse*)ellipse1 helmert:(HelmertTransform*)helmert ellipse2:(Ellipse*)ellipse2;

-(NSString *)gridrefNumToLet:(float)E N:(float)N digits:(int)digits;

@end
