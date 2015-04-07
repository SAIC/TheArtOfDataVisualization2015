size(800, 600);
background(0);

Table table = loadTable("data.csv", "header");

color[] colors = { 
  color(0, 255, 0), 
  color(255, 255, 0), 
  color(255, 0, 255), 
  color(127, 0, 54), 
  color(55, 55, 255)
}; 

String[] labels = { 
  "Madison", 
  "Monroe", 
  "Adams", 
  "Jackson", 
  "Van Buren"
}; 


// Go through the rows of the table.
for (int rowNumber = 0; rowNumber < table.getRowCount (); rowNumber++) 
{
  TableRow row = table.getRow(rowNumber);

  noFill();
  stroke(colors[rowNumber]);
  beginShape();

  // Go through the columns in that row.
  for (int position = 0; position < 8; position++)
  {
    float y = row.getFloat(str(position));

    // Re-mapping our y values to fit on height of our screen.
    y = map(y, 0, 255, height, 0);

    // Mapping our positions to our X-axis or width.
    float x = map(position, 0, 7, 0, width); 

    curveVertex(x, y);
    
    ellipse(x, y, 10, 10);
    
    if (position == 0 || position == 7)
    {
      curveVertex(x, y);
    }
  }

  endShape();
}


// Draw a legend.
for (int i = 0; i < 5; i++)
{
  fill(colors[i]);
  noStroke();
  rect(10, i * 10, 10, 10);
  
  text(labels[i], 22, i * 10 + 10);
  
}


