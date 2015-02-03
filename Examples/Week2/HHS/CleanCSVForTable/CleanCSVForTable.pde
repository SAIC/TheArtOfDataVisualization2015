import java.io.*;

String inputCSVFile = "Food_Inspections_FULL.csv";
String outputCSVFile = "Food_Inspections_FULL_Clean.csv";

try {
  // Create an opencsv reader.
  CSVReader reader = new CSVReader(new FileReader(dataPath(inputCSVFile)));

  // Create an opencsv writer
  CSVWriter writer = new CSVWriter(new FileWriter(dataPath(outputCSVFile)), ',');

  // Create an empty array of strings to represent the line.
  String[] nextRow; // This represents one row of data ...

  // Create a variable to count lines so we can tell something is happening.
  int lineCounter = 0;

  // Iterate through the lines one by one.
  while ( (nextRow = reader.readNext ()) != null) {
    
    // For each entry in a line, replace all of the new line characters with nothing.
    // Trim all white space from the beginning and end of ách entry.
    for (int i = 0; i < nextRow.length; ++i)
    {
      nextRow[i] = nextRow[i].replaceAll("\n","");
      nextRow[i] = nextRow[i].replaceAll("Inspector Comments: ", "");
      nextRow[i] = nextRow[i].trim();
    }
    
    // Write the cleaned entries back to the disk.
    writer.writeNext(nextRow);
    
    println("Cleaning line number: " + lineCounter);
    lineCounter++;
  }

  // Close the writer and save the file.
  writer.close();
} 
catch (IOException e)
{
  // Print any errors if they are encountered.
  e.printStackTrace();
}

// Test reading it into a processing Table.

println("Loading into Table ...");
Table table = loadTable(outputCSVFile, "header");

println("Removing columns ...");
table.removeColumn("Location");
table.removeColumn("Address");
table.removeColumn("City");
table.removeColumn("State");

println("Saving new CSV ...");
saveTable(table, "data/Refined.csv");
println("Done!");

