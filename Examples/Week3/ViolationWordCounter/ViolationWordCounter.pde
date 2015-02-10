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
  // Get the violation comment in its String representation.
  String violationComment = row.getString("violationComment");
  
  // Replace all "non letter" characters with nothing.
  // A "non letter" character is determined from the Unicode standard.
  violationComment = violationComment.replaceAll("[^\\p{L} ]", "");
  
  // Collapse all multi spaces into one. (i.e. "     " will become " ");
  violationComment = violationComment.replaceAll("[ ]+", " ");
  
  // Trim all violation comments.
  violationComment = violationComment.trim();

  // Convert everything to lower case.
  violationComment = violationComment.toLowerCase();

  // Split the cleaned comment string into words.
  String[] words = split(violationComment, " ");

  // Loop through all words in the comment.
  for (String word : words)
  {
    // Increment the count for the current word.
    // counts.add(word, 1); // Same as this.
    counts.increment(word);
  }
}

// Sort my counts from highest count to lowest count.
counts.sortValuesReverse();

// Print the dictionary to the console for debugging purposes.
// println(counts);

// Get a list of the keys so that we can cycle through them and get their counts.
String[] theKeys = counts.keyArray();

float inputMin = 0;
float inputMax = 58089;
float outputMin = 0;
float outputMax = width;

// This is so we can keep track of the y position of our bars.
float yPosition = 0;

int theNumberOfKeys = theKeys.length;

float rectangleHeight = 30; //height / theNumberOfKeys;

// Cycle through all of the keys in our counts table.
for (String theKey : theKeys)
{
  // Get the count for the current key.
  int count = counts.get(theKey); 
    
  if (count < 1000) return;
    
  float scaledCount = map(count, inputMin, inputMax, outputMin, outputMax);
  
  fill(255);
  rect(0, yPosition, scaledCount, rectangleHeight);
  
  fill(0);
  text(theKey + " " + count, 5, yPosition + rectangleHeight);
  
  yPosition = yPosition + rectangleHeight;
  
}



