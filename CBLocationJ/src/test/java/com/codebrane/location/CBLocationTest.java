package com.codebrane.location;

import org.junit.BeforeClass;

import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;
import java.util.logging.StreamHandler;

public abstract class CBLocationTest {
  protected static Logger logger = null;

  @BeforeClass
  public static void initUserTest() {
    loadLogger();
  }

  protected static void loadLogger() {
    logger = Logger.getLogger("com.codebrane.location");
    StreamHandler sh = new StreamHandler(System.out, new SimpleFormatter());
    logger.addHandler(sh);
  }
}
