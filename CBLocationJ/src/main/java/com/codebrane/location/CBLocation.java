package com.codebrane.location;

import java.io.UnsupportedEncodingException;

/**
 * Location utilities for Android.
 *
 * Ported from the original javascript at:
 * See {@link "http://www.movable-type.co.uk/scripts/latlong-gridref.html"}
 */
public class CBLocation {
  // The longitude limits of the OS grid system
  private static final float OSGB_LONGITUDE_MAX_EAST = 2.0f;
  private static final float OSGB_LONGITUDE_MAX_WEST = -10.0f;

  // The latitude limits of the OS grid system
  private static final float OSGB_LATITUDE_MIN = 50.0f;
  private static final float OSGB_LATITUDE_MAX = 62.0f;

  private Ellipse wGS84;
  private Ellipse airy1830;
  private HelmertTransform wGS84toOSGB36;
  private HelmertTransform oSGB36toWGS84;
  private double a;
  private double b;
  private double F0;
  private double lat0;
  private double lon0;
  private double N0;
  private double E0;
  private double e2;
  private double n;
  private double n2;
  private double n3;

  public CBLocation() {
    wGS84 = new Ellipse(6378137, 6356752.3142, 1/298.257223563);
    airy1830 = new Ellipse(6377563.396, 6356256.910, 1/299.3249646);
    wGS84toOSGB36 = new HelmertTransform(-446.448, 125.157, -542.060,
            -0.1502, -0.2470, -0.8421, 20.4894);
    oSGB36toWGS84 = new HelmertTransform(446.448, -125.157, 542.060,
            0.1502, 0.2470, 0.8421, -20.4894);
    a = 6377563.396;
    b = 6356256.910;
    F0 = 0.9996012717;
    N0 = -100000;
    E0 = 400000;
    lat0 = degreesToRadians(49);
    lon0 = degreesToRadians(-2);
    e2 = 1 - (b*b)/(a*a);
    n = (a-b)/(a+b);
    n2 = n*n;
    n3 = n*n*n;
  }

  public CBLatLon convertOSGB36toWGS84(double latitude, double longitude) {
    return oSGB36toWGS84(latitude, longitude);
  }

  public CBLatLon convertWGS84toOSGB36(double latitude, double longitude) {
    return wGS84toOSGB36(latitude, longitude);
  }

  public String oSGridRefFromLatitudeAndLongitude(double latitude, double longitude) {
    if ((latitude < OSGB_LATITUDE_MIN) || (latitude > OSGB_LATITUDE_MAX) ||
   		  (longitude < OSGB_LONGITUDE_MAX_WEST) || (longitude > OSGB_LONGITUDE_MAX_EAST)) {
      return "coordinates out of range";
   	}

    double northing = N(latitude, longitude);
    double easting = E(latitude, longitude);
    return gridrefNumToLet(easting, northing, 8);
  }

  // http://blog.digitalagua.com/2008/06/30/how-to-convert-degrees-to-radians-radians-to-degrees-in-objective-c/
  private double degreesToRadians(double degrees) {
    return degrees * Math.PI / 180;
  }

  private double radiansToDegrees(double radians) {
    return radians * 180 / Math.PI;
  }

  private double cosLatitude(double latitude) {
    return Math.cos(latitude);
  }

  private double cos3Latitude(double latitude) {
    return (cosLatitude(latitude) * cosLatitude(latitude) * cosLatitude(latitude));
  }

  private double cos5Latitude(double latitude) {
    return (cos3Latitude(latitude) * cosLatitude(latitude) * cosLatitude(latitude));
  }

  private double sinLatitude(double latitude) {
    return Math.sin(latitude);
  }

  private double tan2Latitude(double latitude) {
    return (Math.tan(latitude) * Math.tan(latitude));
  }

  private double tan4Latitude(double latitude) {
    return (tan2Latitude(latitude) * tan2Latitude(latitude));
  }

  // transverse radius of curvature
  private double nu(double latitude) {
    return a*F0/Math.sqrt(1-e2*sinLatitude(degreesToRadians(latitude))*sinLatitude(degreesToRadians(latitude)));
  }

  // meridional radius of curvature
  private double rho(double latitude) {
    return a*F0*(1-e2)/Math.pow(1-e2*sinLatitude(degreesToRadians(latitude))*sinLatitude(degreesToRadians(latitude)), 1.5);
  }

  private double eta2(double latitude) {
    return nu(latitude)/rho(latitude)-1;
  }

