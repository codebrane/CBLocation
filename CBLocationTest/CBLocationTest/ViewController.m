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

#import "ViewController.h"
#import "CBLocation.h"

@interface ViewController ()

@end

@implementation ViewController {
    CLLocationManager *locationManager;
    CLLocation *startLocation;
    CBLocation *cbLocation;
    UIActivityIndicatorView *activityIndicator;
}

@synthesize latitudeLabel, longitudeLabel, altitudeLabel, horizontalAccuracyLabel, verticalAccuracyLabel;
@synthesize gridRefLabel, distanceLabel, directionLabel, speedLabel, headingLabel, compassLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    cbLocation = [[CBLocation alloc] init];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
    [self.view addSubview:activityIndicator];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.purpose = @"I'd like to show your gridref";
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 10;
    [locationManager startUpdatingLocation];
    locationManager.headingFilter = 1; // degrees
    [locationManager startUpdatingHeading];
    
    self.view.alpha = 0.5;
    [activityIndicator startAnimating];
}

- (void)viewDidUnload {
    locationManager = nil;
    gridRefLabel = nil;
    cbLocation = nil;

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else {
        return YES;
    }
}

- (void)stopActivityIndicator {
    if (activityIndicator) {
        self.view.alpha = 1.0;
        [activityIndicator stopAnimating];
        activityIndicator = nil;
    }
}


#pragma mark -
#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self stopActivityIndicator];
    
    if (startLocation == nil) {
        startLocation = newLocation;
    }
    
    NSString *latitudeString = [[NSString alloc] initWithFormat:@"%g\u00B0", newLocation.coordinate.latitude];
    NSString *longitudeString = [[NSString alloc] initWithFormat:@"%g\u00B0", newLocation.coordinate.longitude];
    NSString *altitudeString = [[NSString alloc] initWithFormat:@"%gm", newLocation.altitude];
    NSString *horizontalAccuracyString = [[NSString alloc] initWithFormat:@"%gm", newLocation.horizontalAccuracy];
    NSString *verticalAccuracyString = [[NSString alloc] initWithFormat:@"%gm", newLocation.verticalAccuracy];
    NSString *directionString = [[NSString alloc] initWithFormat:@"%d", newLocation.course];
    NSString *speedString = [[NSString alloc] initWithFormat:@"%d", newLocation.speed];
    CLLocationDistance distance = [newLocation distanceFromLocation:startLocation];
    NSString *distanceString = [[NSString alloc] initWithFormat:@"%gm", distance];
    
    latitudeLabel.text = latitudeString;
    longitudeLabel.text = longitudeString;
    
    NSError *error = nil;
    NSString *osGridRef = [cbLocation OSGridRefFromLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude error:&error];
    if (error) {
        gridRefLabel.text = [error localizedDescription];
    }
    else {
        gridRefLabel.text = osGridRef;
    }
    
    altitudeLabel.text = altitudeString;
    horizontalAccuracyLabel.text = horizontalAccuracyString;
    verticalAccuracyLabel.text = verticalAccuracyString;
    distanceLabel.text = distanceString;
    directionLabel.text = directionString;
    speedLabel.text = speedString;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 0) {
        NSString *courseString = [[NSString alloc] initWithString:@"NOT READY!"];
        headingLabel.text = courseString;
        return;
    }
    
    // Use the true heading if it is valid.
    // http://wildwalks.com/bushcraft/technical-stuff/points-of-a-compass-cardinal-degree.html
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading);
    NSString *compassDirection;
    
//    if ((theHeading == 0) || (theHeading == 360)) {
//        compassDirection = [[NSString alloc] initWithString:@"N"];
//    }
//    else if (theHeading == 45) {
//        compassDirection = [[NSString alloc] initWithString:@"NE"];
//    }
//    else if (theHeading == 90) {
//        compassDirection = [[NSString alloc] initWithString:@"E"];
//    }
//    else if (theHeading ==135) {
//        compassDirection = [[NSString alloc] initWithString:@"SE"];
//    }
//    else if (theHeading == 180) {
//        compassDirection = [[NSString alloc] initWithString:@"S"];
//    }
//    else if (theHeading == 225) {
//        compassDirection = [[NSString alloc] initWithString:@"SW"];
//    }
//    else if (theHeading == 270) {
//        compassDirection = [[NSString alloc] initWithString:@"W"];
//    }
//    else if (theHeading == 315) {
//        compassDirection = [[NSString alloc] initWithString:@"NW"];
//    }

    
    if (theHeading == 0) {
        compassDirection = [[NSString alloc] initWithString:@"N"];
    }
    else if ((theHeading >= 1) && (theHeading <= 22)) {
        compassDirection = [[NSString alloc] initWithString:@"N by E"];
    }
    else if ((theHeading >= 23) && (theHeading <= 33)) {
        compassDirection = [[NSString alloc] initWithString:@"NNE"];
    }
    else if ((theHeading >= 34) && (theHeading <= 44)) {
        compassDirection = [[NSString alloc] initWithString:@"NE by N"];
    }
    else if ((theHeading >= 45) && (theHeading <= 56)) {
        compassDirection = [[NSString alloc] initWithString:@"NE"];
    }
    else if ((theHeading >= 57) && (theHeading <= 67)) {
        compassDirection = [[NSString alloc] initWithString:@"NE by E"];
    }
    else if ((theHeading >= 68) && (theHeading <= 78)) {
        compassDirection = [[NSString alloc] initWithString:@"ENE"];
    }
    else if ((theHeading >= 79) && (theHeading <= 89)) {
        compassDirection = [[NSString alloc] initWithString:@"E by N"];
    }
    else if (theHeading == 90) {
        compassDirection = [[NSString alloc] initWithString:@"E"];
    }
    
    
    
    
    //  NSString *courseString = [[NSString alloc] initWithFormat:@"%.3f", theHeading];
    NSString *courseString = [[NSString alloc] initWithFormat:@"%.0f", theHeading];
    headingLabel.text = courseString;
    compassLabel.text = compassDirection;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self stopActivityIndicator];
    NSString *errorType = (error.code == kCLErrorDenied) ? @"You wouldn't let me!" : @"Unknown Error";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting location" message:errorType delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
