
// The EmailArchive class is a wrapper for our HashMap.
class EmailArchive {

  // The HashMap represents two columns.
  // Column 1 is the threadId (a Long number).
  // Column 2 is our thread statistics class (see ThreadStatistics below)
  HashMap<Long, EmailThread> threads;

  // Constructor
  EmailArchive()
  {
    // Initialize the threads.
    threads = new HashMap<Long, EmailThread>();
  }

  // Add a thread id and time to the collection.
  void add(long threadId, DateTime time)
  {
    EmailThread thread = threads.get(threadId);

    // If the hash map has no entry, then it will be null and
    // that means we need to make a new entry.
    if (thread == null)
    {
      thread = new EmailThread(threadId);
    }

    // Add a time to the thread entry.
    thread.add(time);

    // Put the thread entry back in the hash map.
    threads.put(threadId, thread);
  }

  Collection<EmailThread> getThreads() 
  {
    return threads.values();
  }

  long getLongestThreadId() {
    long maxDuration = Long.MIN_VALUE;
    long threadId = 0;

    for (EmailThread thread : threads.values ())
    {
      long duration = thread.getDuration().getMillis();

      if (duration > maxDuration)
      {
        maxDuration = duration;
        threadId = thread.threadId;
      }
    }

    return threadId;
  }

  long getShortestThreadId() {
    long minDuration = Long.MAX_VALUE;
    long threadId = 0;

    for (EmailThread thread : threads.values ())
    {
      long duration = thread.getDuration().getMillis();

      if (duration < minDuration)
      {
        minDuration = duration;
        threadId = thread.threadId;
      }
    }

    return threadId;
  }


  EmailThread getThread(long threadId) {
    return threads.get(threadId);
  }


  // Get the number of unique threads.
  int getSize()
  {
    return threads.size();
  }
}

// A class representing the thread statistics.
class EmailThread {
  long threadId;

  // The first message in the thread.
  DateTime first;

  // The last message in the thread.
  DateTime last;

  // The number of messages in this thread.
  long count;

  EmailThread(long threadId) 
  {
    this.threadId = threadId;
    this.first = null;
    this.last = null;
  }

  void add(DateTime time)
  {
    if (time != null)
    {
      long timeMillis = time.getMillis();

      if (first == null && last == null)
      {
        first = new DateTime(timeMillis);
        last = new DateTime(timeMillis);
      } else if (timeMillis > last.getMillis()) {
        last = new DateTime(timeMillis);
      } else if (timeMillis < time.getMillis()) {
        first = new DateTime(timeMillis);
      }

      count++;
    }
  }

  // Get the number of messages that have been added to this thread.
  long getCount() {
    return count;
  }

  // Get the duration of the thread.
  Duration getDuration() {
    if (first == null || last == null) 
    {
      return Duration.ZERO;
    } else {
      return new Duration(first, last);
    }
  }
}

