// https://ez-vcard.googlecode.com/svn/javadocs/0.9.6/index.html

import java.util.*;
import java.io.*;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;

try {

  List<VCard> vcards = Ezvcard.parse(createReader("contacts.vcf")).all();

  for (VCard card : vcards)
  {
    List<StructuredName> names = card.getStructuredNames();

    for (StructuredName name : names)
    {
      println(name.getGiven() + " " + name.getFamily());
    }

    List<Email> emails = card.getEmails();

    for (Email email : emails)
    {
      println("\t" + email.getValue());
    }

    List<Photo> photos = card.getPhotos();

    for (Photo photo : photos)
    {
      ImageType contentType = photo.getContentType(); //e.g. "image/jpeg"

      println("\t\t" + photo + " " + contentType);

      String url = photo.getUrl();
      if (url != null) {
        //property value is a URL
        println("\t\t" + url);
      }

      byte[] data = photo.getData();
      if (data != null) {
        InputStream in = new ByteArrayInputStream(data);
        BufferedImage bImage = ImageIO.read(in);
        ImageIO.write(bImage, "jpg", new File(dataPath(random(10000) + ".jpg")));
        //property value is binary data
      }
    }
  }
}
catch (IOException e)
{
}

