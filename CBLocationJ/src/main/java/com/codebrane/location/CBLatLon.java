package com.codebrane.location;

/**
 * Class that encapsulates a latitude/longitude and corresponding status.
 * If status is not "ok", don't use the object.
 */
public class CBLatLon {
  public double latitude;
  public double longitude;
  public String status;
}
