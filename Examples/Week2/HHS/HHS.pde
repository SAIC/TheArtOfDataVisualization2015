// Loading the entire table takes a long time.
// Ideally you will make the table smaller.
Table table = loadTable("Food_Inspections.csv", "header");

println(table.getRowCount() + " total rows in table");

for (int i = 10; i < 22; ++i)
{
  TableRow row = table.getRow(i);

  double latitude = row.getDouble("Latitude");
  double longitude = row.getDouble("Longitude");

  String violations = trim(row.getString("Violations"));

  println("RAW:");
  println(violations);
  println("===");

  String[] tokens = split(violations, "|");

  for (String token : tokens)
  {
    String trimmedToken = trim(token);

    String[] tokens2 = split(trimmedToken, "- Comments:");

    if (tokens2.length >= 2)
    {
      String violation = trim(tokens2[0]);
      
      int periodIndex = violation.indexOf(".");
      
      int violationNumber = int(violation.substring(0, periodIndex));
      String violationTitle = trim(violation.substring(periodIndex + 1));
      String comment = trim(tokens2[1]);
  
      println("--");
      println("  Violation Number: " + violationNumber);
      println("   Violation Title: " + violationTitle);
      println(" Inspector Comment: " + comment);

    }
    else 
    {
       print 
    }

  }

  println("/////");
}

