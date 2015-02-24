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


public Address[] stringToAddresses(String addressString)
{
  String[] tokens = split(addressString, " ");

  Address[] addresses = new Address[tokens.length];

  for (int i = 0; i < tokens.length; ++i)
  {
    addresses[i] = new InternetAddress(tokens[i]);
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
    table.addColumn("threadId");
    table.addColumn("receivedDate");
    table.addColumn("sentDate");
    table.addColumn("subject");
    table.addColumn("to");
    table.addColumn("cc");
    table.addColumn("from");

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

