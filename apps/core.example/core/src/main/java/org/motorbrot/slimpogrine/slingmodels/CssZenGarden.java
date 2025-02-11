package org.motorbrot.slimpogrine.slingmodels;

import java.util.Random;

import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.models.annotations.Model;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Answers with css id
 */
@Model(adaptables = {SlingHttpServletRequest.class})
public class CssZenGarden {

  private final String[] CSS_IDS = new String[]{"099", "142", "214", "215", "219"};

  private static final Logger LOG = LoggerFactory.getLogger(SampleRequestModel.class);

  private final String cssId;

  /**
   * constructor
   */
  public CssZenGarden() {
    Random rand = new Random();
    this.cssId = CSS_IDS[rand.nextInt(CSS_IDS.length)];
    LOG.info("CSS-id is: " + this.cssId);
  }

  /**
   * @return Random id of zengarden's css
   */
  public String getRandomCss() {
    return this.cssId;
  }

}
