package com.codebrane.location;

import org.junit.Assert;
import org.junit.Test;

public class GridRefOutOfRangeTest extends CBLocationTest {
  @Test
  public void test() {
    logger.info("testing GridRefOutOfRange functionality");
    CBLocation cbLocation = new CBLocation();
    String gridRef = cbLocation.oSGridRefFromLatitudeAndLongitude(62.123, -10.123);
    Assert.assertEquals("coordinates out of range", gridRef);
  }
}
