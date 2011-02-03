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
//    self.n = ((self.a - self.b) / (self.a + self.b));
    self.n = (self.a-self.b)/(self.a+self.b);
//    self.n2 = (self.n * self.n);
    self.n2 = self.n*self.n;
//    self.n3 = (self.n * self.n * self.n);
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
-(float)nu:(float)latitude { // OK
  // nu = 6390092.714836496
  NSLog(@"nu = %f", self.a*self.F0/sqrt(1-self.e2*[self sinLatitude:[self degreesToRadians:latitude]]*[self sinLatitude:[self degreesToRadians:latitude]]));
  return self.a*self.F0/sqrt(1-self.e2*[self sinLatitude:[self degreesToRadians:latitude]]*[self sinLatitude:[self degreesToRadians:latitude]]);
}

// meridional radius of curvature
-(float)rho:(float)latitude { // OK
  // rho = 6377517.009942445
  NSLog(@"rho = %f", self.a*self.F0*(1-self.e2)/pow(1-self.e2*[self sinLatitude:[self degreesToRadians:latitude]]*[self sinLatitude:[self degreesToRadians:latitude]], 1.5));
  return self.a*self.F0*(1-self.e2)/pow(1-self.e2*[self sinLatitude:[self degreesToRadians:latitude]]*[self sinLatitude:[self degreesToRadians:latitude]], 1.5);
}

-(float)eta2:(float)latitude { // OK
  // eta2 = 0.0019718810431152978
  NSLog(@"eta2 = %f", [self nu:latitude]/[self rho:latitude]-1);
  return [self nu:latitude]/[self rho:latitude]-1;
}

-(float)Ma:(float)latitude { // OK
  // Ma = 0.14314717592879525
  NSLog(@"Ma = %f", (1 + self.n + (5/4)*self.n2 + (5/4)*self.n3) * ([self degreesToRadians:latitude]-lat0));
  return (1 + self.n + (5/4)*self.n2 + (5/4)*self.n3) * ([self degreesToRadians:latitude]-lat0);
}

-(float)Mb:(float)latitude { // OK
  // Mb = -0.00019964323852434584
  NSLog(@"Mb = %f", ((3 * self.n) + (3 * self.n * self.n) + ((21/8) * self.n3)) * [self sinLatitude:([self degreesToRadians:latitude] - self.lat0)] * [self cosLatitude:([self degreesToRadians:latitude] + self.lat0)]);
  return ((3 * self.n) + (3 * self.n * self.n) + ((21/8) * self.n3)) * [self sinLatitude:([self degreesToRadians:latitude] - self.lat0)] * [self cosLatitude:([self degreesToRadians:latitude] + self.lat0)];
}

-(float)Mc:(float)latitude { // OK
  // Mc = -0.0000012520341642447784
  NSLog(@"Mc = %f", ((15/8 * self.n2) + (15/8 * self.n3)) * [self sinLatitude:(2 * ([self degreesToRadians:latitude] - self.lat0))] * [self cosLatitude:(2 * ([self degreesToRadians:latitude] + self.lat0))]);
  return ((15/8 * self.n2) + (15/8 * self.n3)) * [self sinLatitude:(2 * ([self degreesToRadians:latitude] - self.lat0))] * [self cosLatitude:(2 * ([self degreesToRadians:latitude] + self.lat0))];
}

-(float)Md:(float)latitude { // NOT OK 0.00000000
  // Md = 2.129074482992922e-9
  NSLog(@"Md = %f", (35/24)*self.n3 * [self sinLatitude:(3*([self degreesToRadians:latitude]-self.lat0))] * [self cosLatitude:(3*([self degreesToRadians:latitude]+self.lat0))]);
  return (35/24)*self.n3 * [self sinLatitude:(3*([self degreesToRadians:latitude]-self.lat0))] * [self cosLatitude:(3*([self degreesToRadians:latitude]+self.lat0))];
}

// meridional arc
-(float)M:(float)latitude { // OK
  // M = 910777.9402781258
  NSLog(@"M = %f", self.b * self.F0 * ([self Ma:latitude] - [self Mb:latitude] + [self Mc:latitude] - [self Md:latitude]));
  return self.b * self.F0 * ([self Ma:latitude] - [self Mb:latitude] + [self Mc:latitude] - [self Md:latitude]);
}

-(float)I:(float)latitude { // OK
  // I = 810777.9402781258
  NSLog(@"I = %f",([self M:latitude] + self.N0));
  return ([self M:latitude] + self.N0);
}

-(float)II:(float)latitude { // OK
  // II = 1455114.5656239567
  NSLog(@"II = %f", ([self nu:latitude]/2)*[self sinLatitude:[self degreesToRadians:latitude]]*[self cosLatitude:[self degreesToRadians:latitude]]);
  return ([self nu:latitude] / 2) * [self sinLatitude:[self degreesToRadians:latitude]] * [self cosLatitude:[self degreesToRadians:latitude]];
}

-(float)III:(float)latitude { // OK
  // III = 93011.21410939026
  NSLog(@"III = %f", ([self nu:latitude]/24)*[self sinLatitude:[self degreesToRadians:latitude]]*[self cos3Latitude:[self degreesToRadians:latitude]]*(5-[self tan2Latitude:[self degreesToRadians:latitude]]+9*[self eta2:latitude]));
  
  return ([self nu:latitude] / 24) *
          [self sinLatitude:[self degreesToRadians:latitude]] *
          [self cos3Latitude:[self degreesToRadians:latitude]] *
          (5 - [self tan2Latitude:[self degreesToRadians:latitude]] +
           9 * [self eta2:latitude]);
}

