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

#import "CBLocationUtils.h"

@implementation CBLocationUtils

@synthesize a;
@synthesize b;
@synthesize F0;
@synthesize lat0;
@synthesize lon0;
@synthesize N0;
@synthesize E0;
@synthesize e2;
@synthesize n;
@synthesize n2;
@synthesize n3;

-(id)init {
  if (self = [super init]) {
    self.a = 6377563.396;;
    self.b = 6356256.910;
    self.F0 = 0.9996012717;
    self.N0 = -100000;
    self.E0 = 400000;
    self.lat0 = [self degreesToRadians:49];
    self.lon0 = [self degreesToRadians:-2];
    self.e2 = 1 - (self.b*self.b)/(self.a*self.a);
    self.n = (self.a-self.b)/(self.a+self.b);
    self.n2 = self.n*self.n;
    self.n3 = self.n*self.n*self.n;
  }
  
  return self;
}

// http://blog.digitalagua.com/2008/06/30/how-to-convert-degrees-to-radians-radians-to-degrees-in-objective-c/
-(float)degreesToRadians:(float)degrees {
  return degrees * M_PI / 180;
}

-(float)radiansToDegrees:(float)radians {
  return radians * 180 / M_PI;
}





-(float)cosLatitude:(float)latitude {
  return cos(latitude);
}

-(float)cos3Latitude:(float)latitude {
  return ([self cosLatitude:latitude] * [self cosLatitude:latitude] * [self cosLatitude:latitude]);
}

-(float)cos5Latitude:(float)latitude {
  return ([self cos3Latitude:latitude] * [self cosLatitude:latitude] * [self cosLatitude:latitude]);
}

-(float)sinLatitude:(float)latitude {
  return sin(latitude);
}

-(float)tan2Latitude:(float)latitude {
  return (tan(latitude) * tan(latitude));
}

-(float)tan4Latitude:(float)latitude {
  return ([self tan2Latitude:latitude] * [self tan2Latitude:latitude]);
}





// transverse radius of curvature
-(float)nu:(float)latitude {
  return self.a*self.F0/sqrt(1-self.e2*[self sinLatitude:[self degreesToRadians:latitude]]*[self sinLatitude:[self degreesToRadians:latitude]]);
}

// meridional radius of curvature
-(float)rho:(float)latitude {
  return self.a*self.F0*(1-self.e2)/pow(1-self.e2*[self sinLatitude:[self degreesToRadians:latitude]]*[self sinLatitude:[self degreesToRadians:latitude]], 1.5);
}

-(float)eta2:(float)latitude {
  return [self nu:latitude]/[self rho:latitude]-1;
}

-(float)Ma:(float)latitude {
  return (1 + self.n + (5/4)*self.n2 + (5/4)*self.n3) * ([self degreesToRadians:latitude]-lat0);
}

-(float)Mb:(float)latitude {
  return ((3 * self.n) + (3 * self.n * self.n) + ((21/8) * self.n3)) * [self sinLatitude:([self degreesToRadians:latitude] - self.lat0)] * [self cosLatitude:([self degreesToRadians:latitude] + self.lat0)];
}

-(float)Mc:(float)latitude {
  return ((15/8 * self.n2) + (15/8 * self.n3)) * [self sinLatitude:(2 * ([self degreesToRadians:latitude] - self.lat0))] * [self cosLatitude:(2 * ([self degreesToRadians:latitude] + self.lat0))];
}

-(float)Md:(float)latitude {
  return (35/24)*self.n3 * [self sinLatitude:(3*([self degreesToRadians:latitude]-self.lat0))] * [self cosLatitude:(3*([self degreesToRadians:latitude]+self.lat0))];
}

// meridional arc
-(float)M:(float)latitude {
  return self.b * self.F0 * ([self Ma:latitude] - [self Mb:latitude] + [self Mc:latitude] - [self Md:latitude]);
}

-(float)I:(float)latitude {
  return ([self M:latitude] + self.N0);
}

-(float)II:(float)latitude {
  return ([self nu:latitude] / 2) * [self sinLatitude:[self degreesToRadians:latitude]] * [self cosLatitude:[self degreesToRadians:latitude]];
}