  private double Ma(double latitude) {
    return (1 + n + (5/4)*n2 + (5/4)*n3) * (degreesToRadians(latitude)-lat0);
  }

  private double Mb(double latitude) {
    return ((3 * n) + (3 * n * n) + ((21/8) * n3)) * sinLatitude(degreesToRadians(latitude) - lat0) * cosLatitude(degreesToRadians(latitude) + lat0);
  }

  private double Mc(double latitude) {
    return ((15/8 * n2) + (15/8 * n3)) * sinLatitude(2 * (degreesToRadians(latitude) - lat0)) * cosLatitude(2 * (degreesToRadians(latitude) + lat0));
  }

  private double Md(double latitude) {
    return (35/24)*n3 * sinLatitude(3*(degreesToRadians(latitude)-lat0)) * cosLatitude(3*(degreesToRadians(latitude)+lat0));
  }

  // meridional arc
  private double M(double latitude) {
    return b * F0 * (Ma(latitude) - Mb(latitude) + Mc(latitude) - Md(latitude));
  }

  private double I(double latitude) {
    return (M(latitude) + N0);
  }

  private double II(double latitude) {
    return (nu(latitude) / 2) * sinLatitude(degreesToRadians(latitude)) * cosLatitude(degreesToRadians(latitude));
  }

  private double III(double latitude) {
    return (nu(latitude) / 24) *
  	sinLatitude(degreesToRadians(latitude)) *
  	cos3Latitude(degreesToRadians(latitude)) *
  	(5 - tan2Latitude(degreesToRadians(latitude)) +
  	 9 * eta2(latitude));
  }

  private double IIIA(double latitude) {
    return (nu(latitude)/720)*sinLatitude(degreesToRadians(latitude))*cos5Latitude(degreesToRadians(latitude))*(61-58*tan2Latitude(degreesToRadians(latitude))+tan4Latitude( degreesToRadians(latitude)));
  }

  private double IV(double latitude) {
    return nu(latitude) * cosLatitude(degreesToRadians(latitude));
  }

  private double V(double latitude) {
    return (nu(latitude)/6)*cos3Latitude(degreesToRadians(latitude))*(nu(latitude)/rho(latitude)-tan2Latitude(degreesToRadians(latitude)));
  }

  private double VI(double latitude) {
    return (nu(latitude)/120) * cos5Latitude(degreesToRadians(latitude)) * (5 - 18*tan2Latitude(degreesToRadians(latitude)) + tan4Latitude(degreesToRadians(latitude)) + 14*eta2(latitude) - 58*tan2Latitude(degreesToRadians(latitude))*eta2(latitude));
  }

  private double dLon(double longitude) {
    return (degreesToRadians(longitude) - lon0);
  }

  private double dLon2(double longitude) {
    return (dLon(longitude) * dLon(longitude));
  }

  private double dLon3(double longitude) {
    return (dLon2(longitude) * dLon(longitude));
  }

  private double dLon4(double longitude) {
    return (dLon3(longitude) * dLon(longitude));
  }

  private double dLon5(double longitude) {
    return (dLon4(longitude) * dLon(longitude));
  }

  private double dLon6(double longitude) {
    return (dLon5(longitude) * dLon(longitude));
  }

  private double N(double latitude, double longitude) {
    return I(latitude) + II(latitude)*dLon2(longitude) + III(latitude)*dLon4(longitude) + IIIA(latitude)*dLon6(longitude);
  }

  private double E(double latitude, double longitude) {
    return E0 + IV(latitude)*dLon(longitude) + V(latitude)*dLon3(longitude) + VI(latitude)*dLon5(longitude);
  }

  // convert numeric grid reference (in metres) to standard-form grid ref
  private String gridrefNumToLet(double E, double N, int digits) {
    // get the 100km-grid indices
    double e100k = Math.floor(E / 100000);
    double n100k = Math.floor(N / 100000);

    if (e100k < 0 || e100k > 6 || n100k < 0 || n100k > 12) {
      return "out of range";
    }

    // translate those into numeric equivalents of the grid letters
    double l1 = (19-n100k) - (19-n100k)%5 + Math.floor((e100k+10)/5);
    double l2 = (19-n100k)*5%25 + e100k%5;

    // compensate for skipped 'I' and build grid letter-pairs
    if (l1 > 7) l1++;
    if (l2 > 7) l2++;

    l1 = l1+'A';
    l2 = l2+'A';

    try {
      byte[] grid1 = new byte[] {new Double(l1).byteValue()};
      byte[] grid2 = new byte[] {new Double(l2).byteValue()};
      String firstGridLetter = new String(grid1, "UTF-8");
      String secondGridLetter = new String(grid2, "UTF-8");

      double easting = Math.floor((((int)E)%100000) / Math.pow(10, 5-digits/2));
      double northing = Math.floor((((int)N)%100000) / Math.pow(10, 5-digits/2));

      return String.format("%s%s %04d %04d", firstGridLetter, secondGridLetter, (int)easting, (int)northing);
    }
    catch(UnsupportedEncodingException usee) {
      return null;
    }
  }

