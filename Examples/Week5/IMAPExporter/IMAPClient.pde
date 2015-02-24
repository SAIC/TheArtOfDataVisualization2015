import java.util.*;

import java.io.File;
import java.io.FileInputStream;
import java.util.Properties;

import java.util.*;
import java.io.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.mail.search.*;
import javax.activation.*;
import com.sun.mail.imap.*;

class IMAPClient {

  boolean debug;
  String host;
  int port;
  String username;
  String password;
  String rootFolder;
  String provider;

  public IMAPClient(JSONObject config)
  {
    debug = config.getBoolean("debug", false);
    host = config.getString("host", "imap.gmail.com");
    port = config.getInt("port", 993);
    username = config.getString("username");
    password = config.getString("password");
    rootFolder = config.getString("rootFolder", "[Gmail]/All Mail");

    // Use the experimental GMail provider if the IMAP host matches.
    provider = host.equals("imap.gmail.com") ? "gimap" : "imaps";
  }

  // Create a date range search term.
  SearchTerm makeDateRangeSearchTerm(int startDay, int startMonth, int startYear, int endDay, int endMonth, int endYear)
  {
    Calendar startDate = Calendar.getInstance();
    startDate.clear();
    startDate.set(startYear, startMonth, startDay);

    ReceivedDateTerm startDateTerm = new ReceivedDateTerm(ComparisonTerm.GT, startDate.getTime());

    Calendar endDate = Calendar.getInstance();
    endDate.clear();
    endDate.set(endYear, endMonth, endDay);

    ReceivedDateTerm endDateTerm = new ReceivedDateTerm(ComparisonTerm.LT, endDate.getTime());

    return new AndTerm(startDateTerm, endDateTerm);
  }

  // The default fetch profile 
  FetchProfile getDefaultFetchProfile()
  {
    // Use a default fetch profile.
    // https://javamail.java.net/nonav/docs/api/javax/mail/FetchProfile.html
    FetchProfile fetchProfile = new FetchProfile();
    // https://javamail.java.net/nonav/docs/api/javax/mail/FetchProfile.Item.html    
    fetchProfile.add(FetchProfile.Item.ENVELOPE);
    fetchProfile.add(FetchProfile.Item.FLAGS);
    fetchProfile.add(FetchProfile.Item.CONTENT_INFO);
    fetchProfile.add("X-mailer");
    fetchProfile.add("In-Reply-To");
    fetchProfile.add("Message-ID");

    // The following are GMail-specific custom headers. 
    fetchProfile.add(GmailFolder.FetchProfileItem.MSGID);
    fetchProfile.add(GmailFolder.FetchProfileItem.THRID);
    fetchProfile.add(GmailFolder.FetchProfileItem.LABELS);
    return fetchProfile;
  }

  // Search for messages using a raw GMail search string.
  // https://support.google.com/mail/answer/7190
  public Message[] search(String rawSearch)
  {
    return search(new GmailRawSearchTerm(rawSearch));
  }

  // Search for messages using a standard Java mail SearchTerm.
  // This search term can be a combination of many others 
  public Message[] search(SearchTerm searchTerm) {
    return search(searchTerm, getDefaultFetchProfile());
  }

  // Search for message headers with a SearchTerm and a FetchProfile.
  public Message[] search(SearchTerm searchTerm, FetchProfile fetchProfile) {
    Message[] messages = new Message[0];
    Folder folder = null;
    Store store = null;
    Session session = null;

    try {
      Properties props = new Properties();

      // Get a default session.
      session = Session.getDefaultInstance(props, null);

      // Get a default IMAPS store.
      store = session.getStore(provider);

      // Connect to the store with the configuration.
      store.connect(host, port, username, password);

      // Get a reference to the root folder in the mail store.
      folder = store.getFolder(rootFolder);

      // Open the root folder as read only.
      // We don't want to mark messages as read when we're querying them.
      folder.open(Folder.READ_ONLY);

      log("Connecting to: " + rootFolder + "\n");

      // Count the total number of messages in the folder.
      int messageCount = folder.getMessageCount();

      log("Total Messages: " + messageCount + "\n");

      // Should we search or list all of them?
      if (searchTerm != null)
      {
        // If our search term is not null, then we use it to search.
        log("Searching messages ... ");
        messages = folder.search(searchTerm);
        log("done.\n");
      } else 
      {
        log("Getting messages ... ");
        // Otherwise, we just get all of the messages in the folder.
        messages = folder.getMessages();
        log("done.\n");
      }

      // Ensure that we have a valid fetch profile.
      if (fetchProfile == null)
      {
        fetchProfile = getDefaultFetchProfile();
      }

      log("Fetch profile Items:\n");
      for (FetchProfile.Item item : fetchProfile.getItems ())
      {
        log("\t" + item + "\n");
      }

      log("Fetch profile headers:\n");
      for (String header : fetchProfile.getHeaderNames ())
      {
        log("\t" + header + "\n");
      }

      log("Fetching headers ... ");
      folder.fetch(messages, fetchProfile);
      log("done.\n");

      folder.close(false);
      store.close();
    } 
    catch (Exception e) {
      e.printStackTrace();
    }

    return messages;
  }

  void log(String message)
  {
    if (debug) print(message);
  }

  public void dumpPart(Part p) {
    try {
      if (p instanceof Message) {
        Message m = (Message)p;
        Address[] a;
        // FROM 
        if ((a = m.getFrom()) != null) {
          for (int j = 0; j < a.length; j++)
            System.out.println("FROM: " + a[j].toString());
        }

        // TO
        if ((a = m.getRecipients(Message.RecipientType.TO)) != null) {
          for (int j = 0; j < a.length; j++)
            System.out.println("TO: " + a[j].toString());
        }

        // CC
        if ((a = m.getRecipients(Message.RecipientType.CC)) != null) {
          for (int j = 0; j < a.length; j++)
            System.out.println("CC: " + a[j].toString());
        }

        // BCC
        if ((a = m.getRecipients(Message.RecipientType.BCC)) != null) {
          for (int j = 0; j < a.length; j++)
            System.out.println("BCC: " + a[j].toString());
        }

        // SUBJECT
        System.out.println("SUBJECT: " + m.getSubject());

        // DATE
        Date d = m.getSentDate();
        System.out.println("SendDate: " + (d != null ? d.toLocaleString() : "UNKNOWN"));

        // FLAGS:
        Flags flags = m.getFlags();
        StringBuffer sb = new StringBuffer();
        Flags.Flag[] sf = flags.getSystemFlags(); // get the system flags

          boolean first = true;
        for (int i = 0; i < sf.length; i++) {
          String s;
          Flags.Flag f = sf[i];
          if (f == Flags.Flag.ANSWERED)
            s = "\\Answered";
          else if (f == Flags.Flag.DELETED)
            s = "\\Deleted";
          else if (f == Flags.Flag.DRAFT)
            s = "\\Draft";
          else if (f == Flags.Flag.FLAGGED)
            s = "\\Flagged";
          else if (f == Flags.Flag.RECENT)
            s = "\\Recent";
          else if (f == Flags.Flag.SEEN)
            s = "\\Seen";
          else
            continue;  // skip it
          if (first)
            first = false;
          else
            sb.append(' ');
          sb.append(s);
        }

        String[] uf = flags.getUserFlags(); // get the user flag strings
        for (int i = 0; i < uf.length; i++) {
          if (first)
            first = false;
          else
            sb.append(' ');
          sb.append(uf[i]);
        }
        System.out.println("FLAGS = " + sb.toString());
      }
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }
}

