// Lots of useful data is here!
// https://javamail.java.net/nonav/docs/api/

JSONObject config; // Your IMAP credentials / configuration.
IMAPClient client; // The IMAP client.

void setup()
{
  // Load your email credentials.
  config = loadJSONObject("config.json");

  // Initialize your IMAP client.
  client = new IMAPClient(config);

  // Perform a search.
  // https://support.google.com/mail/answer/7190
  Message[] messages = client.search("saic");

  // Output messages to CSV.
  // Modify the messagesToCSV to choose your columns.
  messagesToCSV(messages, "output.csv");
}

void draw()
{
  background(0);
}


