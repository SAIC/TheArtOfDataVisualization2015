IntDict wordCounts = new IntDict();

Table table = loadTable("ViolationTable.csv", "header");

println(table.getRowCount() + " total rows in table"); 

for (TableRow row : table.rows ()) {

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

  String[] words = split(violationComment, " ");

  for (String word : words)
  {
     int currentCount = wordCounts.get(word) + 1;
     wordCounts.set(word, currentCount);
  }

//  println(violationComment);
}

