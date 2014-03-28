package com.codebrane.location;

import org.junit.Assert;
import org.junit.Test;

public class LatLonOutOfRangeTest extends CBLocationTest {
  @Test
  public void test() {
    logger.info("testing LatLonOutOfRange functionality");
    CBLocation cbLocation = new CBLocation();
    CBLatLon cbLatlon = cbLocation.convertWGS84toOSGB36(62.123, -10.123);
    Assert.assertEquals("coordinates out of range", cbLatlon.status);
  }
}
