
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

  // Return a single thread based on its id.
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

  ArrayList<DateTime> messages;

  EmailThread(long threadId) 
  {
    this.threadId = threadId;
    this.messages = new ArrayList<DateTime>();
  }

  long getId()
  {
     return threadId; 
  }

  void add(DateTime time)
  {
    if (time != null)
    {
      messages.add(time);
      Collections.sort(messages);
    }
  }

  ArrayList<DateTime> getMessages()
  {
     return messages; 
  }

  // Get the number of messages that have been added to this thread.
  long getCount() {
    return messages.size();
  }

  // Get the duration of the thread.
  Duration getDuration() {
    if (messages.size() > 0)
    {
      return new Duration(messages.get(0), messages.get(messages.size() - 1));
    } else {
      return Duration.ZERO;
    }
  }
}

