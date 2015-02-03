Table violationsTable = loadTable("Food_Inspections_FailedDroppings_Clean.csv", "header");

Table table = new Table();

table.addColumn("inspectionID");
table.addColumn("licenseNumber");
table.addColumn("violationNumber");
table.addColumn("violationTitle");
table.addColumn("violationComment");

for (TableRow row : violationsTable.rows ())
{
  String rawViolation = row.getString("Violations");
  String inspectionID = row.getString("Inspection ID");
  String licenseNumber = row.getString("License #");


  // Split our violations into lines representing each violation.
  String[] violations = split(rawViolation, "|");

  // Iterate through the violation lines one by one ...
  for (String violation : violations)
  {
    // Trim the violation ...
    String trimmedViolation = trim(violation);

    // Split the trimmed violation at the "- Comments: " string. 
    String[] violationAndComment = split(trimmedViolation, "- Comments:");

    // Check to see if we got 2 parts (a violation and a comment).
    if (violationAndComment.length == 2)
    {
      // Trim both parts and make them into their own variables.
      String violationPart = trim(violationAndComment[0]);
      String commentPart = trim(violationAndComment[1]);

      // Find the index of the period.
      int indexOfPeriod = violationPart.indexOf(".");

      String violationNumber = trim(violationPart.substring(0, indexOfPeriod));
      String violationTitle = trim(violationPart.substring(indexOfPeriod + 1));

      // If we want to ...    
      int violationNumberInt = int(violationNumber); // Turn string into number.

      println("Violation Number: " + violationNumber);
      println(" Violation Title: " + violationTitle);
      println("         Comment: " + commentPart);
      println("");

      TableRow newRow = table.addRow();
  
  
      newRow.setString("inspectionID", inspectionID);
      newRow.setString("licenseNumber", licenseNumber);
      newRow.setInt("violationNumber", violationNumberInt);
      newRow.setString("violationTitle", violationTitle);
      newRow.setString("violationComment", commentPart);
    } else 
    {
      println("Something happened that was not expected ...");
    }
  }
}

saveTable(table, "data/ViolationTable.csv");

