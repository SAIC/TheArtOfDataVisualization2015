import java.util.*;

// For date manipulation, we use JodaTime.  It is much more user-friendly than 
// the built-in Java Date and Calendar objects.  More documentation can be found
// here: http://www.joda.org/joda-time/userguide.html

size(800, 600);
background(0);

Table table = loadTable("sent.csv", "header");

println(table.getRowCount() + " total rows in table"); 

// This is our collection of dates in the DateTime format.
ArrayList<DateTime> dates = new ArrayList<DateTime>();

// Our format: 8/13/11 20:16
DateTimeFormatter dateFormat = DateTimeFormat.forPattern("MM/dd/yy HH:mm");

// Extract our dates into a 
for (TableRow row : table.rows ())
{
  // Convert our date from a string to a DateTime object.
  DateTime dt = dateFormat.parseDateTime(row.getString("sentDate"));

  // Add it to our array list.
  dates.add(dt);
}

// Sort dates in increaseing order.
Collections.sort(dates);

// Sort dates in decreasing order.
//Collections.sort(dates, Collections.reverseOrder());

// Get earliest date.  Format it with our formatter above.
println("Start date: " + dates.get(0).toString(dateFormat));

// Gate latest date.  Format it with our formatter above.
println("  End date: " + dates.get(dates.size() - 1).toString(dateFormat));

// getMinuteOfDay

int hoursInDay = 24;

IntDict sendCountsByHour = new IntDict();

// Initialize our counts.
for (int i = 0; i < hoursInDay; ++i)
{
  sendCountsByHour.set(str(i), 0);
}

for (DateTime dt : dates)
{
  sendCountsByHour.increment(str(dt.getHourOfDay()));
}

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


for (int i = 0; i < hoursInDay; ++i)
{
  int count = sendCountsByHour.get(str(i));
  
  float mappedCount = count / float(maxCount); // Normalize the number to range 0-1.
  
  pushMatrix();
  translate(width / 2, height / 2);
  rotate(radians(float(i) / hoursInDay * 360.0));
  rect(10, -5, 300 * mappedCount, 10);
  text(str(i), 300 * mappedCount, 0);
  popMatrix();
  
}

