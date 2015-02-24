import java.text.SimpleDateFormat;

// Output the array of recipients' email addresses with spaces between.
public String recipientsToString(Address[] recipients)
{
  StringBuffer sb = new StringBuffer();

  for (int i = 0; i < recipients.length; ++i)
  {
    sb.append(recipients[i]);

    if (i < recipients.length - 1) 
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
    println(addresses);
//    addresses[i] = new Address(tokens[i]);
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

