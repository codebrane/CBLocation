package com.codebrane.location;

import org.junit.Assert;
import org.junit.Test;

public class WGS84toOSGB36Test extends CBLocationTest {
  @Test
  public void test() {
    logger.info("testing WGS84toOSGB36 functionality");
    CBLocation cbLocation = new CBLocation();
    CBLatLon cbLatlon = cbLocation.convertWGS84toOSGB36(57.23722222222222, -5.905555555555556);
    double latDiff = Math.abs(cbLatlon.latitude - 57.2374674379);
    double lonDiff = Math.abs(cbLatlon.longitude - -5.904435);
    Assert.assertTrue(latDiff <= 2.5E-11);
    Assert.assertTrue(lonDiff <= 2.3E-7);
  }
}
