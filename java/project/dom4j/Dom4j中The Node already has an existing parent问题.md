# Dom4j中"The Node already has an existing parent"问题

常常需要在两个Document中互相复制Element，可是Dom4j中使用Element.add(Elemnet)方法就会出现出题的错误：

而应用AppendContext()方法，只能将目标元素的内容复制过来，不能将整个元素复制

通过看AbstractElement.java的源码得到解决办法是：调用Element的clone()方法。

root.add((Element) company.clone());



```
public Document createXMLDocument(){
    Document doc = null;
    doc = DocumentHelper.createDocument();
    Element root = doc.addElement("class");
    Element company = root.addElement("company");
    Element person = company.addElement("person");
    person.addAttribute("id","11");
    person.addElement("name").setText("Jack Chen");
    person.addElement("sex").setText("男");
    person.addElement("date").setText("2001-04-01");
    person.addElement("email").setText("[chen@163.com](mailto:chen@163.com)");
    person.addElement("QQ").setText("2366001");
    root.add((Element) company.clone());
    return doc;
}
```

# 美化xml

```
private String xmlPretty(Document document) {
   OutputFormat format = OutputFormat.createPrettyPrint();
   format.setEncoding(document.getXMLEncoding());
   try {
      StringWriter out = new StringWriter();
      XMLWriter writer = new XMLWriter(out, format);
      writer.write(document);
      writer.flush();
      return out.toString();
   } catch (IOException e) {
      String xml = document.asXML();
      log.warn("format xml failed, use doc.asXml(). xml : [{}]", xml);
      return xml;
   }
}
```

# 使用dom4j需要引入的jar 

```
<dependency>
   <groupId>org.dom4j</groupId>
   <artifactId>dom4j</artifactId>
   <version>2.1.1</version>
</dependency>

<dependency><!-- XPath依赖 -->
    <groupId>jaxen</groupId>
    <artifactId>jaxen</artifactId>
    <version>1.1.6</version>
</dependency>
```

缺少jaxen可能会引起下面的错误

![图片](D:\webresource\images\java\project\dom4j\图片.png)