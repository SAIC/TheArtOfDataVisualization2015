import java.io.*;

String inputCSVFile = "Food_Inspections_FULL.csv";
String outputCSVFile = "Food_Inspections_FULL_Clean.csv";

try {
  // Create an opencsv reader.
  CSVReader reader = new CSVReader(new FileReader(dataPath(inputCSVFile)));

  // Create an opencsv writer
  CSVWriter writer = new CSVWriter(new FileWriter(dataPath(outputCSVFile)), ',');

  // Create an empty array of strings to represent the line.
  String[] nextLine;

  // Create a variable to count lines so we can tell something is happening.
  int lineCounter = 0;

  // Iterate through the lines one by one.
  while ( (nextLine = reader.readNext ()) != null) {
    
    // For each entry in a line, replace all of the new line characters with nothing.
    // Trim all white space from the beginning and end of ách entry.
    for (int i = 0; i < nextLine.length; ++i)
    {
      nextLine[i] = nextLine[i].replaceAll("\n","");
      nextLine[i] = nextLine[i].replaceAll("Inspector Comments: ", "");
      nextLine[i] = nextLine[i].trim();
    }
    
    // Write the cleaned entries back to the disk.
    writer.writeNext(nextLine);
    
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

