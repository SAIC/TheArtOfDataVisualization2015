// Set the size of our sketch area.
size(800, 600);

// Load the csv file into the Table object.
Table table = loadTable("ViolationTable.csv", "header");

// Create a dictionary of counts for each violation number.
IntDict counts = new IntDict();

// Print the number of rows to the console, to make sure it is the number expected.
println(table.getRowCount() + " rows found.");

// Go through each row in a for-loop and do something with each row.
for (TableRow row : table.rows())
{
  // Get the violation number in its String representation.
  String violationNumber = row.getString("violationNumber");
  
  // Add a +1 to each count for that violation number.
  counts.add(violationNumber, 1);
}

// Sort my counts from highest count to lowest count.
counts.sortValuesReverse();

// Print the dictionary to the console for debugging purposes.
// println(counts);

// Get a list of the keys so that we can cycle through them and get their counts.
String[] theKeys = counts.keyArray();

float inputMin = 3;
float inputMax = 3771;
float outputMin = 0;
float outputMax = width;

// This is so we can keep track of the y position of our bars.
float yPosition = 0;

int theNumberOfKeys = theKeys.length;

float rectangleHeight = height / theNumberOfKeys;

// Cycle through all of the keys in our counts table.
for (String theKey : theKeys)
{
  // Get the count for the current key.
  int count = counts.get(theKey); 
    
  float scaledCount = map(count, inputMin, inputMax, outputMin, outputMax);
  
  fill(255);
  rect(0, yPosition, scaledCount, rectangleHeight);
  
  fill(0);
  text(theKey, 5, yPosition);
  
  yPosition = yPosition + rectangleHeight;
  
  println(scaledCount);
}