-(float)IIIA:(float)latitude { // OK
  // IIIA = -25349.233056787063
  NSLog(@"IIIA = %f", ([self nu:latitude]/720)*[self sinLatitude:[self degreesToRadians:latitude]]*[self cos5Latitude:[self degreesToRadians:latitude]]*(61-58*[self tan2Latitude:[self degreesToRadians:latitude]]+[self tan4Latitude:[self degreesToRadians:latitude]]));
  
  return ([self nu:latitude]/720)*[self sinLatitude:[self degreesToRadians:latitude]]*[self cos5Latitude:[self degreesToRadians:latitude]]*(61-58*[self tan2Latitude:[self degreesToRadians:latitude]]+[self tan4Latitude:[self degreesToRadians:latitude]]);
}

-(float)IV:(float)latitude { // OK
  // IV = 3462690.5742993304
  NSLog(@"IV = %f", [self nu:latitude] * [self cosLatitude:[self degreesToRadians:latitude]]);
  return [self nu:latitude] * [self cosLatitude:[self degreesToRadians:latitude]];
}

-(float)V:(float)latitude { // OK
  // V = -237854.47036671816
  NSLog(@"V = %f", ([self nu:latitude]/6)*[self cos3Latitude:[self degreesToRadians:latitude]]*([self nu:latitude]/[self rho:latitude]-[self tan2Latitude:[self degreesToRadians:latitude]]));
  
  return ([self nu:latitude]/6)*[self cos3Latitude:[self degreesToRadians:latitude]]*([self nu:latitude]/[self rho:latitude]-[self tan2Latitude:[self degreesToRadians:latitude]]);
}

-(float)VI:(float)latitude { // OK
  // VI = -81510.18107681091
  NSLog(@"VI = %f", ([self nu:latitude]/120) * [self cos5Latitude:[self degreesToRadians:latitude]] * (5 - 18*[self tan2Latitude:[self degreesToRadians:latitude]] + [self tan4Latitude:[self degreesToRadians:latitude]] + 14*[self eta2:latitude] - 58*[self tan2Latitude:[self degreesToRadians:latitude]]*[self eta2:latitude]));
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

-(float)N:(float)latitude longitude:(float)longitude { // OK
  // N = 817514.8991987555
  NSLog(@"N = %f",  [self I:latitude] + [self II:latitude]*[self dLon2:longitude] + [self III:latitude]*[self dLon4:longitude] + [self IIIA:latitude]*[self dLon6:longitude]);
  return [self I:latitude] + [self II:latitude]*[self dLon2:longitude] + [self III:latitude]*[self dLon4:longitude] + [self IIIA:latitude]*[self dLon6:longitude];
}

-(float)E:(float)latitude longitude:(float)longitude { // OK
  // E = 164498.0164299632
  NSLog(@"E = %f", self.E0 + [self IV:latitude]*[self dLon:longitude] + [self V:latitude]*[self dLon3:longitude] + [self VI:latitude]*[self dLon5:longitude]);
  return self.E0 + [self IV:latitude]*[self dLon:longitude] + [self V:latitude]*[self dLon3:longitude] + [self VI:latitude]*[self dLon5:longitude];
}

// convert numeric grid reference (in metres) to standard-form grid ref
-(NSString *)gridrefNumToLet:(float)E N:(float)N digits:(int)digits {
  // get the 100km-grid indices
  int e100k = floor(E / 100000); // e100k = 1 OK
  int n100k = floor(N / 100000); // n100k = 8 OK
  
  if (e100k < 0 || e100k > 6 || n100k < 0 || n100k > 12) {
    return [[[NSString alloc] initWithString:@"out of range"] autorelease];
  }
  
  // translate those into numeric equivalents of the grid letters
  int l1 = (19-n100k) - (19-n100k)%5 + floor((e100k+10)/5); // l1 = 12 OK
  int l2 = (19-n100k)*5%25 + e100k%5; // l2 = 6 OK
  
  // compensate for skipped 'I' and build grid letter-pairs
  if (l1 > 7) l1++;
  if (l2 > 7) l2++;
  
  l1 = l1+'A';
  l2 = l2+'A';
  NSString *firstGridLetter = [[NSString alloc] initWithBytes:(char *)&l1 length:1 encoding:NSUTF8StringEncoding];
  NSString *secondGridLetter = [[NSString alloc] initWithBytes:(char *)&l2 length:1 encoding:NSUTF8StringEncoding];
  
  int easting = floor((((int)E)%100000) / pow(10, 5-digits/2)); // e = 6449 OK
  int northing = floor((((int)N)%100000) / pow(10, 5-digits/2)); // n = 1751 OK
  
  NSString* gridRef = [[NSString stringWithFormat:@"%@%@ %d %d", firstGridLetter, secondGridLetter, easting, northing] autorelease];
  
  [firstGridLetter release];
  [secondGridLetter release];
  
  return gridRef;
}




/*
-(NationalGridTrueOrigin*)getNationalGridTrueOrigin {
  NationalGridTrueOrigin *origin = malloc(sizeof(NationalGridTrueOrigin));
  origin->lat0 = [self degreesToRadians:49];
  origin->lon0 = [self degreesToRadians:-2];
  return origin;
}
 */

@end