  private CBLatLon oSGB36toWGS84(double latitude, double longitude) {
    return convert(latitude, longitude, airy1830, oSGB36toWGS84, wGS84);
  }

  private CBLatLon wGS84toOSGB36(double latitude, double longitude) {
    return convert(latitude, longitude, wGS84, wGS84toOSGB36, airy1830);
  }

  private CBLatLon convert(double latitude, double longitude, Ellipse ellipse1, HelmertTransform helmert, Ellipse ellipse2) {
    CBLatLon latLon = new CBLatLon();

  	if ((latitude < OSGB_LATITUDE_MIN) || (latitude > OSGB_LATITUDE_MAX) ||
  		  (longitude < OSGB_LONGITUDE_MAX_WEST) || (longitude > OSGB_LONGITUDE_MAX_EAST)) {
      latLon.status = "coordinates out of range";
      return latLon;
  	}

    latLon.latitude = degreesToRadians(latitude);
    latLon.longitude = degreesToRadians(longitude);

    double _a = ellipse1.a;
    double _b = ellipse1.b;

    double sinPhi = sinLatitude(latLon.latitude);
    double cosPhi = cosLatitude(latLon.latitude);
    double sinLambda = sinLatitude(latLon.longitude);
    double cosLambda = cosLatitude(latLon.longitude);
    double H = 0; // p1.height ???

    double eSq = (_a*_a - _b*_b) / (_a*_a);
    double nu = _a / Math.sqrt(1 - eSq*sinPhi*sinPhi);

    double x1 = (nu+H) * cosPhi * cosLambda;
    double y1 = (nu+H) * cosPhi * sinLambda;
    double z1 = ((1-eSq)*nu + H) * sinPhi;

    // apply helmert transform using appropriate params
    double tx = helmert.tx;
    double ty = helmert.ty;
    double tz = helmert.tz;

    double rx = helmert.rx/3600 * Math.PI/180;  // normalise seconds to radians
    double ry = helmert.ry/3600 * Math.PI/180;
    double rz = helmert.rz/3600 * Math.PI/180;
    double s1 = helmert.s/1e6 + 1;              // normalise ppm to (s+1)

    // apply transform
    double x2 = tx + x1*s1 - y1*rz + z1*ry;
    double y2 = ty + x1*rz + y1*s1 - z1*rx;
    double z2 = tz - x1*ry + y1*rx + z1*s1;

    // convert cartesian to polar coordinates (using ellipse 2)
    _a = ellipse2.a;
    _b = ellipse2.b;

    double precision = 4 / _a;  // results accurate to around 4 metres

    eSq = (_a*_a - _b*_b) / (_a*_a);
    double p = Math.sqrt(x2*x2 + y2*y2);
    double phi = Math.atan2(z2, p*(1-eSq));
    double phiP = 2*Math.PI;
    while (Math.abs(phi-phiP) > precision) {
      nu = _a / Math.sqrt(1 - eSq*Math.sin(phi)*Math.sin(phi));
      phiP = phi;
      phi = Math.atan2(z2 + eSq*nu*Math.sin(phi), p);
    }

    double lambda = Math.atan2(y2, x2);
    H = p/Math.cos(phi) - nu;

    latLon.latitude = radiansToDegrees(phi);
    latLon.longitude = radiansToDegrees(lambda);

    return latLon;
  }




  private class Ellipse {
    public Ellipse(double a, double b, double f) {
      this.a = a;
      this.b = b;
      this.f = f;
    }
    double a;
    double b;
    double f;
  }

  private class HelmertTransform {
    public HelmertTransform(double tx, double ty, double tz,
                            double rx, double ry, double rz,
                            double s) {
      this.tx = tx;
      this.ty = ty;
      this.tz = tz;
      this.rx = rx;
      this.ry = ry;
      this.rz = rz;
      this.s = s;
    }

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
  }
}
