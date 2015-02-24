import java.text.SimpleDateFormat;

// Output the array of recipients' email addresses with spaces between.
public String addressesToString(Address[] addresses)
{
  if (addresses == null) return "";

  StringBuffer sb = new StringBuffer();

  for (int i = 0; i < addresses.length; ++i)
  {
    sb.append(((InternetAddress)addresses[i]).getAddress());

    if (i < addresses.length - 1) 
    {
      sb.append(" ");
    }
  }

  return sb.toString();
}

public String messageFlagsToString(Message message)
{
  StringBuffer sb = new StringBuffer();
  try {
    // FLAGS:
    Flags flags = message.getFlags();
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
  } 
  catch (Exception e)
  {
    e.printStackTrace();
  }

  return sb.toString();
}

public Address[] stringToAddresses(String addressString)
{
  String[] tokens = split(addressString, " ");

  Address[] addresses = new Address[tokens.length];

  try {

    for (int i = 0; i < tokens.length; ++i)
    {
      addresses[i] = new InternetAddress(tokens[i]);
    }
  } 
  catch (Exception e)
  {
    e.printStackTrace();
  }

  return addresses;
}

// Modify this function to create your CSV Table.
public void messagesToCSV(Message[] messages, String filename)
{
  try {
    // http://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html
    SimpleDateFormat dateFormatter = new SimpleDateFormat();

    Table table = new Table();

    table.addColumn("messageId");
    table.addColumn("message-ID");
    table.addColumn("threadId");
    table.addColumn("receivedDate");
    table.addColumn("sentDate");
    table.addColumn("subject");
    table.addColumn("to");
    table.addColumn("cc");
    table.addColumn("bcc");
    table.addColumn("replyTo");
    table.addColumn("from");
    table.addColumn("labels");
    table.addColumn("flags");
    table.addColumn("inReplyTo");

    println("Writing messages: ");

    for (int i = 0; i < messages.length; ++i)
    {
      println((i+1) + " / " + messages.length);

      TableRow newRow = table.addRow();
      GmailMessage m = (GmailMessage)messages[i];

      Date sentDate = m.getSentDate();
      Date receivedDate = m.getReceivedDate();

      newRow.setString("messageId", ""+m.getMsgId());
      newRow.setString("threadId", ""+m.getThrId());
      newRow.setString("sentDate", dateFormatter.format(sentDate));
      newRow.setString("receivedDate", dateFormatter.format(receivedDate));
      newRow.setString("subject", m.getSubject());

      newRow.setString("from", addressesToString(m.getFrom()));
      newRow.setString("to", addressesToString(m.getRecipients(Message.RecipientType.TO)));
      newRow.setString("cc", addressesToString(m.getRecipients(Message.RecipientType.CC)));
      newRow.setString("bcc", addressesToString(m.getRecipients(Message.RecipientType.BCC)));
      newRow.setString("replyTo", addressesToString(m.getReplyTo()));

      String[] inReplyTo = m.getHeader("In-Reply-To");

      if (inReplyTo != null)
      {

        newRow.setString("inReplyTo", inReplyTo[0]);

        if (inReplyTo.length > 1)
        {
          pritnln("inReplyTo.length=" + inReplyTo.length);
        }
      } else
      {
        println("inReplyTo = null");
      }

      String[] messageID = m.getHeader("Message-ID"))



        newRow.setString("inReplyTo", m.getHeader("In-Reply-To"));
      newRow.setString("message-ID", m.getHeader("Message-ID"));

      StringBuffer sb = new StringBuffer();

      String[] labels = m.getLabels();

      for (int j = 0; j < labels.length; ++j)
      {
        sb.append("%" + labels[j] + "%");

        if (j < labels.length - 1) 
        {
          sb.append(" ");
        }
      }

      newRow.setString("labels", sb.toString());
      newRow.setString("flags", messageFlagsToString(m));
    }

    // Save all of the data.
    saveTable(table, dataPath(filename));

    println("Done.");
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }
}

