import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.utils.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.mapdisplay.shaders.*;

UnfoldingMap map;

Location chicago = new Location(41.83, -87.68);

Table table;

float angle = 0;

void setup() {
  size(800, 600, P2D);
  map = new UnfoldingMap(this);
  map.setTweening(true);
  map.zoomToLevel(3);
  map.panTo(new Location(40f, 8f));
  MapUtils.createDefaultEventDispatcher(this, map);

  table = loadTable("Food_Inspections.csv", "header");
}


void draw() {
  background(0);
  map.draw();
  
  angle += 1;

  for (TableRow row : table.rows ())
  {
    float lat = row.getFloat("Latitude");
    float lon = row.getFloat("Longitude");
    Location loc = new Location(lat, lon);
    // Zoom dependent marker size
    ScreenPosition pos = map.getScreenPosition(loc);

    String riskString = row.getString("Risk");

    float ellipseSize = 10;

    if (riskString.equals("Risk 1 (High)"))
    {
      // High risk is red!
      fill(200, 0, 0, 100);
      ellipseSize = 30;
    }
    else if(riskString.equals("Risk 2 (Medium)"))
    {
      // Medium risk is yellow!
      fill(200, 255, 0, 100);
      ellipseSize = 10;
    }
    else 
    {
      // low risk is green!
      fill(0, 255, 0, 100);
      ellipseSize = 5;
    }
    
    
    noStroke();
    ellipse(pos.x, pos.y, ellipseSize, ellipseSize);
    
    stroke(0);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(radians(angle));
    line(0, 0, 30, 0);
    popMatrix();
    
  }
}

