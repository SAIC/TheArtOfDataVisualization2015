// For this example, you need a csv file with a list of "from" email addresses.

Table table = loadTable("output.csv", "header");

println(table.getRowCount() + " total rows in table"); 

IntDict fromCounts = new IntDict();

for (TableRow row : table.rows ())
{
  String sender = row.getString("from");
  fromCounts.increment(sender);
}

// Sort the from counts in reverse.
fromCounts.sortValues();

for (String from : fromCounts.keys ()) {
  println(fromCounts.get(from) + " : " + from);
}

