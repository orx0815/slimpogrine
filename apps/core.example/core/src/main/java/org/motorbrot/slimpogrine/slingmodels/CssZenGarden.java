package org.motorbrot.slimpogrine.slingmodels;

import java.util.Arrays;
import java.util.List;
import java.util.Random;
import javax.inject.Inject;
import org.apache.commons.lang3.StringUtils;

import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.models.annotations.Model;
import org.apache.sling.models.annotations.injectorspecific.Self;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Answers with css id
 */
@Model(adaptables = {SlingHttpServletRequest.class})
public class CssZenGarden {

  private static final String[] CSS_IDS = new String[]{"099", "142", "221", "214", "215", "219"};

  private static final Logger LOG = LoggerFactory.getLogger(SampleRequestModel.class);
  
  private final String cssId;

  /**
   * Constructor
   */
  @Inject
  public CssZenGarden(@Self SlingHttpServletRequest request) {
    
    final List<String> ids = Arrays.asList(CSS_IDS);
    String suffix = StringUtils.removeStart(request.getRequestPathInfo().getSuffix(), "/");
    if (ids.contains(suffix)) {
      this.cssId = suffix;
    } else {
      Random rand = new Random();
      this.cssId = CSS_IDS[rand.nextInt(CSS_IDS.length)];
      LOG.info("CSS-id is: " + this.cssId);
    }
        
  }

  /**
   * @return Random id of zengarden's css
   */
  public String getRandomCss() {
    return this.cssId;
  }

}
