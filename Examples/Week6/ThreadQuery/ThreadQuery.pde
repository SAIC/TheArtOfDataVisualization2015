import java.util.*;

// For date manipulation, we use JodaTime.  It is much more user-friendly than 
// the built-in Java Date and Calendar objects.  More documentation can be found
// here: http://www.joda.org/joda-time/userguide.html

// Instantiate an email archive.
EmailArchive threads;

void setup() {
  size(800, 600);
  background(0);

  // Initialize the archive.
  threads = new EmailArchive();

  Table table = loadTable("output.csv", "header");

  // This is our collection of dates in the DateTime format.

  // Our format: 8/13/11 20:16
  DateTimeFormatter dateFormat = DateTimeFormat.forPattern("MM/dd/yy HH:mm");

  // Extract our dates into a 
  for (TableRow row : table.rows ())
  {
    // Get our thread id.
    long threadId = Long.parseLong(row.getString("threadId"));

    // Convert our date from a string to a DateTime object.
    DateTime dt = dateFormat.parseDateTime(row.getString("sentDate"));

    threads.add(threadId, dt);
  }

  println("Total messages: " + table.getRowCount()); 
  println("Total threads: " + threads.getSize());
  println("Archive Duration: " + threads.getDuration());
  println("Shortest thread: " + threads.getShortestThreadId());
  println("Longest thread: " + threads.getLongestThreadId());

  // 
  for (EmailThread thread : threads.getThreads ())
  {
    if (thread.getCount() > 1)
    {
      println("Thread ID: " + thread.getId());
      
      for (DateTime message : thread.getMessages ())
      {
        println("\t" + message.toString(dateFormat));
      }
    }
  }
}

void draw()
{
}

