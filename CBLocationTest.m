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

-(void)testLatLongToOSGrid {
  float latitude = 55.8620f; // N
  float longitude = -4.2450f; // W
  
  STAssertEqualObjects(@"NS 5951 6547", [CBLocation OSGridFromLatitude:latitude andLongitude:longitude],
                       @"testLatLongToOSGrid not working! returned %@",
                       [CBLocation OSGridFromLatitude:latitude andLongitude:longitude]);
}

@end
