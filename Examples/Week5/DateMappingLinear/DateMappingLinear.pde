import java.util.*;

// For date manipulation, we use JodaTime.  It is much more user-friendly than 
// the built-in Java Date and Calendar objects.  More documentation can be found
// here: http://www.joda.org/joda-time/userguide.html

// Set up size.
size(1280, 720);

// Set the background color to black.
background(0);

// Load table.
Table table = loadTable("sent.csv", "header");

println(table.getRowCount() + " total rows in table"); 

// This is our collection of dates in the DateTime format.
ArrayList<DateTime> dates = new ArrayList<DateTime>();

// Our format: 8/13/11 20:16
// Formatting clues here: http://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html
DateTimeFormatter dateFormat = DateTimeFormat.forPattern("MM/dd/yy HH:mm");

// Extract our dates into an array.
for (TableRow row : table.rows ())
{
  // Convert our date from a string to a DateTime object.
  String dateAsString = row.getString("sentDate");
  
  // Parse date string into DateTime format so we can do math.
  DateTime dt = dateFormat.parseDateTime(dateAsString);

  // Add it to our array list.
  dates.add(dt);
}

// Sort dates in increasing order.
Collections.sort(dates);

// Sort dates in decreasing order.
//Collections.sort(dates, Collections.reverseOrder());


// Get the first date in our array;
DateTime firstDate = dates.get(0);

// Get earliest date.  Format it with our formatter above.
println("Start date: " + firstDate.toString(dateFormat));

// Get the last date in our array.
DateTime lastDate = dates.get(dates.size() - 1);

// Gate latest date.  Format it with our formatter above.
println("  End date: " + lastDate.toString(dateFormat));

// Print the seconds since epoch time of the first date.
println(firstDate.getMillis());

// Print the seconds since epoch time of the last date.
println(lastDate.getMillis());

// Make the histogram!

int hoursInDay = 24;

IntDict sendCountsByHour = new IntDict();

// Initialize our counts.
for (int i = 0; i < hoursInDay; ++i)
{
  sendCountsByHour.set(str(i), 0);
}

// Iterate through all of our dates.
for (DateTime dt : dates)
{
  // Get the hour of the day and convert it to a string.
  // Find all of the other way you could divide up time.
  // http://joda-time.sourceforge.net/apidocs/org/joda/time/DateTime.html
  String hourOfDayString = str(dt.getHourOfDay());
  
  // Add one to the count for the given hourOfTheDay.
  sendCountsByHour.increment(hourOfDayString);
}

// Determine the largest count.
// We use this to scale our bars.

int maxCount = 0;
int hour = 0;

for (int i = 0; i < hoursInDay; ++i)
{
  int count = sendCountsByHour.get(str(i));
  if (count > maxCount)
  {
    hour = i;
    maxCount = count;
  }
}

// Draw the count bars vertically.

float yStep = height / float(hoursInDay);

// Cycle through each of the entries for the counts dictionary.
for (int i = 0; i < hoursInDay; ++i)
{
  int count = sendCountsByHour.get(str(i));

  float mappedCount = count / float(maxCount); // Normalize the number to range 0-1.

  // Push matrix (https://processing.org/tutorials/transform2d/)
  pushMatrix();
  translate(0, (yStep * i) + 5);
  fill(255);
  rect(25, 0, (width - 30) * mappedCount, 10);
  fill(255, 255, 0);
  text(str(i), 5, 10);
  popMatrix();
}

