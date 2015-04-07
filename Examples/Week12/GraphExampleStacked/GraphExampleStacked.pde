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

float[] sums = { 
  0, 0, 0, 0, 0, 0, 0, 0
};


// Go through the rows of the table.
for (int rowNumber = 0; rowNumber < table.getRowCount (); rowNumber++) 
{
  TableRow row = table.getRow(rowNumber);

  fill(red(colors[rowNumber]), green(colors[rowNumber]), blue(colors[rowNumber]), 127);
  noStroke();
  beginShape();

  for (int position = 0; position < 8; position++)
  {
    float y = row.getFloat(position);

    // Re-mapping our y values to fit on height of our screen.
    // 5 * 255 is the maximum total height we could achieve.
    float mappedY = map(y + sums[position], 0, 5 * 255, height, 0);

    // Mapping our positions to our X-axis or width.
    float x = map(position, 0, 7, 0, width); 
    vertex(x, mappedY);
  }

  for (int position = 7; position >= 0; position--)
  {
    // Re-mapping our y values to fit on height of our screen.
    // 5 * 255 is the maximum total height we could achieve.
    float mappedY = map(sums[position], 0, 5 * 255, height, 0);
    // Mapping our positions to our X-axis or width.
    float x = map(position, 0, 7, 0, width); 
    vertex(x, mappedY);
  }

  endShape();


  // Go through the columns in that row and add the sums.
  for (int position = 0; position < 8; position++)
  {
    // Save up the original y value.
    sums[position] += row.getFloat(position);
  }

  beginShape();

  noFill();
  strokeWeight(4);
  stroke(colors[rowNumber]);

  // Go through the columns in that row and add the sums.
  for (int position = 0; position < 8; position++)
  {
    // Re-mapping our y values to fit on height of our screen.
    // 5 * 255 is the maximum total height we could achieve.
    float mappedY = map(sums[position], 0, 5 * 255, height, 0);
    // Mapping our positions to our X-axis or width.
    float x = map(position, 0, 7, 0, width); 
    vertex(x, mappedY);
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

