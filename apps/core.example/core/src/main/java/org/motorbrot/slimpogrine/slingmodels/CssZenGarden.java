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

  private static final String[] CSS_IDS = new String[]{
    "041", // 'door to my garden' by Patrick Lauke, http://redux.deviantart.com/
    "083", // 'Springtime', by Boër Attila
    "084", // 'Start Listening!', by Liz Lubowitz, http://hiptobeasquare.com 
    "099", // 'Wiggles the Wonderworm', by Joseph Pearson, http://www.make-believe.org/
    "139", // 'Neat & Tidy', by Oli Dale, http://www.designerstalk.com/
    "142", // 'Invasion of the Body Switchers' by Andy Clarke, http://www.stuffandnonsense.co.uk/
    "145", // 'Paravion', by Emiliano Pennisi, http://www.peamarte.it/01/metro.html
    "146", // 'Urban', by Matt, Kim &amp; Nicole, http://www.learnnewmedia.designer-namea/
    "156", // 'Table Layout Assassination', by Marko Krsul & Marko Dugonjic, http://web.burza.hr/
    "171", // 'Shaolin Yokobue', by Javier Cabrera, http://www.emaginacion.com.ar/hacks/
    "177", // 'Zen City Morning', by Ray Henry, http://www.reh3.com/
    "193", // 'Leggo My Ego', by Jon Tan, http://www.gr0w.com/
    "194", // 'Dark Rose', by Rose Fu, http://www.rosefu.net/
    "195", // 'Dazzling Beauty', by Deny Sri Supriyono, http://blog.denysri.com/
    "198", // 'The Original', by Joachim Shotter, http://www.bluejam.com/
    "199", // 'Zen Army', by Carl Desmond, http://www.niceguy.com/
    "200", // 'Icicle Outback', by Timo Virtanen, http://www.timovirtanen.com/
    "202", // 'Retro Theater', by Eric RogŽ, http://space-sheeps.info/
    "205", // 'spring360', by Rene Hornig, http://www.medialab360.com/
    "214", // 'Verde Moderna', by Dave Shea, http://www.mezzoblue.com/
    "215", // 'A Robot Named Jimmy', by meltmedia, http://meltmedia.com 
    "218", // 'Apothecary', by Trent Walton, http: //www.trentwalton.com/
    "219", // 'Steel', by Steffen Knoeller, http://www.steffen-knoeller.de/ 
    "221"  // 'Mid Century Modern', by Andrew Lohman, http://www.andrewlohman.com/
  };

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
