```java
import org.apache.commons.codec.binary.Base64import org.apache.commons.codec.binary.Base64`;
String url="http://img2.mangoerp.com/userbucket/hengxin200888/2020-03-04/1583320367642.jpg";
URL image = null;
try {
  image = new URL(url);
  InputStream inputStream = image.openConnection().getInputStream();
  ByteArrayOutputStream bos = new ByteArrayOutputStream(inputStream.available());
  BufferedInputStream in=new BufferedInputStream(inputStream);
  int buf_size = 1024;
  byte[] buffer = new byte[buf_size];
  int len = 0;
  while (-1 != (len = in.read(buffer, 0, buf_size))) {
    bos.write(buffer, 0, len);
  }
  inputStream.close();
  String string = Base64.encodeBase64String(bos.toByteArray());
  bos.close();
  byte[] bytes = Base64.decodeBase64(string);
  String path="D:/test.jpg";
  FileOutputStream fos = new FileOutputStream(path);
  fos.write(bytes);
  fos.close();
} catch (MalformedURLException e) {
} catch (IOException e) {
}
```