-(float)III:(float)latitude {
  return ([self nu:latitude] / 24) *
          [self sinLatitude:[self degreesToRadians:latitude]] *
          [self cos3Latitude:[self degreesToRadians:latitude]] *
          (5 - [self tan2Latitude:[self degreesToRadians:latitude]] +
           9 * [self eta2:latitude]);
}

-(float)IIIA:(float)latitude {
  return ([self nu:latitude]/720)*[self sinLatitude:[self degreesToRadians:latitude]]*[self cos5Latitude:[self degreesToRadians:latitude]]*(61-58*[self tan2Latitude:[self degreesToRadians:latitude]]+[self tan4Latitude:[self degreesToRadians:latitude]]);
}

-(float)IV:(float)latitude {
  return [self nu:latitude] * [self cosLatitude:[self degreesToRadians:latitude]];
}

-(float)V:(float)latitude {
  return ([self nu:latitude]/6)*[self cos3Latitude:[self degreesToRadians:latitude]]*([self nu:latitude]/[self rho:latitude]-[self tan2Latitude:[self degreesToRadians:latitude]]);
}

-(float)VI:(float)latitude {
  return ([self nu:latitude]/120) * [self cos5Latitude:[self degreesToRadians:latitude]] * (5 - 18*[self tan2Latitude:[self degreesToRadians:latitude]] + [self tan4Latitude:[self degreesToRadians:latitude]] + 14*[self eta2:latitude] - 58*[self tan2Latitude:[self degreesToRadians:latitude]]*[self eta2:latitude]);
}

-(float)dLon:(float)longitude {
  return ([self degreesToRadians:longitude] - self.lon0);
}

-(float)dLon2:(float)longitude {
  return ([self dLon:longitude] * [self dLon:longitude]);
}

-(float)dLon3:(float)longitude {
  return ([self dLon2:longitude] * [self dLon:longitude]);
}

-(float)dLon4:(float)longitude {
  return ([self dLon3:longitude] * [self dLon:longitude]);
}

-(float)dLon5:(float)longitude {
  return ([self dLon4:longitude] * [self dLon:longitude]);
}

-(float)dLon6:(float)longitude {
  return ([self dLon5:longitude] * [self dLon:longitude]);
}

-(float)N:(float)latitude longitude:(float)longitude {
  return [self I:latitude] + [self II:latitude]*[self dLon2:longitude] + [self III:latitude]*[self dLon4:longitude] + [self IIIA:latitude]*[self dLon6:longitude];
}

-(float)E:(float)latitude longitude:(float)longitude {
  return self.E0 + [self IV:latitude]*[self dLon:longitude] + [self V:latitude]*[self dLon3:longitude] + [self VI:latitude]*[self dLon5:longitude];
}

// convert numeric grid reference (in metres) to standard-form grid ref
-(NSString *)gridrefNumToLet:(float)E N:(float)N digits:(int)digits {
  // get the 100km-grid indices
  int e100k = floor(E / 100000);
  int n100k = floor(N / 100000);
  
  if (e100k < 0 || e100k > 6 || n100k < 0 || n100k > 12) {
    return [[[NSString alloc] initWithString:@"out of range"] autorelease];
  }
  
  // translate those into numeric equivalents of the grid letters
  int l1 = (19-n100k) - (19-n100k)%5 + floor((e100k+10)/5);
  int l2 = (19-n100k)*5%25 + e100k%5;
  
  // compensate for skipped 'I' and build grid letter-pairs
  if (l1 > 7) l1++;
  if (l2 > 7) l2++;
  
  l1 = l1+'A';
  l2 = l2+'A';
  NSString *firstGridLetter = [[NSString alloc] initWithBytes:(char *)&l1 length:1 encoding:NSUTF8StringEncoding];
  NSString *secondGridLetter = [[NSString alloc] initWithBytes:(char *)&l2 length:1 encoding:NSUTF8StringEncoding];
  
  int easting = floor((((int)E)%100000) / pow(10, 5-digits/2));
  int northing = floor((((int)N)%100000) / pow(10, 5-digits/2));
  
  NSString* gridRef = [[NSString stringWithFormat:@"%@%@ %d %d", firstGridLetter, secondGridLetter, easting, northing] autorelease];
  
  [firstGridLetter release];
  [secondGridLetter release];
  
  return gridRef;
}

@end
