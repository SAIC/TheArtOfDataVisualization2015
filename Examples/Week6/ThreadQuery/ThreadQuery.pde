import java.util.*;

// For date manipulation, we use JodaTime.  It is much more user-friendly than 
// the built-in Java Date and Calendar objects.  More documentation can be found
// here: http://www.joda.org/joda-time/userguide.html

EmailArchive threads;

void setup() {
  size(800, 600);
  background(0);

  threads = new EmailArchive();

  Table table = loadTable("output.csv", "header");

  // This is our collection of dates in the DateTime format.

  // Our format: 8/13/11 20:16
  DateTimeFormatter dateFormat = DateTimeFormat.forPattern("MM/dd/yy HH:mm");

  long startTime = Long.MAX_VALUE;
  long stopTime = Long.MIN_VALUE;

  // Extract our dates into a 
  for (TableRow row : table.rows ())
  {
    // Get our thread id.
    long threadId = Long.parseLong(row.getString("threadId"));

    // Convert our date from a string to a DateTime object.
    DateTime dt = dateFormat.parseDateTime(row.getString("sentDate"));

    if (dt.getMillis() > stopTime)
    {
      stopTime = dt.getMillis();
    } else if (dt.getMillis() < startTime)
    {
      startTime = dt.getMillis();
    }

    threads.add(threadId, dt);
  }

  println("Total messages: " + table.getRowCount()); 
  println("Total threads: " + threads.getSize());
  println("Archive Duration: " + (stopTime - startTime));
  println("Shortest thread: " + threads.getShortestThreadId());
  println("Longest thread: " + threads.getLongestThreadId());
}

void draw()
{
}

