package com.codebrane.location;

import org.junit.Assert;
import org.junit.Test;

public class OSGB36toWGS84Test extends CBLocationTest {
  @Test
  public void test() {
    logger.info("testing OSGB36toWGS84 functionality");
    CBLocation cbLocation = new CBLocation();
    CBLatLon cbLatlon = cbLocation.convertOSGB36toWGS84(57.237467437924735, -5.904435228421011);
    double latDiff = Math.abs(cbLatlon.latitude - 57.2372222144);
    double lonDiff = Math.abs(cbLatlon.longitude - -5.90555558974);
    Assert.assertTrue(latDiff <= 2.8E-11);
    Assert.assertTrue(lonDiff <= 4.9E-7);
  }
}
