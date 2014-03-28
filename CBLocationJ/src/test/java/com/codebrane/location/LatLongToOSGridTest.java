package com.codebrane.location;

import org.junit.Assert;
import org.junit.Test;

public class LatLongToOSGridTest extends CBLocationTest {
  @Test
  public void test() {
    logger.info("testing LatLongToOSGrid functionality");
    CBLocation cbLocation = new CBLocation();
    String osGridRef = cbLocation.oSGridRefFromLatitudeAndLongitude(55.8620, -4.2450);
    Assert.assertEquals("NS 5951 6547", osGridRef);
  }
}
